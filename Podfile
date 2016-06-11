# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!



target 'Open42' do
	pod 'OAuthSwift', '~> 0.5.0'
	pod 'Alamofire', '~> 3.3'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
end

target 'Open42Tests' do
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
end

target 'Open42UITests' do

end


# install oauthswift extensions
post_install do |installer|
	installer.pods_project.targets.each do |target|
		if target.name == "OAuthSwift"
			puts "Updating #{target.name} OTHER_SWIFT_FLAGS"
			target.build_configurations.each do |config|
				config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
				if !config.build_settings['OTHER_SWIFT_FLAGS'].include? " \"-D\" \"OAUTH_APP_EXTENSIONS\""
					config.build_settings['OTHER_SWIFT_FLAGS'] << " \"-D\" \"OAUTH_APP_EXTENSIONS\""
				end
			end
		end
	end
end

