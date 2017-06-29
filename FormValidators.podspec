#
# Be sure to run `pod lib lint FormValidators.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FormValidators'
  s.version          = '0.2.0'
  s.summary          = 'Validations base value for UITextField.'
  s.homepage         = 'https://github.com/juvs/FormValidators'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Juvenal Guzman' => 'juvenal.guzman@gmail.com' }
  s.source           = { :git => 'https://github.com/juvs/FormValidators.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FormValidators/Classes/**/*'
  
  # s.resource_bundles = {
  #     'FormValidators' => ['FormValidators/Localizations/*.lproj/*.strings']
  #   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
