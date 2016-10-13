#
# Be sure to run `pod lib lint CKAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CKAlertView'
  s.version          = 'v0.1.0'
  s.summary          = 'Custom Mutil Styles Alert View.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Use simple code to display defined multi styles alert view. Detail refer to README.md.
                       DESC

  s.homepage         = 'https://github.com/kaich/CKAlertView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaich' => 'chengkai1853@163.com' }
  s.source           = { :git => 'https://github.com/kaich/CKAlertView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CKAlertView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CKAlertView' => ['CKAlertView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'SnapKit', '~> 3.0'
end
