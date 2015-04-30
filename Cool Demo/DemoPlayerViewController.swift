//
//  DemoPlayerViewController.swift
//  Cool Demo
//
//  Created by Jonathan Lott on 4/26/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DemoPlayerViewControllerSwift : AVPlayerViewController {

    private var isCompleted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadVideoWithURL(url: NSURL!, delay: NSTimeInterval, completion: (() -> Void)?) {
        self.showsPlaybackControls = false

        self.performBlockOfCode({ () -> Void in

        }, afterDelay: 1.0)

        self.performBlockOfCode({ () -> Void in
            if let asset: AVAsset = AVURLAsset.assetWithURL(url) as? AVAsset {
                let playerItem = AVPlayerItem(asset: asset)
                let player = AVPlayer(playerItem: playerItem)
                player.volume = 0.0
                self.player = player
                self.videoGravity = AVLayerVideoGravityResizeAspectFill

                player.actionAtItemEnd = .None
                self.isCompleted = true

                NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                    if let pItem = notification.object as? AVPlayerItem {
                        pItem.seekToTime(kCMTimeZero)
                    }
                })
                
                completion?()
            }
            }, afterDelay: delay)

    }

}
