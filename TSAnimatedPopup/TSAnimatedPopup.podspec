Pod::Spec.new do |spec|

  spec.name         = "TSAnimatedPopup"
  spec.version      = "1.0.0"
  spec.summary      = "This is an interesting animated popup"
  spec.description  = "This is an animated popup that was inspired by Facebook"

  spec.homepage     = "https://github.com/khoapv95/TSAnimatedPopup"
  spec.license      = "MIT"
  spec.author             = { "Khoa Pham" => "khoapv0903@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/khoapv95/TSAnimatedPopup.git", :tag => spec.version.to_s }
  spec.source_files  = "TSAnimatedPopup/**/*.{swift}"
  spec.framework  = "UIKit"
  spec.swift_versions = "5.0"
end
