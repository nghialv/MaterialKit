//
//  MKProgressView.swift
//  Cityflo
//
//  Created by Rahul Iyer on 03/11/15.
//  Copyright © 2015 Cityflo. All rights reserved.
//

import UIKit

@IBDesignable
open class MKActivityIndicator: UIView {
    
    fileprivate let drawableLayer = CAShapeLayer()
    fileprivate var animating = false
    
    @IBInspectable open var color: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            drawableLayer.strokeColor = self.color.cgColor
        }
    }
    
    @IBInspectable open var lineWidth: CGFloat = 6 {
        didSet {
            drawableLayer.lineWidth = self.lineWidth
            self.updatePath()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }
    
    open func startAnimating() {
        if self.animating {
            return
        }
        
        self.animating = true
        self.isHidden = false
        self.resetAnimations()
    }
    
    open func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        self.animating = false
        self.isHidden = true
    }
    
    fileprivate func setup() {
        self.isHidden = true
        self.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = self.color.cgColor
        self.drawableLayer.lineWidth = self.lineWidth
        self.drawableLayer.fillColor = UIColor.clear.cgColor
        self.drawableLayer.lineCap = kCALineJoinRound
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }
    
    fileprivate func updateFrame() {
        self.drawableLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    fileprivate func updatePath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width, self.bounds.height) / 2 - self.lineWidth
        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true)
            .cgPath
    }
    
    fileprivate func resetAnimations() {
        drawableLayer.removeAllAnimations()
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = 2 * M_PI
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.isRemovedOnCompletion = false
        
        let startHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        startHeadAnim.beginTime = 0.1
        startHeadAnim.fromValue = 0
        startHeadAnim.toValue = 0.25
        startHeadAnim.duration = 1
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        startTailAnim.beginTime = 0.1
        startTailAnim.fromValue = 0
        startTailAnim.toValue = 1
        startTailAnim.duration = 1
        startTailAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnim.beginTime = 1
        endHeadAnim.fromValue = 0.25
        endHeadAnim.toValue = 0.99
        endHeadAnim.duration = 0.5
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnim.beginTime = 1
        endTailAnim.fromValue = 1
        endTailAnim.toValue = 1
        endTailAnim.duration = 0.5
        endTailAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let strokeAnimGroup = CAAnimationGroup()
        strokeAnimGroup.duration = 1.5
        strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
        strokeAnimGroup.repeatCount = Float.infinity
        strokeAnimGroup.isRemovedOnCompletion = false
        
        self.drawableLayer.add(rotationAnim, forKey: "rotation")
        self.drawableLayer.add(strokeAnimGroup, forKey: "stroke")
    }
}
