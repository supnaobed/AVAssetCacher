//
//  URL+Extensions.swift
//  AVAssetCacher
//
//  Created by Dinislam Ishmukhametov on 05.12.2022.
//

import Foundation

extension URL {
  
  func schemePrefix(_ prefix: String) -> URL? {
    let components = NSURLComponents.init(url: self, resolvingAgainstBaseURL: true)
    components?.scheme =  "\(prefix)\(components?.scheme ?? "")"
    return components?.url 
  }
  
}
