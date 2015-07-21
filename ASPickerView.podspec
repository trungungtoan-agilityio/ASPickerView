#
# Be sure to run `pod lib lint ASPickerView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ASPickerView"
  s.version          = "0.1.2"
  s.summary          = "The custom UI for UIPicker."
  s.description      = "The custom UI for UIPicker. ASPickerView is available through CocoaPods"
  s.homepage         = "https://github.com/trungung/ASPickerView.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "TrungUng" => "trung.ungtoan@asnet.com.vn" }
  s.source           = { :git => "https://github.com/trungung/ASPickerView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ASPickerView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
