//
//  MediaDownloadTask.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import Foundation

public class MediaDownloadTask {
    public let url: URL
    private var downloader: VideoDownloader
    private let preloadByteCount: Int

    init(url: URL, preloadByteCount: Int, cacheHandler: VideoCacheHandler) {
        self.url = url
        self.preloadByteCount = preloadByteCount
        downloader = VideoDownloader(url: url, cacheHandler: cacheHandler)
    }

    func start() {
        downloader.download(from: 0, length: preloadByteCount)
    }

    public func cancel() {
        downloader.cancel()
    }
}
