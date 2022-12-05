//
//  BasicFullscreenViewController.swift
//  GSPlayer_Example
//
//  Created by Gesen on 2019/4/21.
//  Copyright © 2019 Gesen. All rights reserved.
//

import GSPlayer
import UIKit

class BasicFullscreenViewController: UIViewController {
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var fullscreenPlayerView: VideoFullscreenPlayerView!

    lazy var transitioner: VideoFullscreenTransitioner = {
        loadViewIfNeeded()
        let transition = VideoFullscreenTransitioner()
        transition.fullscreenControls = [closeButton]
        transition.fullscreenPlayerView = fullscreenPlayerView
        transition.fullscreenVideoGravity = .resizeAspect
        return transition
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapClose(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
