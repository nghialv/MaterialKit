//
//  MKProgressView.swift
//  Cityflo
//
//  Created by Rahul Iyer on 03/11/15.
//  Copyright © 2015 Cityflo. All rights reserved.
//

import UIKit

@IBDesignable
public class MKActivityIndicator: UIView {

    private let drawableLayer = CAShapeLayer()
    private var animating = false

    @IBInspectable public var color: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            drawableLayer.strokeColor = self.color.CGColor
        }
    }

    @IBInspectable public var lineWidth: CGFloat = 6 {
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

    public override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }

    public func startAnimating() {
        if self.animating {
            return
        }

        self.animating = true
        self.hidden = false
        self.resetAnimations()
    }

    public func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        self.animating = false
        self.hidden = true
    }

    private func setup() {
        self.hidden = true
        self.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = self.color.CGColor
        self.drawableLayer.lineWidth = self.lineWidth
        self.drawableLayer.fillColor = UIColor.clearColor().CGColor
        self.drawableLayer.lineCap = kCALineJoinRound
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }

    private func updateFrame() {
        self.drawableLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
    }

    private func updatePath() {
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let radius = min(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - self.lineWidth
        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true)
            .CGPath
    }

    private func resetAnimations() {
        drawableLayer.removeAllAnimations()

        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = 2 * M_PI
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.removedOnCompletion = false

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
        strokeAnimGroup.removedOnCompletion = false

        self.drawableLayer.addAnimation(rotationAnim, forKey: "rotation")
        self.drawableLayer.addAnimation(strokeAnimGroup, forKey: "stroke")
    }
}
