//
//  AVAssetCacher.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import AVFoundation

public class AVAssetCacher: NSObject, AVAssetResourceLoaderDelegate {
  private let downloader: MediaDownloader
  
  
  public init(downloader: MediaDownloader) {
    self.downloader = downloader
  }
  
  public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    downloader.loadManager.resourceLoader(resourceLoader, shouldWaitForLoadingOfRequestedResource: loadingRequest)
  }
  
  public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
    downloader.loadManager.resourceLoader(resourceLoader, didCancel: loadingRequest)
  }
  
  public func cancelLoading(asset: AVURLAsset) {
    let url = requestLoaderURLConverter.requestURL(asset.url) ?? asset.url
    downloader.loadManager.cancelLoading(url: url)
  }
  
}

extension AVAssetCacher {
  
  var requestLoaderURLConverter: RequestLoaderURLConverter {
    downloader.requestLoaderURLConverter
  }
  
}
