#if os(macOS)
    import AVFoundation
    import AVKit
    import Cocoa

    open class GSAVPlayerViewController: NSViewController {
        enum NotificationNames {
            static let seekTimeUpdated = "seekTimeUpdatedNotification"
        }

        enum NotificationUserInfoKeys {
            static let currentPlayTime = "currentPlayTime"
        }

        public enum PausedReason: Int {
            /// Pause because the player is not visible, stateDidChanged is not called when the buffer progress changes
            case hidden

            /// Pause triggered by user interaction, default behavior
            case userInteraction

            /// Waiting for resource completion buffering
            case waitingKeepUp
        }

        // MARK: - public

        /// An object that manages a player's visual output.
        public let playerView = AVPlayerView()
        public var player: AVPlayer? {
            get { playerView.player }
            set { playerView.player = newValue }
        }

        /// URL currently playing.
        public private(set) var playerURL: URL?

        /// The reason the video was paused.
        public private(set) var pausedReason: PausedReason = .userInteraction

        /// Played progress, value range 0-1.
        public var playProgress: Double {
            playerView.isReadyForDisplay ? player?.playProgress ?? 0 : 0
        }

        /// Played length in seconds.
        public var currentDuration: Double {
            playerView.isReadyForDisplay ? player?.currentDuration ?? 0 : 0
        }

        public var totalDuration: Double {
            playerView.isReadyForDisplay ? player?.totalDuration ?? 0 : 0
        }

        /// Buffered progress, value range 0-1.
        public var bufferProgress: Double {
            playerView.isReadyForDisplay ? player?.bufferProgress ?? 0 : 0
        }

        /// Buffered length in seconds.
        public var currentBufferDuration: Double {
            playerView.isReadyForDisplay ? player?.currentBufferDuration ?? 0 : 0
        }

        // MARK: - private

        private var isLoaded = false

        private var playerBufferingObservation: NSKeyValueObservation?
        private var playerItemKeepUpObservation: NSKeyValueObservation?
        private var playerItemStatusObservation: NSKeyValueObservation?

        // MARK: - overrides

        override open func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            view.addSubview(playerView)
            playerView.frame = view.bounds
            playerView.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
        }

        override open func loadView() {
            view = NSView()
        }

        override open var representedObject: Any? {
            didSet {
                // Update the view, if already loaded.
            }
        }

        // MARK: - public

        /// Play a video of the specified url.
        ///
        /// - Parameter url: Can be a local or remote URL
        open func play(for url: URL) {
            guard playerURL != url else {
//            pausedReason = .waitingKeepUp
                player?.play()
                return
            }

            stop()

            playerView.player = AVPlayer()
            player?.automaticallyWaitsToMinimizeStalling = false

            let playerItem = AVPlayerItem(loader: url)
            playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true

            playerURL = url
//        self.pausedReason = .waitingKeepUp

            if playerItem.isEnoughToPlay || url.isFileURL {
                player?.play()
            }

            player?.replaceCurrentItem(with: playerItem)

            observe(playerItem: playerItem)
        }

        open func stop() {
            observe(playerItem: nil)

            player?.currentItem?.cancelPendingSeeks()
            player?.currentItem?.asset.cancelLoading()

            player?.pause()
        }

        open func seekTime(duration: UInt64) {
            let time = CMTime(seconds: Double(duration), preferredTimescale: 1)
            player?.seek(to: time)
        }

        func observe(playerItem: AVPlayerItem?) {
            guard let playerItem = playerItem else {
                playerBufferingObservation = nil
                playerItemStatusObservation = nil
                playerItemKeepUpObservation = nil
                return
            }

            playerBufferingObservation = playerItem.observe(\.loadedTimeRanges) { [unowned self] _, _ in

                if self.bufferProgress >= 0.99 || (self.currentBufferDuration - self.currentDuration) > 3 {
                    VideoPreloadManager.shared.start()
                } else {
                    VideoPreloadManager.shared.pause()
                }
            }

            playerItemStatusObservation = playerItem.observe(\.status) { item, _ in
                if item.status == .failed, let error = item.error as NSError? {
                    print("error happens \(error)")
                }
            }

            playerItemKeepUpObservation = playerItem.observe(\.isPlaybackLikelyToKeepUp) { [unowned self] item, _ in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Self.NotificationNames.seekTimeUpdated), object: nil, userInfo: [Self.NotificationUserInfoKeys.currentPlayTime: currentDuration])
                if item.isPlaybackLikelyToKeepUp {
                    if self.player?.rate == 0, self.pausedReason == .waitingKeepUp {
                        self.player?.play()
                    }
                }
            }
        }
    }
#endif
