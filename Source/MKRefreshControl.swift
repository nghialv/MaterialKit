//
//  MKRefreshControl.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 11/11/15.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//
//  Thanks to https://github.com/jhurray/JHPullToRefreshKit

import UIKit

open class MKRefreshControl: UIControl {
    
    private weak var parentScrollView: UIScrollView?
    private var animationView: UIView?
    private var circleView: UIView?
    private var progressPath: UIBezierPath?
    private var progressLayer: CAShapeLayer?
    private var refreshBlock: (() -> Void)?
    private var radius: CGFloat = 0
    private var rotation: CGFloat = 0
    private var rotationIncrement: CGFloat = 0
    
    open private(set) var refreshing = false
    open var height: CGFloat = 60
    open var color = UIColor.MKColor.Blue.P500 {
        didSet {
            progressLayer?.strokeColor = color.cgColor
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
    
    public func recycle() {
        parentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: Public functions
    
    open func addToScrollView(_ scrollView: UIScrollView, withRefreshBlock block: @escaping (() -> Void)) {
        refreshBlock = block
        parentScrollView = {
            scrollView.addSubview(self)
            #if swift(>=4.2)
            scrollView.sendSubviewToBack(self)
            #else
            scrollView.sendSubview(toBack: self)
            #endif
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer))
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            return scrollView
        }()
    }
    
    open func beginRefreshing() {
        refreshing = true
        startRefreshing()
    }
    
    open func endRefreshing() {
        resetAnimation()
    }
    
    // MARK: Private functions
    
    private func setupRefreshControl() {
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        animationView = UIView(frame: bounds)
        if let animationView = animationView {
            animationView.backgroundColor = .clear
            layer.masksToBounds = true
            addSubview(animationView)
        }
    }
    
    private func setup() {
        backgroundColor = .white
        
        rotation = 0
        rotationIncrement = CGFloat.pi * 14.0 / 8.0
        radius = 15.0
        let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: height / 2)
        
        circleView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        if let circleView = circleView, let animationView = animationView {
            circleView.center = center
            circleView.backgroundColor = .clear
            animationView.addSubview(circleView)
            
            let circleViewCenter = CGPoint(x: radius, y: radius)
            progressPath = UIBezierPath(arcCenter: circleViewCenter, radius: radius, startAngle: -.pi, endAngle: .pi, clockwise: true)
            progressLayer = CAShapeLayer()
            if let progressLayer = progressLayer, let progressPath = progressPath {
                progressLayer.path = progressPath.cgPath
                progressLayer.strokeColor = color.cgColor
                progressLayer.fillColor = UIColor.clear.cgColor
                progressLayer.lineWidth = 0.1 * radius * 2
                progressLayer.strokeStart = 0
                progressLayer.strokeEnd = 0
                progressLayer.frame = circleView.bounds
                circleView.layer.insertSublayer(progressLayer, at: 0)
            }
        }
        
        refreshing = false
    }
    
    private func setScrollViewTopInsets(withOffset offset: CGFloat) {
        if let parentScrollView = parentScrollView {
            var insets = parentScrollView.contentInset
            insets.top += offset
            parentScrollView.contentInset = insets
        }
    }
    
    private func refresh() {
        refreshing = true
        sendActions(for: .valueChanged)
        refreshBlock?()
        startRefreshing()
    }
    
    private func startRefreshing() {
        UIView.animate(withDuration: 0.25) {
            self.setScrollViewTopInsets(withOffset: self.height)
        }
        animateRefreshView()
    }
    
    private func handleScrollingOnAnimationView(_ animationView: UIView, withPullDistance pullDistance: CGFloat, withPullRatio pullRatio: CGFloat, withPullVelocity pullVelocity: CGFloat) {
        if let circleView = circleView, let progressLayer = progressLayer {
            if pullDistance < height {
                circleView.alpha = pullDistance / height
                progressLayer.strokeEnd = pullDistance / height * 0.9
            }
            rotation = .pi * pullDistance / height * 0.5
            circleView.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    private func resetAnimation() {
        refreshing = false
        if let animationView = animationView {
            exitAnimation(forRefreshView: animationView) {
                UIView.animate(withDuration: 0.25, animations: {
                    self.setScrollViewTopInsets(withOffset: -self.height)
                }, completion: { _ in
                    self.parentScrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(350 * NSEC_PER_MSEC) / Double(NSEC_PER_SEC)) {
                    self.resetAnimationView(animationView)
                }
            }
        }
    }
    
    private func resetAnimationView(_ animationView: UIView) {
        rotation = 0
        if let circleView = circleView {
            circleView.alpha = 1
            circleView.transform = CGAffineTransform(rotationAngle: rotation)
        }
        if let progressLayer = progressLayer {
            progressLayer.strokeStart = 0
            progressLayer.strokeEnd = 0
            progressLayer.removeAllAnimations()
        }
    }
    
    private func setupRefreshControl(forAnimationView animationView: UIView) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(animationSecondPhase)
        
        progressLayer?.strokeStart = 0.99
        progressLayer?.strokeEnd = 1
        circleView?.alpha = 1
        
        CATransaction.commit()
    }
    
    private func animationSecondPhase() {
        CATransaction.begin()
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
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
        #if swift(>=4.2)
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        startTailAnim.beginTime = 0.1
        startTailAnim.fromValue = 0
        startTailAnim.toValue = 1
        startTailAnim.duration = 1
        #if swift(>=4.2)
        startTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        startTailAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnim.beginTime = 1
        endHeadAnim.fromValue = 0.25
        endHeadAnim.toValue = 0.99
        endHeadAnim.duration = 0.5
        #if swift(>=4.2)
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnim.beginTime = 1
        endTailAnim.fromValue = 1
        endTailAnim.toValue = 1
        endTailAnim.duration = 0.5
        #if swift(>=4.2)
        endTailAnim.toValue = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        endTailAnim.toValue = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        let strokeAnimGroup = CAAnimationGroup()
        strokeAnimGroup.duration = 1.5
        strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
        strokeAnimGroup.repeatCount = Float.infinity
        strokeAnimGroup.isRemovedOnCompletion = false
        
        if let progressLayer = progressLayer {
            progressLayer.add(rotationAnim, forKey: "rotation")
            progressLayer.add(strokeAnimGroup, forKey: "stroke")
        }
        
        CATransaction.commit()
    }
    
    private func animateRefreshView() {
        if let animationView = animationView {
            setupRefreshControl(forAnimationView: animationView)
        }
    }
    
    private func exitAnimation(forRefreshView view: UIView, withCompletionBlock block: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.circleView?.alpha = 0
            self.progressLayer?.removeAllAnimations()
            block()
        }
        
        let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.25
        opacityAnimation.isRemovedOnCompletion = false
        #if swift(>=4.2)
        opacityAnimation.fillMode = .forwards
        #else
        opacityAnimation.fillMode = kCAFillModeForwards
        #endif
        
        progressLayer?.add(opacityAnimation, forKey: "opacity")
        
        CATransaction.commit()
    }
    
    // MARK: ScrollView Observers
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let object = object as? UIScrollView,
                let parentScrollView = parentScrollView,
                object == parentScrollView {
                containingScrollViewDidScroll(parentScrollView)
            }
        }
    }
    
    @objc open func handlePanGestureRecognizer() {
        if let parentScrollView = parentScrollView,
            parentScrollView.panGestureRecognizer.state == .ended {
            containingScrollViewDidEndDragging(parentScrollView)
        }
    }
    
    private func containingScrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualOffset = scrollView.contentOffset.y
        setFrameForScrolling(withOffset: actualOffset)
        if !refreshing {
            let pullDistance = max(0, -actualOffset)
            let pullRatio = min(max(0, pullDistance), height) / height
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
            if pullRatio != 0,
                let animationView = animationView {
                handleScrollingOnAnimationView(
                    animationView,
                    withPullDistance: pullDistance,
                    withPullRatio: pullRatio,
                    withPullVelocity: velocity)
            }
        }
    }
    
    private func containingScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        let actualOffset = scrollView.contentOffset.y
        if !refreshing && -actualOffset > height {
            refresh()
        }
    }
    
    // MARK: Scrolling
    
    private func setFrameForScrolling(withOffset offset: CGFloat) {
        if -offset > height {
            frame = CGRect(x: 0, y: offset, width: UIScreen.main.bounds.width, height: abs(offset))
            bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: abs(offset))
        } else {
            let newY = offset
            frame = CGRect(x: 0, y: newY, width: UIScreen.main.bounds.width, height: height)
            bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        }
    }
}
