//
//  MKProgressView.swift
//  MaterialKit
//
//  Created by Raza Robson on 2015-11-04.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//

import Foundation
import UIKit
import Darwin

/// An indeterminate, animated circular progress View
@IBDesignable
class MKProgressView : UIView {

    private let shapeLayer = MKPogressLayer()
    
    /// Line Color. Animatable.
    @IBInspectable var lineColor:UIColor {
        get{
            return shapeLayer.lineColor
        } set(color) {
            shapeLayer.lineColor = color
        }
    }
    
    /// Line Width. Animatable.
    @IBInspectable var lineWidth:CGFloat {
        get{
            return shapeLayer.lineWidth
        } set(lineWidth) {
            shapeLayer.lineWidth = lineWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
    }
    
    override func animationDidStop(anim: CAAnimation, finished: Bool) {
        if(finished){
            startNextCircleAnimation()
        }
    }
    
    override func didMoveToWindow() {
        if(self.window != nil){
            startNextCircleAnimation()
            shapeLayer.addAnimation(rotationAnimation(), forKey: "rotationAnimation")
        }
    }
    
    private func startNextCircleAnimation() {
        let circleAnimation = shapeLayer.nextCircleAnimation()
        circleAnimation.delegate = self
        shapeLayer.addAnimation(circleAnimation, forKey: "circleAnimation")
        shapeLayer.updateState()
    }
    
    private func rotationAnimation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = 2
        animation.repeatCount = Float.infinity
        return animation
    }
}