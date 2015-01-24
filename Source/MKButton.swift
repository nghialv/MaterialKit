//
//  MKButton.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

enum MKButtonType {
    case Raised
    case FloatingAction
    case Flat
    case FlatRaised
}
@IBDesignable
class MKButton : UIButton
{
    @IBInspectable var maskEnabled: Bool = true {
        didSet {
            mkLayer.enableMask(enable: maskEnabled)
        }
    }
    @IBInspectable var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable var circleGrowRatioMax: Float = 0.9 {
        didSet {
            mkLayer.circleGrowRatioMax = circleGrowRatioMax
        }
    }
    @IBInspectable var backgroundLayerCornerRadius: CGFloat = 0.0 {
        didSet {
            mkLayer.setBackgroundLayerCornerRadius(backgroundLayerCornerRadius)
        }
    }
    // animations
    @IBInspectable var shadowAniEnabled: Bool = true
    @IBInspectable var backgroundAniEnabled: Bool = true {
        didSet {
            if !backgroundAniEnabled {
                mkLayer.enableOnlyCircleLayer()
            }
        }
    }
    @IBInspectable var aniDuration: Float = 0.65
    @IBInspectable var circleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable var backgroundAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable var shadowAniTimingFunction: MKTimingFunction = .EaseOut
    
    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(circleLayerColor)
        }
    }
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    
    // Button type.
    @IBInspectable var mkButtonType : MKButtonType = .Raised {
        didSet {
            self.setUpLayerForType()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    init(type : MKButtonType) {
        super.init()
        setupLayer()
        self.mkButtonType = type
        self.setUpLayerForType()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - setup methods
    private func setupLayer() {
        adjustsImageWhenHighlighted = false
        self.cornerRadius = 2.5
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(circleLayerColor)
    }
    
    private func setUpLayerForType(){
        switch (self.mkButtonType) {
        case .Raised:
            self.configureRaisedButton()
        case .FloatingAction:
            self.configureFloatingActionButton()
        case .Flat:
            self.configureFlatButton()
        case .FlatRaised:
            self.configureFlatRaisedButton()
        default:
            break
        }
    }
    
    private func configureFlatRaisedButton() {
        
        // Taken from example project
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
    }
    private func configureFlatButton() {
        
        // Taken from example project.
        self.maskEnabled = false
        self.circleGrowRatioMax = 0.5
        self.backgroundAniEnabled = false
        self.rippleLocation = .Center
    }
    private func configureRaisedButton() {
        
        // Taken from example project.
        self.layer.shadowOpacity = 0.55
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
    
    private func configureFloatingActionButton() {
        
        // Taken from example project.
        self.cornerRadius = 40.0
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 3.5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
    }
    
    
    // MARK - location tracking methods
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if rippleLocation == .TapLocation {
            mkLayer.didChangeTapLocation(touch.locationInView(self))
        }
        
        // circleLayer animation
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: circleAniTimingFunction, duration: CFTimeInterval(aniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnabled {
            mkLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(aniDuration))
        }
        
        // shadow animation for self
        if shadowAniEnabled {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            
            //if mkType == .Flat {
            //    mkLayer.animateMaskLayerShadow()
            //} else {
            mkLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: shadowAniTimingFunction, duration: CFTimeInterval(aniDuration))
            //}
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
}
