//
//  VideoCacheManager.swift
//  GSPlayer
//
//  Created by Gesen on 2019/4/20.
//  Copyright © 2019 Gesen. All rights reserved.
//

import Foundation


public struct VideoCacheManager {
  
  private let directory: String
  
  public init (directoryPath: String) throws {
    self.directory = directoryPath
  }
  
  public init (directory: URL) throws {
    self.directory = directory.path
  }
  
  func cachedFilePath(for url: URL) -> String {
    return directory
      .appendingPathComponent(url.absoluteString.md5)
      .appendingPathExtension(url.pathExtension)!
  }
  
  func cachedConfiguration(for url: URL) throws -> VideoCacheConfiguration {
    return try VideoCacheConfiguration
      .configuration(for: cachedFilePath(for: url))
  }
  
  public func calculateCachedSize() -> UInt {
      let fileManager = FileManager.default
      let resourceKeys: Set<URLResourceKey> = [.totalFileAllocatedSizeKey]

      let fileContents = (try? fileManager.contentsOfDirectory(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)) ?? []

      return fileContents.reduce(0) { size, fileContent in
          guard
              let resourceValues = try? fileContent.resourceValues(forKeys: resourceKeys),
              resourceValues.isDirectory != true,
              let fileSize = resourceValues.totalFileAllocatedSize
          else { return size }

          return size + UInt(fileSize)
      }
  }

  public func cleanAllCache() throws {
      let fileManager = FileManager.default
      let fileContents = try fileManager.contentsOfDirectory(atPath: directory)

      for fileContent in fileContents {
          let filePath = directory.appendingPathComponent(fileContent)
          try fileManager.removeItem(atPath: filePath)
      }
  }
  
}
