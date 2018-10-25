# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BaseProject
def base_pods
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'ObjectMapper'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'KSToastView'
  pod 'Validator'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'KVNProgress'
  pod 'AlamofireImage'
  pod 'Firebase/Core'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
end
  
target 'BaseProject' do
    base_pods
end

target 'BaseProjectTests' do
    inherit! :search_paths
    # Pods for testing
end

  target 'BaseProjectUITests' do
    inherit! :search_paths
    # Pods for testing
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'BaseProject'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
                if config.name == 'Debug' then
                    config.build_settings['OTHER_SWIFT_FLAGS'] = '-DDEBUG'
                    elsif config.name == 'QA' then
                    config.build_settings['OTHER_SWIFT_FLAGS'] = '-DQA'
                    elsif config.name == 'Staging' then
                    config.build_settings['OTHER_SWIFT_FLAGS'] = '-DSTAGING'
                    elsif config.name == 'Production' then
                    config.build_settings['OTHER_SWIFT_FLAGS'] = '-DPRODUCTION'
                    elsif config.name == 'Release' then
                    config.build_settings['OTHER_SWIFT_FLAGS'] = '-DRELEASE'
                end
            end
        end
    end
end

