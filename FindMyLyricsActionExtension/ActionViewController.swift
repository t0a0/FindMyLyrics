//
//  ActionViewController.swift
//  FindMyLyricsActionExtension
//
//  Created by Igor on 21/08/2017.
//  Copyright © 2017 Fedotov Igor. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let extensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
    let extensionItemProvider = extensionItem.attachments![0] as! NSItemProvider
    if extensionItemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
      weak var weakTextView = self.textView
      extensionItemProvider.loadItem(forTypeIdentifier: (kUTTypePlainText as String), options: nil, completionHandler: { (item, error) in
        if let songUrlString = item as? String {
          let url = URL(string: songUrlString)!
          let storefront = url.pathComponents[1]
          if let songId = self.getQueryStringParameter(url: songUrlString, param: "i") {
            AppleMusicAPIHandler.sharedInstance.getSong(songId: songId, storefront: storefront, completion: { (musicObject, error) in
              MusixMatchAPIHandler.sharedInstance.searchTopTrack(artist: (musicObject?.artist)!, songName: (musicObject?.name)!, completion: { (track, error) in
                MusixMatchAPIHandler.sharedInstance.getLyrics(trackID: (track?.id)!, completion: { (lyrics, error2) in
                  weakTextView?.text = lyrics?.text
                })
              })
            })
          } else {
            weakTextView?.text = "An error occured"
          }
        } else {
          weakTextView?.text = "An error occured"
        }
      })
    }
    
  }
  
  func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func done() {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
  }
  
}
