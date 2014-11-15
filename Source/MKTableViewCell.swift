//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class MKTableViewCell : UITableViewCell {
   
    private var mkLayer: MKLayer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLayer() {
        self.selectionStyle = .None
        println("View \(CGRectGetHeight(contentView.bounds))")
        
        mkLayer = MKLayer(superLayer: self.contentView.layer)
        mkLayer.setCircleLayerColor(UIColor.MKColor.Orange)
        mkLayer.setBackgroundLayerColor(UIColor.brownColor())
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        let firstTouch = touches.anyObject() as UITouch
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.Linear, duration: 0.75)
        println("Touch")
    }
}
