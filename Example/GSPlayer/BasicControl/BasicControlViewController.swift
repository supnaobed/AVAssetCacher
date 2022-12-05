//
//  BasicControlViewController.swift
//  GSPlayer_Example
//
//  Created by Gesen on 2021/4/17.
//  Copyright © 2021 Gesen. All rights reserved.
//

import GSPlayer
import UIKit

class BasicControlViewController: UIViewController {
    @IBOutlet var playerView: VideoPlayerView!
    @IBOutlet var controlView: GSPlayerControlUIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.contentMode = .scaleAspectFill
        playerView.play(for: URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)

        controlView.populate(with: playerView)
        view.bringSubviewToFront(controlView)
    }
}
