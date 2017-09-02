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

    private let drawableLayer = CAShapeLayer()
    private var animating = false

    @IBInspectable open var color: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            drawableLayer.strokeColor = color.cgColor
        }
    }

    @IBInspectable open var lineWidth: CGFloat = 6 {
        didSet {
            drawableLayer.lineWidth = lineWidth
            updatePath()
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
        if animating {
            return
        }

        animating = true
        isHidden = false
        resetAnimations()
    }

    open func stopAnimating() {
        drawableLayer.removeAllAnimations()
        animating = false
        isHidden = true
    }

    private func setup() {
        isHidden = true
        layer.addSublayer(drawableLayer)
        drawableLayer.strokeColor = color.cgColor
        drawableLayer.lineWidth = lineWidth
        drawableLayer.fillColor = UIColor.clear.cgColor
        drawableLayer.lineCap = kCALineJoinRound
        drawableLayer.strokeStart = 0.99
        drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }

    private func updateFrame() {
        drawableLayer.frame = bounds
    }

    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth
        drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true)
            .cgPath
    }

    private func resetAnimations() {
        drawableLayer.removeAllAnimations()

        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = CGFloat.pi * 2
        rotationAnim.repeatCount = .infinity
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
        strokeAnimGroup.repeatCount = .infinity
        strokeAnimGroup.isRemovedOnCompletion = false

        drawableLayer.add(rotationAnim, forKey: "rotation")
        drawableLayer.add(strokeAnimGroup, forKey: "stroke")
    }
}
