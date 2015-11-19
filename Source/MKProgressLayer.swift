//
//  MKProgressLayer.swift
//  MaterialKit
//
//  Created by Raza Robson on 2015-11-08.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//

import Foundation
import UIKit

class MKPogressLayer: CALayer {
    
    /// Defines the different states of
    /// the arc circle animation
    @objc enum StateId:Int {
        
        /// id for state when the arc circle's endpoints are the closest to each other.
        case Collapsed
        
        /// id for state when the arc circle's endpoints are getting further from each other.
        case Expanding
        
        /// id for state when the arc circle's endpoints are the furthest from each other.
        case Expanded
        
        /// id for state when the arc circle's endpoints are getting closer each other.
        case Collapsing
    }
    
    struct State {
        let id:StateId
        
        /// The duration for which this state's animation will play
        let duration:NSTimeInterval
        
        /// The state to play after this state's animation's finishes
        let nextStateId:StateId
        
        /// Closure that takes a value between 0 and 1 and returns
        /// the startAngle and the endAngle that to apply to the arc circle
        /// at each frame when this state's animation is played.
        let angleValueFunction:(Float) -> (Float, Float)
    }
    
    /// The central angle of this layer's arc circle when the arc's
    /// endpoints are the closest to each other, in radians.
    private static let minAngle = Float(0.05 * 2 * M_PI)
    
    /// The central angle of this layer's arc circle when the arc's
    /// endpoints are the furthest from each other, in radians.
    private static let maxAngle = Float(0.80 * 2 * M_PI )
    
    private static let collapsedState = State(
        id: .Collapsed,
        duration: 0.2,
        nextStateId: .Expanding,
        angleValueFunction: {(_) in (0, MKPogressLayer.minAngle)})
    
    private static let expandingState = State(
        id: .Expanding,
        duration: 0.5,
        nextStateId: .Expanded,
        angleValueFunction: { (t) -> (Float, Float) in
            return (
                0,
                (MKPogressLayer.maxAngle - MKPogressLayer.minAngle) * t + MKPogressLayer.minAngle
            )
        })
    
    private static let expandedState = State(
        id: .Expanded,
        duration: 0.25,
        nextStateId: .Collapsing,
        angleValueFunction: {(_) in (0, MKPogressLayer.maxAngle)})
    
    private static let collapsingState = State(
        id: .Collapsing,
        duration: 0.5,
        nextStateId: .Collapsed,
        angleValueFunction: { (t) -> (Float, Float) in
            return (
                (MKPogressLayer.maxAngle - MKPogressLayer.minAngle) * t,
                MKPogressLayer.maxAngle
            )
        })
    
    dynamic var lineColor = UIColor.MKColor.Blue
    dynamic var lineWidth: CGFloat = 8
    private dynamic var angleOffSet: Float = 0
    private dynamic var stateId = StateId.Collapsed
    private dynamic var t:Float = 0
    
    private let path = UIBezierPath()
    
    override init() {
        super.init()
        configure()
    }
    
    override init(layer: AnyObject) {
        angleOffSet = layer.angleOffSet
        lineColor = layer.lineColor
        lineWidth = layer.lineWidth
        stateId = layer.stateId
        t = layer.t
        super.init(layer: layer)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        setNeedsDisplay()
        
        // setting the content scale will make 
        // a smooth circle on high-resolution devices
        contentsScale = UIScreen.mainScreen().scale
        
        #if TARGET_INTERFACE_BUILDER
        stateId = .Expanded
        #endif
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if(event == "stateId"
            || event == "angleOffSet"
            || event == "lineColor"
            || event == "lineWidth"
            || event == "t"){
            return implicitAnimationForKeypath(event)
        }
        return super.actionForKey(event)
    }
    
    override class func needsDisplayForKey(key: String) -> Bool {
        if (key == "stateId"
            || key == "angleOffSet"
            || key == "lineColor"
            || key == "lineWidth"
            || key == "t"){
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    override func drawInContext(ctx: CGContext) {
        
        path.lineWidth = lineWidth
        
        let size = frame.size
        let diameter = min(size.height, size.width) - path.lineWidth
        let center = CGPointMake(
            0.5 * size.width,
            0.5 * size.height)
        
        let state = MKPogressLayer.stateWithId(stateId)
        let (startAngle, endAngle) = state.angleValueFunction(t)
        UIGraphicsPushContext(ctx)
            path.removeAllPoints()
            path.addArcWithCenter(
                center,
                radius: 0.5 * diameter,
                startAngle: CGFloat(angleOffSet + startAngle),
                endAngle: CGFloat(angleOffSet + endAngle),
                clockwise: true)
            lineColor.setStroke()
            path.stroke()
        UIGraphicsPopContext()
    }
    
    /// Call this function after an animation returned by `nextCircleAnimation()` has been added
    /// has been added to the render tree. This will update the model layer values so that
    /// its contents match the presentation layer's appearance for the current
    /// state at the end of its animation.
    func updateState() {
        let previousStateId = stateId
        let state = MKPogressLayer.stateWithId(stateId)
        stateId = state.nextStateId
        if(previousStateId == .Collapsing){
            angleOffSet = (angleOffSet + MKPogressLayer.maxAngle - MKPogressLayer.minAngle) % Float(2 * M_PI)
        }
    }
    
    private class func stateWithId(stateId:StateId) -> State {
        switch(stateId){
        case .Collapsed:
            return collapsedState
        case .Expanding:
            return expandingState
        case .Expanded:
            return expandedState
        case .Collapsing:
            return collapsingState
        }
    }
    
    private func implicitAnimationForKeypath(property:String) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: property)
        let presentationLayer = self.presentationLayer() as! MKPogressLayer
        animation.fromValue = presentationLayer.valueForKey(property)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        return animation
    }
    
    /// Returns the next circle animation to play.
    /// Call `updateState()` after the returned animation has been added to
    /// the render tree.
    func nextCircleAnimation() -> CAAnimation {
        return circleAnimationForState(MKPogressLayer.stateWithId(stateId))
    }
    
    private func circleAnimationForState(state:State) -> CAAnimation {
        
        let pathAnimation = CABasicAnimation(keyPath: "t")
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        
        let stateAnimation = CABasicAnimation(keyPath: "stateId")
        stateAnimation.fromValue = state.id.rawValue
        stateAnimation.toValue = state.id.rawValue
        
        let offSetAnimation = CABasicAnimation(keyPath: "angleOffSet")
        offSetAnimation.fromValue = angleOffSet
        offSetAnimation.toValue = angleOffSet
        
        let group = CAAnimationGroup()
        
        group.animations = [pathAnimation, offSetAnimation, stateAnimation]
        group.duration = state.duration
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return group
        
    }
}