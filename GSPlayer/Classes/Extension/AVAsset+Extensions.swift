//
//  AVAsset+Extensions.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import AVFoundation

public extension AVURLAsset {
  
  convenience init(url: URL, cacher: AVAssetCacher) {
    let cacheURL = cacher.requestLoaderURLConverter.cachingURL(url)
    self.init(url: cacheURL)
    resourceLoader.setDelegate(cacher, queue: .main)
  }
  
  override func cancelLoading() {
    super.cancelLoading()
    (resourceLoader.delegate as? AVAssetCacher)?.cancelLoading(asset: self)
  }
  
}
