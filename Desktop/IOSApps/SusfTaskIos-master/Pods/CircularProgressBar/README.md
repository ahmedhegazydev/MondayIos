# CircularProgressBar

[![CI Status](https://img.shields.io/travis/arahann.dev@gmail.com/CircularProgressBar.svg?style=flat)](https://travis-ci.org/arahann.dev@gmail.com/CircularProgressBar)
[![Version](https://img.shields.io/cocoapods/v/CircularProgressBar.svg?style=flat)](https://cocoapods.org/pods/CircularProgressBar)
[![License](https://img.shields.io/cocoapods/l/CircularProgressBar.svg?style=flat)](https://cocoapods.org/pods/CircularProgressBar)
[![Platform](https://img.shields.io/cocoapods/p/CircularProgressBar.svg?style=flat)](https://cocoapods.org/pods/CircularProgressBar)

## Example

```
var progress : Float = 0

SwiftProgressBar.addCircularProgressBar(view: self.view, type: 1)

SwiftProgressBar.setProgressColor(color: UIColor.red)

Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in

    if progress <= 100{

        progress = progress + 10

        SwiftProgressBar.setProgress(progress: progress)

    }else{

        SwiftProgressBar.hideProgressBar()
        
    }

}
```
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 10+ 

Xcode 10+

## Installation

CircularProgressBar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CircularProgressBar'
```

## Author

arahann.dev@gmail.com, arahann.dev@gmail.com

## License

CircularProgressBar is available under the MIT license. See the LICENSE file for more info.
