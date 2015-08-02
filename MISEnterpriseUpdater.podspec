#
#  Be sure to run `pod spec lint MISDropdownViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  Any lines starting with a # are optional, but encouraged
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = 'MISEnterpriseUpdater'
  s.version      = '1.0.0'
  s.summary      = 'Simple component to check if an iOS Enterprise build needs an update.'
  s.description  = <<-DESC
                    Simple component to check if an iOS Enterprise build needs an update.

                    MISEnterpriseUpdater uses ARC and supports iOS 7.0+
                   DESC
  s.homepage     = 'https://github.com/maicki/MISEnterpriseUpdater'
  s.license      = 'MIT'
  s.author       = { 'Michael Schneider' => 'mischneider1@gmail.com' }
  # s.social_media_url   = 'http://twitter.com/maicki'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source       = { :git => 'https://github.com/maicki/MISEnterpriseUpdater.git', :tag => s.version.to_s }
  s.source_files = 'MISEnterpriseUpdater-ObjC'
  s.public_header_files = 'MISEnterpriseUpdater-ObjC/**/*.h'
  s.frameworks   = 'UIKit'

end
