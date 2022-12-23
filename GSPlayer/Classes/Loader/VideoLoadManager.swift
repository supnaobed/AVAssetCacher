//
//  VideoLoaderManager.swift
//  GSPlayer
//
//  Created by Gesen on 2019/4/20.
//  Copyright © 2019 Gesen. All rights reserved.
//

import AVFoundation

protocol VideoLoadManagerDelegate: AnyObject {
  func videoLoadManager(_ videoLoadManager: VideoLoadManager, didRequestResourceFor url: URL)
}

final class VideoLoadManager: NSObject {
  public var reportError: ((Error) -> Void)?
  
  public var customHTTPHeaderFields: ((URL) -> [String: String]?)?
  
  private(set) var loaderMap: [URL: VideoLoader] = [:]
  
  weak var delegate: VideoLoadManagerDelegate?
  
  public var videoCacheManager: VideoCacheManager
  public var requestLoaderURLConverter: RequestLoaderURLConverter

  init(videoCacheManager: VideoCacheManager, requestLoaderURLConverter: RequestLoaderURLConverter) {
    self.videoCacheManager = videoCacheManager
    self.requestLoaderURLConverter = requestLoaderURLConverter
  }
}

extension VideoLoadManager: AVAssetResourceLoaderDelegate {
  public func resourceLoader(_: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    guard let requestUrl = loadingRequest.request.url,
          let url = requestLoaderURLConverter.requestURL(requestUrl) else {
      reportError?(NSError(
        domain: "me.gesen.player.loader",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Unsupported load request (\(loadingRequest))"]
      ))
      return false
    }
    
    delegate?.videoLoadManager(self, didRequestResourceFor: url)
    
    do {
      if let loader = loaderMap[url] {
        loader.append(request: loadingRequest)
      } else {
        let loader = try VideoLoader(url: url, videoCacheManager: videoCacheManager)
        loader.delegate = self
        loader.append(request: loadingRequest)
        loaderMap[url] = loader
      }
      return true
    } catch {
      reportError?(error)
      return false
    }
  }
  
  public func resourceLoader(_: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
    guard let requestUrl = loadingRequest.request.url,
          let url =  requestLoaderURLConverter.requestURL(requestUrl) ,
          let loader = loaderMap[url] else {
      return
    }
    
    loader.remove(request: loadingRequest)
  }
  
}

extension VideoLoadManager: VideoLoaderDelegate {
  func loader(_ loader: VideoLoader, didFail error: Error) {
    reportError?(error)
    loaderMap.removeValue(forKey: loader.url)
  }
  
  func loaderDidFinish(_ loader: VideoLoader) {
    loaderMap.removeValue(forKey: loader.url)
  }
  
}

extension VideoLoadManager {
  
  func cancelLoading(url: URL) {
    loaderMap[url]?.cancel()
  }
  
}
