# AppResizer

Check if your app is responsive.


## Description

AppResizer allows you to change the width of the main window, thereby checking if your app renders correctly on all devices.

This tool will also help you to test if you are ready to activate the multitasking on your app.


## Demo

![Demo](https://raw.githubusercontent.com/octo-technology/AppResizer/master/Screenshots/Demo.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first. 
You can also use the cocoapods `try` command:

```ruby
pod try "AppResizer"
```


## Installation

AppResizer is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "AppResizer"
```


## Usage

```swift
AppResizer.sharedInstance.enable(mainWindow)
```


## Author

Ahmed Mseddi, amseddi@octo.com


## License

AppResizer is available under the MIT license. See the LICENSE file for more info.
