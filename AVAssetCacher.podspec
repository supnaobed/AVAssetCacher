Pod::Spec.new do |s|
  s.name         = 'AVAssetCacher'
  s.version      = '0.2'
  s.summary      = 'Tools for caching AVAsset in AVFoundation'
  s.homepage     = 'https://github.com/supnaobed/AVAssetCacher'
  
  s.license      = 'MIT'
  s.author       = { 'Gesen' => 'i@gesen.me', 'Dinis Ishmukhametov' => 'dinis.ish@gmail.com' }
  s.source       = { :git => 'https://github.com/supnaobed/AVAssetCacher.git', :tag => s.version.to_s }
  
  s.osx.source_files = 'GSPlayer/Classes/Cache/*.swift', 'GSPlayer/Classes/Download/*.swift', 'GSPlayer/Classes/Extension/*.swift', 'GSPlayer/Classes/Loader/*.swift', 'GSPlayer/Classes/MacOS/*.swift'
  s.ios.source_files = 'GSPlayer/Classes/Cache/*.swift', 'GSPlayer/Classes/Download/*.swift', 'GSPlayer/Classes/Extension/*.swift', 'GSPlayer/Classes/Loader/*.swift', 'GSPlayer/Classes/View/*.swift'
  
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = "10.12"
  s.swift_versions = ['5.0']
end
