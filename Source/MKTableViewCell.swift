//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class MKTableViewCell : UITableViewCell {
    @IBInspectable var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable var circleAniDuration: Float = 0.75
    @IBInspectable var backgroundAniDuration: Float = 1.0
    @IBInspectable var circleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable var shadowAniEnabled: Bool = true
    
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
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.contentView.layer)
    private var didResizeContentView = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    func setupLayer() {
        self.selectionStyle = .None
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(circleLayerColor)
        mkLayer.circleGrowRatioMax = 1.2
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if let firstTouch = touches.anyObject() as? UITouch {
            if !didResizeContentView {
                mkLayer.superLayerDidResize()
            }
            mkLayer.didChangeTapLocation(firstTouch.locationInView(self.contentView))
            
            mkLayer.animateScaleForCircleLayer(0.65, toScale: 1.0, timingFunction: circleAniTimingFunction, duration: CFTimeInterval(circleAniDuration))
            mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: CFTimeInterval(backgroundAniDuration))
        }
    }
}
