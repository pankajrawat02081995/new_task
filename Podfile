# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Comezy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Comezy
  pod 'GoogleSignIn', '~> 5.0'  
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'
  pod 'Kingfisher', '~> 7.0'
  pod 'Alamofire'
  pod 'MBProgressHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'AWSS3'
  pod 'SignaturePad'
  pod 'GoogleMaps'
  pod 'GooglePlacePicker'
  pod 'GooglePlaces'
  pod 'SDWebImage'
  pod 'MaterialComponents/Chips'
  pod 'MDFInternationalization'
  pod 'DropDown'
  pod 'iOSPhotoEditor'
  pod 'FirebaseAnalytics'
  pod 'Firebase/DynamicLinks'
  pod 'FirebaseMessaging'
  pod 'FSCalendar'
  pod 'FirebaseFirestore'
  pod 'KVKCalendar'
  pod 'JWTDecode', '~> 3.0'

  post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  config.build_settings['ENABLE_BITCODE'] = 'NO'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
  end
  end



  
  target 'ComezyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ComezyUITests' do
    # Pods for testing
  end

end
