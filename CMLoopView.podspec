

Pod::Spec.new do |s|
  
  s.name = "CMLoopView"
  s.version      = "0.0.1"
  s.summary      = "简单易用图片轮播"
  s.homepage     = "https://github.com/MyGitHub75/CMLoopView"
  s.license      = "MIT"
  s.author       = { "chen chuan mao" => "chenye.75@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/MyGitHub75/CMLoopView.git", :tag => s.version }
  s.source_files = "CMLoopView/CMLoopView/*.{h,m}"
  s.requires_arc = true
  s.dependency "SDWebImage"

end

