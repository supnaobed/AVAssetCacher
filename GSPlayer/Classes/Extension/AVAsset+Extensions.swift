//
//  AVAsset+Extensions.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import AVFoundation

public extension AVURLAsset {

  static var loaderPrefix: String = "loader"

  convenience init(url: URL, cacher: AVAssetCacher) {
    let cacheURL = url.schemePrefix(Self.loaderPrefix) ?? url
    self.init(url: cacheURL)
    resourceLoader.setDelegate(cacher, queue: .main)
  }

}
