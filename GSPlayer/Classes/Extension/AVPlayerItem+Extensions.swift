//
//  AVPlayerItem+Extensions.swift
//  GSPlayer
//
//  Created by Gesen on 2019/4/21.
//  Copyright © 2019 Gesen. All rights reserved.
//

import AVFoundation

public extension AVPlayerItem {
    var bufferProgress: Double {
        currentBufferDuration / totalDuration
    }

    var currentBufferDuration: Double {
        guard let range = loadedTimeRanges.first else { return 0 }
        return Double(CMTimeGetSeconds(CMTimeRangeGetEnd(range.timeRangeValue)))
    }

    var currentDuration: Double {
        Double(CMTimeGetSeconds(currentTime()))
    }

    var playProgress: Double {
        currentDuration / totalDuration
    }

    var totalDuration: Double {
        Double(CMTimeGetSeconds(asset.duration))
    }
}

extension AVPlayerItem {
    static var loaderPrefix: String = "__loader__"

    var url: URL? {
        guard
            let urlString = (asset as? AVURLAsset)?.url.absoluteString,
            urlString.hasPrefix(AVPlayerItem.loaderPrefix)
        else { return nil }

        return urlString.replacingOccurrences(of: AVPlayerItem.loaderPrefix, with: "").url
    }

    var isEnoughToPlay: Bool {
        return false
    }

    convenience init(loader url: URL) {
        self.init(asset: AVAsset(url: url))
    }
}
