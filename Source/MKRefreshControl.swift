//
//  MKRefreshControl.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 11/11/15.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//  
//  Thanks to https://github.com/jhurray/JHPullToRefreshKit

import UIKit

public class MKRefreshControl: UIControl {

    private var parentScrollView: UIScrollView = UIScrollView()
    private var animationView: UIView = UIView()
    private var circleView: UIView = UIView()
    private var progressPath: UIBezierPath = UIBezierPath()
    private var progressLayer: CAShapeLayer = CAShapeLayer()
    private var refreshBlock: (() -> Void) = {() -> Void in}
    private var startPercent: CGFloat = 0
    private var endPercent: CGFloat = 0
    private var fillPercent: CGFloat = 0
    private var radius: CGFloat = 0
    private var rotation: CGFloat = 0
    private var rotationIncrement: CGFloat = 0
    private var filling: Bool = false
    
    public private(set) var refreshing: Bool = false
    public var height: CGFloat = 60
    public var color: UIColor = UIColor.MKColor.Blue {
        didSet {
            self.progressLayer.strokeColor = self.color.CGColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupRefreshControl()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRefreshControl()
        setup()
    }
    
    // MARK: Public functions
    
    public func addToScrollView(scrollView: UIScrollView, withRefreshBlock block: ( () -> Void )) {
        self.parentScrollView = scrollView
        self.refreshBlock = block
        self.parentScrollView.addSubview(self)
        self.parentScrollView.sendSubviewToBack(self)
        self.parentScrollView.panGestureRecognizer.addTarget(self, action: "handlePanGestureRecognizer")
        self.parentScrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func startRefreshing() {
        self.refresh()
    }
    
    public func endRefreshing() {
        self.refreshing = false
    }
    
    // MARK: Private functions
    
    private func setupRefreshControl() {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), self.height)
        self.animationView = UIView(frame: self.bounds)
        self.animationView.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = true
        self.addSubview(self.animationView)
    }
    
    private func setup() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.startPercent = 1 / 16.0
        self.endPercent = 13 / 16.0
        self.fillPercent = self.endPercent - self.startPercent
        self.rotation = 0
        self.rotationIncrement = CGFloat(14 * M_PI / 8.0)
        self.radius = 15.0
        self.filling = false
        let center = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 2, self.height / 2)
        
        self.circleView = UIView(frame: CGRectMake(0, 0, self.radius * 2, self.radius * 2))
        self.circleView.center = center
        self.circleView.backgroundColor = UIColor.clearColor()
        self.animationView.addSubview(self.circleView)
        
        let circleViewCenter = CGPointMake(self.radius, self.radius)
        self.progressPath = UIBezierPath(arcCenter: circleViewCenter, radius: self.radius, startAngle: CGFloat(-M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        self.progressLayer = CAShapeLayer()
        self.progressLayer.path = self.progressPath.CGPath
        self.progressLayer.strokeColor = self.color.CGColor
        self.progressLayer.fillColor = UIColor.clearColor().CGColor
        self.progressLayer.lineWidth = 0.1 * self.radius * 2
        self.progressLayer.strokeStart = 0
        self.progressLayer.strokeEnd = self.startPercent
        self.progressLayer.frame = self.circleView.bounds
        self.circleView.layer.insertSublayer(self.progressLayer, atIndex: 0)
        
        self.refreshing = false
    }
    
    private func setScrollViewTopInsets(withOffset offset: CGFloat) {
        var insets: UIEdgeInsets = self.parentScrollView.contentInset
        insets.top += offset
        self.parentScrollView.contentInset = insets
    }
    
    private func refresh() {
        self.refreshing = true
        self.sendActionsForControlEvents(.ValueChanged)
        self.refreshBlock()
        UIView.animateWithDuration(0.25) { () -> Void in
            self.setScrollViewTopInsets(withOffset: self.height)
        }
        self.animateRefreshView()
    }
    
    private func handleScrollingOnAnimationView(animationView: UIView, withPullDistance pullDistance:   CGFloat, withPullRatio pullRatio: CGFloat, withPullVelocity pullVelocity: CGFloat) {
        let startPullRatio: CGFloat = 0.5
        let startPullRatioMultiplier: CGFloat = (pullRatio - startPullRatio) / startPullRatio
        if pullRatio > startPullRatio {
            self.progressLayer.strokeEnd = startPullRatioMultiplier * pullRatio * fillPercent + startPercent
        }
        self.rotation = CGFloat(M_PI) * pullDistance / self.height * 0.75
        self.circleView.transform = CGAffineTransformMakeRotation(self.rotation)
    }
    
    private func resetAnimation() {
        self.refreshing = false
        self.exitAnimation(forRefreshView: self.animationView) { () -> Void in
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.setScrollViewTopInsets(withOffset: -self.height)
                }, completion: { (Bool) -> Void in
                    self.parentScrollView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
            })
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(350 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.resetAnimationView(self.animationView)
            })
        }
    }
    
    private func resetAnimationView(animationView: UIView) {
        self.rotation = 0
        self.circleView.alpha = 1
        self.circleView.transform = CGAffineTransformMakeRotation(self.rotation)
        self.progressLayer.strokeEnd = self.startPercent
        self.progressLayer.removeAllAnimations()
    }
    
    private func setupRefreshControl(forAnimationView animationView: UIView) {
        self.progressLayer.strokeEnd = self.filling ? self.endPercent : self.startPercent
    }
    
    private func animateRefreshView() {
        self.setupRefreshControl(forAnimationView: self.animationView)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            self.filling = !self.filling
            self.progressLayer.removeAnimationForKey("refresh")
            self.rotation += self.rotationIncrement
            self.rotationIncrement = self.filling ? CGFloat(M_PI) * 5 / 8.0 : CGFloat(M_PI) * 15 / 8.0
            self.animateRefreshViewEnded()
        }
        
        let strokeStartVal: CGFloat = self.filling ? self.startPercent : self.endPercent
        let strokeEndVal: CGFloat = self.filling ? self.endPercent : self.startPercent
        
        let strokeFillAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeFillAnimation.fromValue = strokeStartVal
        strokeFillAnimation.toValue = strokeEndVal
        
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = self.rotation
        rotationAnimation.toValue = self.rotation + self.rotationIncrement
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeFillAnimation, rotationAnimation]
        animationGroup.duration = 0.6
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        
        self.progressLayer.addAnimation(animationGroup, forKey: "refresh")
        
        CATransaction.commit()
    }
    
    private func exitAnimation(forRefreshView view: UIView, withCompletionBlock block: ( () -> Void)) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.circleView.alpha = 0
            self.progressLayer.removeAnimationForKey("refresh")
            block()
        }
        
        let strokeStartVal: CGFloat = self.progressLayer.strokeEnd
        let strokeEndVal: CGFloat = 0
        
        let strokeFillAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeFillAnimation.fromValue = strokeStartVal
        strokeFillAnimation.toValue = strokeEndVal
        
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = self.rotation
        rotationAnimation.toValue  = self.rotation + self.rotationIncrement
        
        let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeFillAnimation, rotationAnimation, opacityAnimation]
        animationGroup.duration = 0.6
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        
        self.progressLayer.addAnimation(animationGroup, forKey: "refresh")
        
        CATransaction.commit()
    }
    
    private func animateRefreshViewEnded() {
        if self.refreshing {
            self.animateRefreshView()
        } else {
            self.resetAnimation()
        }
    }
    
    // MARK: ScrollView Observers
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyPath = keyPath {
            if keyPath == "contentOffset" {
                if let object = object as? UIScrollView {
                    if object == self.parentScrollView {
                        self.containingScrollViewDidScroll(self.parentScrollView)
                    }
                }
            }
        }
    }
    
    public func handlePanGestureRecognizer() {
        if self.parentScrollView.panGestureRecognizer.state == .Ended {
            self.containingScrollViewDidEndDragging(self.parentScrollView)
        }
    }
    
    private func containingScrollViewDidScroll(scrollView: UIScrollView) {
        let actualOffset: CGFloat = scrollView.contentOffset.y
        self.setFrameForScrolling(withOffset: actualOffset)
        if !self.refreshing {
            let pullDistance: CGFloat = max(0, -actualOffset)
            let pullRatio: CGFloat = min(max(0, pullDistance), self.height) / self.height
            let velocity: CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y
            if pullRatio != 0 {
                self.handleScrollingOnAnimationView(self.animationView, withPullDistance: pullDistance, withPullRatio: pullRatio, withPullVelocity: velocity)
            }
        }
    }
    
    private func containingScrollViewDidEndDragging(scrollView: UIScrollView) {
        let actualOffset: CGFloat = scrollView.contentOffset.y
        if !self.refreshing && -actualOffset > self.height {
            self.refresh()
        }
    }
    
    // MARK: Scrolling
    
    private func setFrameForScrolling(withOffset offset: CGFloat) {
        if -offset > self.height {
            let newFrame: CGRect = CGRectMake(0, offset, CGRectGetWidth(UIScreen.mainScreen().bounds), abs(offset))
            self.frame = newFrame
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), abs(offset))
        } else {
            let newY: CGFloat = offset
            self.frame = CGRectMake(0, newY, CGRectGetWidth(UIScreen.mainScreen().bounds), self.height)
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), self.height)
        }
    }
}
