#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bluebridge.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bluebridge'
  s.version          = '0.0.1'
  s.summary          = 'Bluetooth Low Energy plugin for Flutter.'
  s.description      = <<-DESC
Bluetooth Low Energy plugin for Flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Paul DeMarco' => 'paulmdemarco@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Protobuf', '~> 3.11.4'
  s.platform = :ios, '8.0'
  s.framework = 'CoreBluetooth'

  # s.subspec "Protos" do |ss|
  #   ss.source_files = "Classes/gen/*.pbobjc.{h,m}"
  #   ss.header_mappings_dir = "gen"
  #   ss.requires_arc = false
  #   ss.dependency "Protobuf", '~> 3.11.4'
  # end

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1', }

end
