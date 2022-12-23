//
//  RequestLoaderURLConverter.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 23.12.2022.
//

import Foundation

final class RequestLoaderURLConverter {
  
  private let loaderPrefix: String
  
  init(loaderPrefix: String = "loader") {
    self.loaderPrefix = loaderPrefix
  }
  
  func cachingURL(_ url: URL) -> URL {
    url.schemePrefix(loaderPrefix) ?? url
  }
 
  func requestURL(_ url: URL) -> URL? {
    let prefix = loaderPrefix
    guard url.absoluteString.hasPrefix(prefix)
    else { return nil }
    return url.absoluteString.replacingOccurrences(of: prefix, with: "").url
  }
  
}

