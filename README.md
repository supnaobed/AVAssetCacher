![AVAssetCacher](https://github.com/wxxsw/GSPlayer/blob/master/ScreenShots/logo.png)

<p align="center">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift5-f48041.svg?style=flat"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS10+|macOS-blue.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/GSPlayer"><img src="https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=flat"></a>
<a href="https://github.com/wxxsw/GSPlayer/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat"></a>
</p>

## Features

Preload, download and cache your AVURLAsset

## Quick Start

1. Create `MediaDownloader`.
```swift
let downloader = MediaDownloader()
```

2. Create `AVAssetCacher`.
```swift
let cacher = AVAssetCacher(downloader: mediaDownloader)
```

3. Create AVURLAsset.
```swift
let asset = AVURLAsset(url: url, cacher: cacher)
```

4. Play or Preload video.
```swift
downloader.download(url: URL(https://example.com/video.mp4), preloadByteCount: 1024 * 1024)
```

## Installation


```ruby
  pod 'AVAssetCacher', git => https://github.com/supnaobed/AVAssetCacher.git
  
```

## License

The MIT License (MIT)
