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

- [x] MKButton: floating action button, raised button, flat button, ripple effect 
- [x] MKTextField: ripple effect, floating placeholder
- [x] MKTableViewCell
- [x] MKLabel
- [x] MKImageView
- [ ] MKTextView **(Coming Soon)**
- [ ] MKSwitch **(Coming Soon)**
- [ ] MKAlert **(Coming Soon)**
- [ ] MKActivityIndicator **(In progress)**
- [x] MKLayer
- [x] MKColor

Components
-----
#### MKButton
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKButton.gif" width="365" height="568">
</p>

- There are 3 types of main buttons: `Floating Action Button`, `Raised Button`, `Flat Button`
- Custommizable attributes: color, ripple location, animation timing function, animation duration...

``` swift
	let button = MKButton(frame: CGRect(x: 10, y: 10, width: 100, height: 35))
	button.maskEnabled = true
	button.rippleLocation = .TapLocation
	button.circleLayerColor = UIColor.MKColor.LightGreen
```

#### MKTextField
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField.gif" width="365" height="568">
</p>
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField_bottomborder.gif" width="365" height="111">
</p>

- Single-line text field
- Floating placeholder
- Ripple Animation
- Custommizable attributes: color, ripple location, bottom border, animation timing function, animation duration...

``` swift
	textField.rippleLocation = .Left
	textField.floatingPlaceholderEnabled = true
	textField.placeholder = "Description"
	textField.layer.borderColor = UIColor.MKColor.Green.CGColor
	textField.circleLayerColor = UIColor.MKColor.LightGreen
```

#### MKTableViewCell
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTableViewCell.gif" width="365" height="568">
</p>

- Custommizable attributes: color, ripple location, animation timing function, animation duration...

``` swift
	var cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as MyCell
	cell.rippleLocation = .Center
	cell.circleLayerColor = UIColor.MKColor.Blue
```

#### MKLabel, MKImageView (BarButtonItem)
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKBarButtonItem.gif" width="373" height="334">
</p>
 
- Custommizable attributes: color, ripple location, animation timing function, animation duration...

``` swift

```

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
