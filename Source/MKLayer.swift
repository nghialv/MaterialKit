//
//  MKLayer.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

enum MKTimingFunction {
    case Linear
    case EaseIn
    case EaseOut
    case Custom(Float, Float, Float, Float)
    
    var function : CAMediaTimingFunction {
        switch self {
        case .Linear:
            return CAMediaTimingFunction(name: "linear")
        case .EaseIn:
            return CAMediaTimingFunction(name: "easeIn")
        case .EaseOut:
            return CAMediaTimingFunction(name: "easeOut")
        case .Custom(let cpx1, let cpy1, let cpx2, let cpy2):
            return CAMediaTimingFunction(controlPoints: cpx1, cpy1, cpx2, cpy2)
        }
    }
}

class MKLayer {
    private var superLayer: CALayer!
    private let circleLayer = CALayer()
    private let backgroundLayer = CALayer()
    private let maskLayer = CAShapeLayer()

    init(superLayer: CALayer) {
        self.superLayer = superLayer
        
        let superLayerWidth = CGRectGetWidth(superLayer.bounds)
        let superLayerHeight = CGRectGetHeight(superLayer.bounds)
        
        // background layer
        backgroundLayer.frame = superLayer.bounds
        backgroundLayer.opacity = 0.0
        superLayer.addSublayer(backgroundLayer)
        
        // circlelayer
        let circleSize = max(superLayerWidth, superLayerHeight) * 0.9
        let circleCornerRadius = circleSize/2
        
        circleLayer.cornerRadius = circleCornerRadius
        setSubLayerLocationAt(CGPoint(x: superLayerWidth/2, y: superLayerHeight/2))
        backgroundLayer.addSublayer(circleLayer)
        
        // mask layer
        setMaskLayerCornerRadius(superLayer.cornerRadius)
        backgroundLayer.mask = maskLayer
    }
    
    func setupLayer(backgroundColor: UIColor, circleLayerColor: UIColor) {
        backgroundLayer.backgroundColor = backgroundColor.CGColor
        circleLayer.backgroundColor = circleLayerColor.CGColor
    }
    
    func setSubLayerLocationAt(center: CGPoint) {
        let bounds = backgroundLayer.bounds
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        let subSize = max(width, height) * 0.9
        let subX = center.x - subSize/2
        let subY = center.y - subSize/2
        
        // disable animation when changing layer frame
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.frame = CGRect(x: subX, y: subY, width: subSize, height: subSize)
        CATransaction.commit()
    }
    
    func setMaskLayerCornerRadius(cornerRadius: CGFloat) {
        maskLayer.path = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius: cornerRadius).CGPath
    }
   
    func enableMask(enable: Bool = true) {
        backgroundLayer.mask = enable ? maskLayer : nil
    }
    
    // MARK - Animation
    func animateScaleForCircleLayer(fromScale: Float, toScale: Float, timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        let circleLayerAnim = CABasicAnimation(keyPath: "transform.scale")
        circleLayerAnim.fromValue = fromScale
        circleLayerAnim.toValue = toScale
        circleLayerAnim.duration = duration
        circleLayerAnim.timingFunction = timingFunction.function
        circleLayerAnim.removedOnCompletion = false
        circleLayerAnim.fillMode = kCAFillModeForwards
        circleLayer.addAnimation(circleLayerAnim, forKey: nil)
    }
    
    func animateAlphaForBackgroundLayer(timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        let backgroundLayerAnim = CABasicAnimation(keyPath: "opacity")
        backgroundLayerAnim.fromValue = 1.0
        backgroundLayerAnim.toValue = 0.0
        backgroundLayerAnim.duration = duration
        backgroundLayerAnim.timingFunction = timingFunction.function
        backgroundLayer.addAnimation(backgroundLayerAnim, forKey: nil)
    }
}
