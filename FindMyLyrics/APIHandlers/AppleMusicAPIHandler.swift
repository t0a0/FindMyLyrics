//
//  AppleMusicAPIHandler.swift
//  LyricsFinder
//
//  Created by Igor on 20/08/2017.
//  Copyright © 2017 Fedotov Igor. All rights reserved.
//

import Foundation
import Alamofire


class AppleMusicAPIHandler: NSObject {
  
  private let parsingError = NSError(domain: "AppleMusicAPIHandler", code: 0, userInfo: ["Error description" : "parsing error"])

  private let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjU3SkVZWUJNRkwifQ.eyJpc3MiOiI0NzZEUENHWjI1IiwiaWF0IjoxNTAzMzMwNzU5LCJleHAiOjE1MDMzNzM5NTl9.TI949xZ1tLFl0CPwh2a0fV_xTnAC9E5iroKlhJVI6sd9bObGVfU0fR5mGpfBfLa8sU8WmbuJsD1-ojMTZjwWFg"
  
  static let sharedInstance = AppleMusicAPIHandler()
  
  override init() {
    super.init()
    
  }
  
  func getSong(songId: String, storefront: String, completion:@escaping (_ song: AppleMusicSongObject?,_ error: NSError?) -> Void) {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(self.developerToken)"
    ]
    let str = "https://api.music.apple.com/v1/catalog/\(storefront)/songs/\(songId)"
    Alamofire.request(str, headers: headers).validate().responseJSON { (response) in
      if let unwrappedResponse = response.value as? NSDictionary {
        completion (AppleMusicSongObject(dictionary: unwrappedResponse), nil)
      } else {
        completion(nil, self.parsingError)
      }
    }
    }
  
}

class AppleMusicSongObject : NSObject {
  
  var id: String
  var name: String
  var artist: String
  
  override var description: String {
    return "AppleMusicSongObject\nid: \(id)\nname: \(name)\nartist: \(artist)"
  }
  
  init?(dictionary: NSDictionary) {
    if let data = dictionary["data"] as? NSArray {
      if let data1 = data.lastObject as? NSDictionary {
        if let attributes = data1["attributes"] as? NSDictionary {
          self.artist = attributes["artistName"] as! String
          self.name = attributes["name"] as! String
        } else {
          return nil
        }
        if let songId = data1["id"] as? String {
          self.id = songId
        } else {
          return nil
        }
      } else {
        return nil
      }
    } else {
      return nil
    }
    super.init()
  }
}
