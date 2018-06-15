#
# Be sure to run `pod lib lint MotionDnaSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MotionDnaSDK'
  s.version='1.5.0'
  s.summary          = 'MotionDnaSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/navisens/MotionDnaSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Navisens, Inc' => 'lucas.mckenna@navisens.com' }
  s.source           = { :git => 'https://github.com/navisens/MotionDnaSDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/navisens'

  s.ios.deployment_target = '9.1'

  s.preserve_paths = 'MotionDnaSDK.framework'

  s.source_files = 'MotionDnaSDK.framework/Versions/A/Headers/**/*{.h,.hpp}'
  s.public_header_files = 'MotionDnaSDK.framework/Versions/A/Headers/**/*{.h,.hpp}'
  s.vendored_frameworks = 'MotionDnaSDK.framework'
  s.header_dir = 'MotionDnaSDK'
  # s.resource_bundles = {
  #   'MotionDnaSDK' => ['MotionDnaSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'AVFoundation', 'Accelerate', 'CoreBluetooth', 'CoreData', 'CoreGraphics', 'CoreLocation', 'CoreText', 'GLKit', 'ImageIO', 'OpenGLES', 'QuartzCore', 'Security', 'SystemConfiguration'
  # s.dependency 'AFNetworking', '~> 2.3'
end
