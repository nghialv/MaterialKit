//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class MKTableViewCell : UITableViewCell {
    @IBInspectable var tapLocationEnabled: Bool = true
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.contentView.layer)
    
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
        mkLayer.setCircleLayerColor(UIColor.MKColor.Orange)
        mkLayer.setBackgroundLayerColor(UIColor.brownColor())
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if let firstTouch = touches.anyObject() as? UITouch {
            mkLayer.superLayerDidResize()
            mkLayer.setCircleLayerLocationAt(firstTouch.locationInView(self.contentView))
            mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.Linear, duration: 0.75)
            mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: 0.75)
            println("\(self.bounds.height)")
            println("Touch")
        }
    }
}
