# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!
target '100DaysForEnglish' do
pod 'Alamofire', '~> 3.5.0'
pod 'MagicalRecord', '~> 2.3'
pod 'ReachabilitySwift', '~> 2.3.3'
pod 'IQKeyboardManagerSwift', '4.0.5'
pod 'MBProgressHUD', '~> 1.0.0'
pod 'Reachability', '~> 3.2'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'Google/SignIn'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end