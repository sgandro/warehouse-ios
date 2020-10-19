
workspace 'warehouse.xcworkspace'
platform :ios, '14.0'

# ignore all warnings from all pods

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
#use_modular_headers!

def all_pods
    pod 'Realm'
    pod 'RealmSwift'
    pod 'Alamofire'
    pod 'SwiftKeychainWrapper'
end

target 'warehouse' do
  project 'warehouse.xcodeproj'
  inherit! :search_paths
  all_pods
  #pod 'SideMenu', '~> 6.0' # https://github.com/jonkykong/SideMenu
  pod 'SideMenuSwift' # https://github.com/kukushi/SideMenu
  pod 'iCarousel' # https://github.com/nicklockwood/iCarousel
  pod 'MGCollapsingHeader' # https://github.com/mattga/MGCollapsingHeader
  #pod 'FSCalendar' # https://github.com/WenchaoD/FSCalendar
  #pod 'Firebase/Core'
  #pod 'Firebase/Messaging'
  #pod 'Firebase/Crashlytics'
  #pod 'Firebase/Analytics'

end


target 'AlmaFramework-iOS' do
  project 'AlmaFramework-iOS/AlmaFramework-iOS.xcodeproj'
  inherit! :search_paths

  all_pods
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_NO_PIE'] = 'NO'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
    sharedLibrary = installer.aggregate_targets.find { |aggregate_target| aggregate_target.name == 'Pods-[MY_FRAMEWORK_TARGET]' }
    installer.aggregate_targets.each do |aggregate_target|
        if aggregate_target.name == 'Pods-[MY_APP_TARGET]'
            aggregate_target.xcconfigs.each do |config_name, config_file|
                sharedLibraryPodTargets = sharedLibrary.pod_targets
                aggregate_target.pod_targets.select { |pod_target| sharedLibraryPodTargets.include?(pod_target) }.each do |pod_target|
                    pod_target.specs.each do |spec|
                        frameworkPaths = unless spec.attributes_hash['ios'].nil? then spec.attributes_hash['ios']['vendored_frameworks'] else spec.attributes_hash['vendored_frameworks'] end || Set.new
                        frameworkNames = Array(frameworkPaths).map(&:to_s).map do |filename|
                            extension = File.extname filename
                            File.basename filename, extension
                        end
                    end
                    frameworkNames.each do |name|
                        if name != '[DUPLICATED_FRAMEWORK_1]' && name != '[DUPLICATED_FRAMEWORK_2]'
                            raise("Script is trying to remove unwanted flags: #{name}. Check it out!")
                        end
                        puts "Removing #{name} from OTHER_LDFLAGS"
                        config_file.frameworks.delete(name)
                    end
                end
            end
            xcconfig_path = aggregate_target.xcconfig_path(config_name)
            config_file.save_as(xcconfig_path)
        end
    end
end


