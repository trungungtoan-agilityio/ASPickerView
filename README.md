# ASPickerView

[![CI Status](http://img.shields.io/travis/TrungUng/ASPickerView.svg?style=flat)](https://travis-ci.org/TrungUng/ASPickerView)
[![Version](https://img.shields.io/cocoapods/v/ASPickerView.svg?style=flat)](http://cocoapods.org/pods/ASPickerView)
[![License](https://img.shields.io/cocoapods/l/ASPickerView.svg?style=flat)](http://cocoapods.org/pods/ASPickerView)
[![Platform](https://img.shields.io/cocoapods/p/ASPickerView.svg?style=flat)](http://cocoapods.org/pods/ASPickerView)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ASPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ASPickerView"
```

## Author

TrungUng, trung.ungtoan@asnet.com.vn

## License

ASPickerView is available under the MIT license. See the LICENSE file for more info.

## Using
#### Initialization
#####	Programming

```swift
var timePicker = ASPickerView(frame: CGRectMake(20, 50, 320, 200))
timePicker.backgroundColor = UIColor.whiteColor()
self.view.addSubview(timePicker)
```

####	Xib: 

	Applied IBInspectable
	Set Width/Height and number of coll

	
####	Delegation:

```swift
extension ViewController: ASPickerViewDelegate {
  func datePickerDidChange(hour: NSInteger, minute: NSInteger, second: NSInteger) {
    // Do any additional
    println("Hour: \(hour) - Minute: \(minute) - Second: \(second)")
  }
}
```

## Demo

![alt text](https://github.com/trungung/ASPickerView/blob/develop/demo.gif)
