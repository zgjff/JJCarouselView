@version = "0.1.1"
Pod::Spec.new do |spec|
  spec.name         = "JJCarouselView"
  spec.version      = @version
  spec.summary      = "Swift简单好用、易于扩展的轮播图框架."
  spec.description  = "适用于Swift的简单好用、易于扩展的轮播图框架."
  spec.homepage     = "https://github.com/zgjff/JJCarouselView"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "zgjff" => "zguijie1005@163.com" }
  spec.source       = { :git => "https://github.com/zgjff/JJCarouselView.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/*.swift', 'Sources/**/*.{swift}'
  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
end
