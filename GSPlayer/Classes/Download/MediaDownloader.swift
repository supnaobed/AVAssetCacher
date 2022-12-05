//
//  MediaDownloader.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import AVKit

public class MediaDownloader {
  private var mediaTasks = [MediaDownloadTask]()
  let loadManager: VideoLoadManager
  
  public init() {
    loadManager = VideoLoadManager()
    loadManager.delegate = self
  }
  
  public func download(url: URL, preloadByteCount: Int) throws -> MediaDownloadTask? {
    let videoCacheHandler = try VideoCacheHandler(url: url)
    
    let task = MediaDownloadTask(url: url, preloadByteCount: preloadByteCount, cacheHandler: videoCacheHandler)
    guard !loadManager.loaderMap.keys.contains(url) else {
      return task
    }
    task.start()
    mediaTasks.append(task)
    return task
  }
}

extension MediaDownloader: VideoLoadManagerDelegate {
  func videoLoadManager(_: VideoLoadManager, didRequestResourceFor url: URL) {
    let task = mediaTasks.first { $0.url == url }
    task?.cancel()
  }
}

extension MediaDownloader: VideoDownloaderDelegate {
  public func downloader(_: VideoDownloader, didReceive _: URLResponse) {}
  
  public func downloader(_: VideoDownloader, didReceive _: Data) {}
  
  public func downloader(_: VideoDownloader, didFinished _: Error?) {}
}


