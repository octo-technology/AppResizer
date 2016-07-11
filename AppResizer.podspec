Pod::Spec.new do |s|
  s.name             = "AppResizer"
  s.version          = "0.1.1"
  s.summary          = "Check if your app is responsive"

  s.description      = <<-DESC

AppResizer allows you to change the width of the main window, thereby checking if your app renders correctly on all devices.

This tool will also help you to test if you are ready to activate the multitasking on your app.

                       DESC

  s.homepage         = "https://github.com/octo-technology/AppResizer"
  s.screenshots     = "https://raw.githubusercontent.com/octo-technology/AppResizer/master/Screenshots/Screenshot_1.png", "https://raw.githubusercontent.com/octo-technology/AppResizer/master/Screenshots/Screenshot_1.png"
  s.license          = 'MIT'
  s.author           = { "Ahmed Mseddi" => "amseddi@octo.com" }
  s.source           = { :git => "https://github.com/octo-technology/AppResizer.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
