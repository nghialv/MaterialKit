//
//  MKNavigationBar.swift
//  Cityflo
//
//  Created by Rahul Iyer on 02/11/15.
//  Copyright © 2015 Cityflo. All rights reserved.
//

import UIKit

@IBDesignable
open class MKNavigationBar: UINavigationBar {

    let statusView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: 20))
    
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            drawShadow()
        }
    }
    @IBInspectable open var shadowOpacity: Float = 0.5 {
        didSet {
            drawShadow()
        }
    }
    
    @IBInspectable open var color: UIColor = UIColor.white {
        didSet {
            UINavigationBar.appearance().barTintColor = self.color
        }
    }
    
    @IBInspectable open var darkColor: UIColor = UIColor.gray {
        didSet {
            self.statusView.backgroundColor = self.darkColor
        }
    }
    
    @IBInspectable open override var tintColor: UIColor! {
        didSet {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: self.tintColor]
            UINavigationBar.appearance().tintColor = self.tintColor
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func layoutSubviews() {
        drawShadow()
        super.layoutSubviews()
    }
    
    fileprivate func setup() {
        self.statusView.backgroundColor = self.darkColor
        self.addSubview(self.statusView)
        UINavigationBar.appearance().barTintColor = self.color
        UINavigationBar.appearance().backgroundColor = self.tintColor
        UINavigationBar.appearance().tintColor = self.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: self.tintColor]
    }
    
    fileprivate func drawShadow() {
        if elevation > 0 {
            let shadowPath = UIBezierPath(rect: bounds)
            layer.masksToBounds = false
            layer.shadowRadius = elevation
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 1, height: 1);
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.cgPath
        }
    }
    
}
