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
    
    @IBInspectable open var color: UIColor = .white {
        didSet {
            UINavigationBar.appearance().barTintColor = color
        }
    }
    
    @IBInspectable open var darkColor: UIColor = .gray {
        didSet {
            statusView.backgroundColor = darkColor
        }
    }
    
    @IBInspectable open override var tintColor: UIColor! {
        didSet {
            #if swift(>=5.0)
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: tintColor!]
            #elseif swift(>=4.0)
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: tintColor]
            #else
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: tintColor]
            #endif
            UINavigationBar.appearance().tintColor = tintColor
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
    
    private func setup() {
        statusView.backgroundColor = darkColor
        addSubview(statusView)
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().backgroundColor = tintColor
        UINavigationBar.appearance().tintColor = tintColor
        #if swift(>=5.0)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: tintColor!]
        #elseif swift(>=4.0)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: tintColor]
        #else
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: tintColor]
        #endif
    }
    
    private func drawShadow() {
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
