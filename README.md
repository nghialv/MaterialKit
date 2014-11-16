MaterialKit
===========
Material design components (inspired by [Google Material Design](http://www.google.com/design/spec/material-design/introduction.html)) for iOS written in Swift

Please feel free to make pull requests.

Features
-----
- Highly customizable
- Complete example
- Supports @IBDesignable to live-render the component in the Interface Builder 
- By suporting @IBInspectable, the class properties can be exposed in the Interface Builder, and you can edit these properties in realtime

- [x] MKButton : floating action button, raised button, flat button, ripple effect 
- [x] MKTextField: ripple effect, floating placeholder
- [x] MKTableViewCell
- [ ] MKTextView (In progress)
- [ ] MKCheckBox
- [ ] MKAlert
- [x] MKLayer
- [x] MKColor

Components
-----
#### MKButton
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKButton.gif" width="365" height="568">
</p>

Custommizable attributes

- `rippleLocation: MKRippleLocation = .TapLocation` : `Center`, `Left`, `Right`
- `maskEnabled: Bool = true`	: `false`
- `circleGrowRatioMax: Float = 0.9`
- `cornerRadius: CGFloat = 2.5`
- `backgroundLayerCornerRadius: CGFloat = 0.0`
- `shadowAniEnabled: Bool = true`
- `backgroundAniEnabled: Bool = true`
- `aniDuration: Float = 0.65`
- `circleAniTimingFunction: MKTimingFunction = .Linear` : `EaseIn`, `EaseOut`, `Custom`
- `backgroundAniTimingFunction: MKTimingFunction = .Linear` : `EaseIn`, `EaseOut`, `Custom`
- `shadowAniTimingFunction: MKTimingFunction = .EaseOut` : `EaseIn`, `EaseOut`, `Custom`
- `circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5)`
- `backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25)`


#### MKTextField
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField.gif" width="365" height="568">
</p>

Custommizable attributes

- `cornerRadius: CGFloat = 2.5`
- `rippleLocation: MKRippleLocation = .TapLocation` : `Center`, `Left`, `Right`
- `padding: CGSize = CGSize(width: 5, height: 5)`
- `floatingLabelBottomMargin: CGFloat = 2.0`
- `floatingPlaceholderEnabled: Bool = false`
- `aniDuration: Float = 0.65`
- `circleAniTimingFunction: MKTimingFunction = .Linear` : `EaseIn`, `EaseOut`, `Custom`
- `circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5)`
- `backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25)`
- `floatingLabelFont: UIFont = UIFont.boldSystemFontOfSize(10.0)`
- `floatingLabelTextColor: UIColor = UIColor.lightGrayColor()`


#### MKTableViewCell
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTableViewCell.gif" width="365" height="568">
</p>

Custommizable attributes

- `rippleLocation: MKRippleLocation = .TapLocation` : `Center`, `Left`, `Right`
- `circleAniDuration: Float = 0.75`
- `circleAniTimingFunction: MKTimingFunction = .Linear` : `EaseIn`, `EaseOut`, `Custom`
- `backgroundAniDuration: Float = 1.0`
- `circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5)`
- `backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25)`

#### MKLayer
A subclass of CALayer.

#### MKColor
A category for UIColor that adds some methods to get flat colors designed by [Google](http://www.google.com/design/spec/style/color.html)

``` swift
	// get color from UIColor
	let lightBlueColor = UIColor.MKColor.LightBlue
```

Requirements
-----
- iOS 7.0+
- Xcode 6.1

License
-----

MaterialKit is released under the MIT license. See LICENSE for details.