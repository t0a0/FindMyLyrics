//
//  MusixMatchAPIHandler.swift
//  LyricsFinder
//
//  Created by Igor on 20/08/2017.
//  Copyright © 2017 Fedotov Igor. All rights reserved.
//

import Foundation
import Alamofire

class MusixMatchAPIHandler: NSObject {
  static let sharedInstance = MusixMatchAPIHandler()
  private let parsingError = NSError(domain: "MusixMatchAPIHandler", code: 0, userInfo: ["Error description" : "parsing error"])
  private let apikey = "d44e3806c44be4342ef8a7623a4a5957"
  
  override init() {
    super.init()
  }
  
  func searchTopTrack(artist: String, songName: String, completion:@escaping (_ tracks: [MusixMatchTrackObject]?,_ error: NSError?) -> Void) {
    let reqString = "http://api.musixmatch.com/ws/1.1/track.search"
    let parameters = ["q_artist" : artist,
                      "q_track" : songName,
                      "apikey" : apikey]
    Alamofire.request(reqString, parameters: parameters).validate().responseJSON { (response) in
      if let responseDict = response.value as? NSDictionary {
        if let trackList = responseDict.value(forKeyPath: "message.body.track_list") as? NSArray {
          var foundTrackObjects = [MusixMatchTrackObject]()
          for case let trackDictionary as NSDictionary in trackList {
            if let musicObject = MusixMatchTrackObject(dictionary: trackDictionary) {
              foundTrackObjects.append(musicObject)
            }
          }
          completion(foundTrackObjects, nil)
        } else {
          completion(nil, self.parsingError)
        }
      } else {
        completion (nil, self.parsingError)
      }
    }
  }
  
  func getLyrics(trackID: String, completion:@escaping (_ lyrics: MusixMatchLyricsObject?,_ error: NSError?) -> Void) {
    let reqString = "http://api.musixmatch.com/ws/1.1/track.lyrics.get"
    let parameters = ["track_id" : trackID,
                      "apikey" : apikey]
    Alamofire.request(reqString, parameters: parameters).validate().responseJSON { (response) in
      if let responseDict = response.value as? NSDictionary {
        if let lyricsDict = responseDict.value(forKeyPath: "message.body.lyrics") as? NSDictionary {
          completion (MusixMatchLyricsObject(dictionary: lyricsDict), nil)
        } else {
          completion (nil, self.parsingError)
        }
      } else {
        completion (nil, self.parsingError)
      }
    }
  }
  
  class MusixMatchTrackObject:NSObject {
    
    var id: String
    var hasLyrics: Bool
    
    override var description: String {
      return "MusixMatchTrackObject\nid: \(id)\nhasLyrics: \(hasLyrics)"
    }
    
    init?(dictionary: NSDictionary) {
      if let trackData = dictionary["track"] as? NSDictionary {
        self.id = (trackData["track_id"] as! NSNumber).stringValue
        self.hasLyrics = trackData["has_lyrics"] as! Bool
      } else {
        return nil
      }
      super.init()
    }
  }
  class MusixMatchLyricsObject:NSObject {
    var id: String
    var text: String
    
    override var description: String {
      return "MusixMatchLyricsObject\nid: \(id)\nhasLyrics: \(text)"
    }
    
    init?(dictionary: NSDictionary) {
      self.id = (dictionary["lyrics_id"] as! NSNumber).stringValue
      self.text = dictionary["lyrics_body"] as! String
      super.init()
    }
  }
}
