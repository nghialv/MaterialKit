//
//  MKSnackbar.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 14/01/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//

import UIKit

public class MKSnackbar: UIControl {
    
    public var text: String? {
        didSet {
            if let textLabel = self.textLabel {
                textLabel.text = text
            }
        }
    }
    public var actionTitle: String? {
        didSet {
            if let actionButton = self.actionButton {
                actionButton.setTitle(actionTitle, forState: .Normal)
            }
        }
    }
    public var textColor: UIColor? {
        didSet {
            if let textLabel = self.textLabel {
                textLabel.textColor = textColor
            }
        }
    }
    public var actionTitleColor: UIColor? {
        didSet {
            if let actionButton = self.actionButton {
                actionButton.setTitleColor(actionTitleColor, forState: .Normal)
            }
        }
    }
    public var actionRippleColor: UIColor? {
        didSet {
            if let actionButton = self.actionButton, actionRippleColor = self.actionRippleColor {
                actionButton.rippleLayerColor = actionRippleColor
            }
        }
    }
    public var duration: NSTimeInterval = 3.5
    public private(set) var isShowing: Bool = false
    
    private var hiddenConstraint: NSLayoutConstraint?
    private var showingConstraint: NSLayoutConstraint?
    private var rootView: UIView?
    private var textLabel: UILabel?
    private var actionButton: MKButton?
    private var isAnimating: Bool = false
    private var delegates: NSMutableSet = NSMutableSet()
    
    // MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public init(
        withTitle title: String,
        withDuration duration: NSTimeInterval?,
        withTitleColor titleColor: UIColor?,
        withActionButtonTitle actionTitle: String?,
        withActionButtonColor actionColor: UIColor?) {
        super.init(frame: CGRectZero)
        self.text = title
        if let duration = duration {
            self.duration = duration
        }
        self.textColor = titleColor
        self.actionTitle = actionTitle
        self.actionTitleColor = actionColor
        self.setup()
    }
    
    private func setup() {
        if actionTitleColor == nil {
            actionTitleColor = UIColor.whiteColor()
        }
        if textColor == nil {
            textColor = UIColor.whiteColor()
        }
        self.backgroundColor = UIColor.blackColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel = UILabel()
        if let textLabel = textLabel {
            textLabel.font = UIFont.systemFontOfSize(16)
            textLabel.textColor = textColor
            textLabel.alpha = 0
            textLabel.numberOfLines = 0
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow,
                forAxis: UILayoutConstraintAxis.Horizontal)
        }
        
        actionButton = MKButton()
        if let actionButton = actionButton {
            actionButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
            actionButton.setTitleColor(actionTitleColor, forState: .Normal)
            actionButton.alpha = 0
            actionButton.enabled = false
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.setContentHuggingPriority(UILayoutPriorityRequired,
                forAxis: UILayoutConstraintAxis.Horizontal)
            actionButton.addTarget(
                self,
                action: Selector("actionButtonClicked:"),
                forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    // Mark: Public functions
    
    public func show() {
        MKSnackbarManager.getInstance().showSnackbar(self)
    }
    
    public func dismiss() {
        if !isShowing || isAnimating {
            return
        }
        
        isAnimating = true
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("dismiss"), object: nil)
        if let rootView = rootView {
            rootView.layoutIfNeeded()
            
            UIView.animateWithDuration(
                0.25,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {() -> Void in
                    if let textLabel = self.textLabel,
                    actionButton = self.actionButton,
                    hiddenConstraint = self.hiddenConstraint,
                    showingConstraint = self.showingConstraint {
                        textLabel.alpha = 0
                        actionButton.alpha = 0
                        rootView.removeConstraint(showingConstraint)
                        rootView.addConstraint(hiddenConstraint)
                        rootView.layoutIfNeeded()
                    }
                    
                }, completion: {(finished: Bool) -> Void in
                    if finished {
                        self.isAnimating = false
                        self.performDelegateAction(Selector("snackbarDismissed:"))
                        self.removeFromSuperview()
                        if let textLabel = self.textLabel, actionButton = self.actionButton {
                            textLabel.removeFromSuperview()
                            actionButton.removeFromSuperview()
                        }
                        self.isShowing = false
                    }
                })
        }
    }
    
    public func addDeleagte(delegate: MKSnackbarDelegate) {
        delegates.addObject(delegate)
    }
    
    public func removeDelegate(delegate: MKSnackbarDelegate) {
        delegates.removeObject(delegate)
    }
    
    public func actionButtonSelector(withTarget target: AnyObject, andAction action: Selector) {
        if let actionButton = actionButton {
            actionButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    // Mark: Action
    
    internal func actionButtonClicked(sender: AnyObject) {
        performDelegateAction(Selector("actionClicked:"))
        if let actionButton = actionButton {
            actionButton.enabled = false
        }
        dismiss()
    }
    
    
    // Mark: Private functions
    
    private func arrangeContent() {
        if let textLabel = textLabel, actionButton = actionButton {
            self.addSubview(textLabel)
            if let _ = actionTitle {
                self.addSubview(actionButton)
            }
            
            let views: Dictionary<String, AnyObject> = [
                "label": textLabel,
                "button": actionButton
            ]
            let metrics: Dictionary<String, AnyObject> = [
                "normalPadding": 14,
                "largePadding": 24
            ]
            
            let labelConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-largePadding-[label]-largePadding-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views
            )
            self.addConstraints(labelConstraints)
            
            if let _ = actionTitle {
                let centerConstraint = NSLayoutConstraint(
                    item: actionButton,
                    attribute: NSLayoutAttribute.CenterY,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self,
                    attribute: NSLayoutAttribute.CenterY,
                    multiplier: 1,
                    constant: 0)
                
                self.addConstraint(centerConstraint)
                
                let horizontalContraint = NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-largePadding-[label]-largePadding-[button]-largePadding-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics,
                    views: views)
                self.addConstraints(horizontalContraint)
            } else {
                let horizontalContraint = NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-largePadding-[label]-largePadding-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics,
                    views: views)
                self.addConstraints(horizontalContraint)
            }
        }
    }
    
    private func addToScreen() {
        if let window = UIApplication.sharedApplication().keyWindow {
            rootView = window
        } else if let window = UIApplication.sharedApplication().delegate?.window {
            rootView = window
        }
        
        if let rootView = rootView {
            rootView.addSubview(self)
            let views: Dictionary<String, AnyObject> = [
                "view": self
            ]
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: views)
            
            rootView.addConstraints(horizontalConstraints)
            
            hiddenConstraint = NSLayoutConstraint(
                item: self,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: rootView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0)
            
            showingConstraint = NSLayoutConstraint(
                item: self,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: rootView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0)
            
            rootView.addConstraint(hiddenConstraint!)
        }
        
        if let text = text, textLabel = textLabel {
            textLabel.text = text
        }
        
        if let actionTitle = actionTitle, actionButton = actionButton {
            actionButton.setTitle(actionTitle, forState: .Normal)
        }
    }
    
    private func displaySnackbar() {
        if isShowing || isAnimating {
            return
        }
        
        isShowing = true
        isAnimating = true
        
        arrangeContent()
        addToScreen()
        
        if let rootView = rootView {
            rootView.layoutIfNeeded()
            UIView.animateWithDuration(
                0.25,
                delay: 0,
                options: .CurveEaseInOut,
                animations: {() -> Void in
                    if let textLabel = self.textLabel,
                    actionButton = self.actionButton,
                    hiddenConstraint = self.hiddenConstraint,
                    showingConstraint = self.showingConstraint {
                        textLabel.alpha = 1
                        actionButton.alpha = 1
                        rootView.removeConstraint(hiddenConstraint)
                        rootView.addConstraint(showingConstraint)
                        rootView.layoutIfNeeded()
                    }
                    
                }, completion: {(finished: Bool) -> Void in
                    if finished {
                        self.isAnimating = false
                        self.performDelegateAction(Selector("snackbarShown:"))
                        self.performSelector(
                            Selector("dismiss"),
                            withObject: nil,
                            afterDelay: self.duration)
                        if let actionButton = self.actionButton {
                            actionButton.enabled = true
                        }
                    }
                })
        }
    }
    
    private func performDelegateAction(action: Selector) {
        for delegate in delegates {
            if let delegate = delegate as? MKSnackbarDelegate {
                if delegate.respondsToSelector(action) {
                    delegate.performSelector(action, withObject: self)
                }
            }
        }
    }
    
}

// MARK:- MKSnackbar Delegate
@objc public protocol MKSnackbarDelegate: NSObjectProtocol {
    optional func snackbarShown(snackbar: MKSnackbar)
    optional func snackbabrDismissed(snackbar: MKSnackbar)
    optional func actionClicked(snackbar: MKSnackbar)
}

// MARK:- MKSnackbar Manager

private class MKSnackbarManager: NSObject, MKSnackbarDelegate {
    
    static var instance: MKSnackbarManager!
    
    private var snackbarQueue: Array<MKSnackbar>?
    
    private override init() {
        snackbarQueue = Array<MKSnackbar>()
    }
    
    static func getInstance() -> MKSnackbarManager {
        if instance == nil {
            instance = MKSnackbarManager()
        }
        return instance
    }
    
    func showSnackbar(snackbar: MKSnackbar) {
        if var snackbarQueue = snackbarQueue {
            if !snackbarQueue.contains(snackbar) {
                snackbar.addDeleagte(self)
                snackbarQueue.append(snackbar)
                
                if snackbarQueue.count == 1 {
                    snackbar.displaySnackbar()
                } else {
                    snackbarQueue[0].dismiss()
                }
            }
        }
    }
    
    @objc private func snackbabrDismissed(snackbar: MKSnackbar) {
        if var snackbarQueue = snackbarQueue {
            if let index = snackbarQueue.indexOf(snackbar) {
                snackbarQueue.removeAtIndex(index)
            }
            if snackbarQueue.count > 0 {
                snackbarQueue[0].displaySnackbar()
            }
        }
    }
}
