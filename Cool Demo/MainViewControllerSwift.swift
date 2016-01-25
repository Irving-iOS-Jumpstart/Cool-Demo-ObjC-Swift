//
//  MainViewControllerSwift.swift
//  Cool Demo
//
//  Created by Jonathan Lott on 4/28/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

extension String {
    func urlValue() -> NSURL? {
        var url: NSURL?

        if self.characters.count > 0 {
            url = NSURL(string: self)

            if url == nil {
                url = NSURL(fileURLWithPath: self)
            }
        }
        return url
    }

    func pathInBundle() -> String? {
        var fullPath: String?
        if self.characters.count > 0  {
            fullPath = NSBundle.mainBundle().pathForResource((self as NSString).stringByDeletingPathExtension, ofType: (self as NSString).pathExtension) ?? nil
        }
        return fullPath
    }
}

class MainViewControllerSwift: UIViewController {
    lazy var videoPlayers: [DemoPlayerViewControllerSwift] = {
        let players = [DemoPlayerViewControllerSwift]()
        return players
        }()

    var completedCount: Int = 0;
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.setupVideos()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.animateVideos()
    }

    func cleanupVideos() {
        for playerVC in self.videoPlayers {
            playerVC.view.removeFromSuperview()
        }
        self.completedCount = 0
        self.updateProgressView()
    }

    func setupVideos() {
        self.cleanupVideos()
        let filePaths = [kVideoURL, kVideoURL, kVideoURL, kVideoURL]
        for (idx, filePath) in filePaths.enumerate() {
            let fullPath = filePath.pathInBundle() ?? filePath
            let playerVC = DemoPlayerViewControllerSwift()
            self.videoPlayers.append(playerVC)
            if let url = fullPath.urlValue() {
                playerVC.loadVideoWithURL(url, delay: NSTimeInterval(idx * 2), completion: { () -> Void in
                    self.completedCount++
                    self.videoSetupCompleted(playerVC)
                    playerVC.player?.play()
                })
            }
        }

         //start with players outside of bounds and then animate them in on did appear
        for (idx, playerVC) in self.videoPlayers.enumerate() {
            let width: CGFloat = self.view.frame.size.width / 2.0
            let height: CGFloat = CGFloat(width * 3.0/4.0)
            let offset: CGFloat = CGFloat(idx / 2)
            var playerFrame = CGRectMake(0, offset * height, width, height)
            playerFrame.origin.x = idx % 2 == 0 ? -playerFrame.size.width : self.view.bounds.size.width + playerFrame.size.width;

            playerVC.view.frame = playerFrame
            self.view.addSubview(playerVC.view)
        }

    }

    func updateProgressView() {
        let progress: Float = self.videoPlayers.count > 0 ? Float(self.completedCount) / Float(self.videoPlayers.count) : 0.0
        self.progressView.progress = progress
        self.progressLabel.text = String(format:"%.0f%%", progress * 100.0)
    }

    func videoSetupCompleted(playerVC: DemoPlayerViewControllerSwift) {
        self.updateProgressView()
    }


    func animateVideos() {
        for (idx, playerVC) in self.videoPlayers.enumerate() {
            let width: CGFloat = self.view.frame.size.width / 2.0
            let height: CGFloat  = CGFloat(width * 3.0/4.0)
            let offsetY: CGFloat  = CGFloat(idx % 2)
            let offsetX: CGFloat  = CGFloat(idx / 2)

            let playerFrame = CGRectMake(offsetX * width, offsetY * height + self.view.center.y/2, width, height)

            playerVC.view.autoresizingMask = .None
            playerVC.player?.play()
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                playerVC.view.frame = playerFrame
                }, completion: nil)
        }
    }
    
    @IBAction func repeatAnimation(sender: AnyObject) {
        self.setupVideos()
        self.performBlockOfCode({ () -> Void in
            self.animateVideos()
        }, afterDelay: 1.0)
    }

}
