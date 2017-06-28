Pod::Spec.new do |s|
  s.name             = 'MPAudioRecorder'
  s.version          = '0.1.0'
  s.summary          = 'By far the most fantastic view I have seen in my entire life. No joke.'

  s.description      = <<-DESC
This is a library with which you can perform an *Audio Recording* into your application, it is fully customizable, you can pass Audio settings in it. 
                       DESC

  s.homepage         = 'https://github.com/manish-1988/MPAudioRecorder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manish Kumar Pathak' => 'manishpathakbabu@gmail.com' }
  s.source           = { :git => 'https://github.com/manish-1988/MPAudioRecorder.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'AudioFunctions/MPAudioRecorder/*'

end