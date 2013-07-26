TRSDialScrollView
=================

[![Version](https://cocoapod-badges.herokuapp.com/v/TRSDialScrollView/badge.svg)](https://cocoapod-badges.herokuapp.com/v/TRSDialScrollView/badge.svg)
[![Platform](https://cocoapod-badges.herokuapp.com/p/TRSDialScrollView/badge.svg)](https://cocoapod-badges.herokuapp.com/p/TRSDialScrollView/badge.svg)

This is a custom UIScrollView that I used for one of my apps.
It's a customizable dial control for all your control displaying needs.
Includes customization through UIAppearance for all major properties.

![Dial Example](./images/TRSDialScrollView.png)

## TODO

 * Still need to add support for AutoLayout and it has all of the normal pitfalls when using UIScrollViews with AutoLayout.

## Installation

To add TRSDialView to your project, add the following to your Podfile:

```ruby
playform :ios

pod 'TRSDialScrollView', '>= 1.0'
```


## Usage

```objective-c

- (void) viewDidLoad
{
  [super viewDidLoad];

  // Set the numeric range for the dial
  [self.dialView setDialRangeFrom:0 to:50];

  // Set the default value
  self.dialView.currentValue = 20;
}

- (void)someOtherMethod
{
  NSInteger value = self.dialView.currentValue;
}
```

## Credits

[Kevin Kirkup](https://github.com/kevinkirkup)([@pan_and_scan](http://twitter.com/pan_and_scan))

## License

`TRSDialScrollView` is distributed under the [MIT License](http://opensource.org/licenses/MIT).

