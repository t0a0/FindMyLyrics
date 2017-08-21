# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def shared_pods
  pod 'Alamofire', '~> 4.4'
end

target 'FindMyLyrics' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FindMyLyrics
  shared_pods

  target 'FindMyLyricsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FindMyLyricsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'FindMyLyricsActionExtension' do
  use_frameworks!
	shared_pods
end
