Pod::Spec.new do |s|
  s.name             = 'MPAudioRecorder'
  s.version          = '0.1.2'
  s.summary          = 'Adding Audio recording feature in iOS app is never been that easy'

  s.description      = <<-DESC
This is a library with which you can perform an *Audio Recording* into your application, it is fully customizable, you can pass Audio settings in it.  Merging and split features are coming soon.
                       DESC

  s.homepage         = 'https://github.com/manish-1988/MPAudioRecorder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manish Kumar Pathak' => 'manishpathakbabu@gmail.com' }
  s.source           = { :git => 'https://github.com/manish-1988/MPAudioRecorder.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'AudioFunctions/MPAudioRecorder/*'

end