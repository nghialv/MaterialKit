//
//  MKSnackbar.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 14/01/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//

import UIKit

open class MKSnackbar: UIControl {
    
    open var text: String? {
        didSet {
            textLabel?.text = text
        }
    }
    open var actionTitle: String? {
        didSet {
            actionButton?.setTitle(actionTitle, for: .normal)
        }
    }
    open var textColor: UIColor? {
        didSet {
            textLabel?.textColor = textColor
        }
    }
    open var actionTitleColor: UIColor? {
        didSet {
            actionButton?.setTitleColor(actionTitleColor, for: .normal)
        }
    }
    open var actionRippleColor: UIColor? {
        didSet {
            if let actionButton = actionButton, let actionRippleColor = actionRippleColor {
                actionButton.rippleLayerColor = actionRippleColor
            }
        }
    }
    open var duration: TimeInterval = 3.5
    open private(set) var isShowing = false
    
    private var hiddenConstraint: NSLayoutConstraint?
    private var showingConstraint: NSLayoutConstraint?
    private var rootView: UIView?
    private var textLabel: UILabel?
    private var actionButton: MKButton?
    private var isAnimating = false
    private var delegates = NSMutableSet()
    
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
        withDuration duration: TimeInterval?,
        withTitleColor titleColor: UIColor?,
        withActionButtonTitle actionTitle: String?,
        withActionButtonColor actionColor: UIColor?) {
        super.init(frame: .zero)
        text = title
        if let duration = duration {
            self.duration = duration
        }
        textColor = titleColor
        self.actionTitle = actionTitle
        actionTitleColor = actionColor
        setup()
    }
    
    private func setup() {
        if actionTitleColor == nil {
            actionTitleColor = .white
        }
        if textColor == nil {
            textColor = .white
        }
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        
        textLabel = { let textLabel = UILabel()
            textLabel.font = .systemFont(ofSize: 16)
            textLabel.textColor = textColor
            textLabel.alpha = 0
            textLabel.numberOfLines = 0
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            #if swift(>=4)
                textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            #else
                textLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
            #endif
            return textLabel
        }()
        
        actionButton = { let actionButton = MKButton()
            actionButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
            actionButton.setTitleColor(actionTitleColor, for: .normal)
            actionButton.alpha = 0
            actionButton.isEnabled = false
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            #if swift(>=4.0)
                actionButton.setContentHuggingPriority(.required, for: .horizontal)
            #else
                actionButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
            #endif
            actionButton.addTarget(
                self,
                action: #selector(actionButtonClicked(_:)),
                for: .touchUpInside)
            return actionButton
        }()
    }
    
    // Mark: Public functions
    
    open func show() {
        MKSnackbarManager.instance.showSnackbar(self)
    }
    
    @objc open func dismiss() {
        if !isShowing || isAnimating {
            return
        }
        
        isAnimating = true
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        guard let rootView = rootView else { return }
        rootView.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            animations: {
                if let hiddenConstraint = self.hiddenConstraint,
                    let showingConstraint = self.showingConstraint {
                    self.textLabel?.alpha = 0
                    self.actionButton?.alpha = 0
                    rootView.removeConstraint(showingConstraint)
                    rootView.addConstraint(hiddenConstraint)
                    rootView.layoutIfNeeded()
                }
                
        }, completion: { finished in
            if finished {
                self.isAnimating = false
                self.performDelegateAction(#selector(MKSnackbarDelegate.snackbabrDismissed(_:)))
                self.removeFromSuperview()
                self.textLabel?.removeFromSuperview()
                self.actionButton?.removeFromSuperview()
                self.isShowing = false
            }
        })
    }
    
    open func addDeleagte(_ delegate: MKSnackbarDelegate) {
        delegates.add(delegate)
    }
    
    open func removeDelegate(_ delegate: MKSnackbarDelegate) {
        delegates.remove(delegate)
    }
    
    open func actionButtonSelector(withTarget target: AnyObject, andAction action: Selector) {
        actionButton?.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // Mark: Action
    
    @objc internal func actionButtonClicked(_ sender: AnyObject) {
        performDelegateAction(#selector(MKSnackbarDelegate.actionClicked(_:)))
        actionButton?.isEnabled = false
        dismiss()
    }
    
    
    // Mark: Private functions
    
    private func arrangeContent() {
        if let textLabel = textLabel, let actionButton = actionButton {
            addSubview(textLabel)
            if actionTitle != nil {
                addSubview(actionButton)
            }
            
            let views = [
                "label": textLabel,
                "button": actionButton
            ]
            let metrics = [
                "normalPadding": 14,
                "largePadding": 24
            ]
            
            let labelConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-largePadding-[label]-largePadding-|",
                metrics: metrics,
                views: views
            )
            addConstraints(labelConstraints)
            
            if let _ = actionTitle {
                let centerConstraint = NSLayoutConstraint(
                    item: actionButton,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .centerY,
                    multiplier: 1,
                    constant: 0)
                
                addConstraint(centerConstraint)
                
                let horizontalContraint = NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-largePadding-[label]-largePadding-[button]-largePadding-|",
                    metrics: metrics,
                    views: views)
                addConstraints(horizontalContraint)
            } else {
                let horizontalContraint = NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-largePadding-[label]-largePadding-|",
                    metrics: metrics,
                    views: views)
                addConstraints(horizontalContraint)
            }
        }
    }
    
    private func addToScreen() {
        rootView = UIApplication.shared.keyWindow
            ?? UIApplication.shared.delegate?.window
            ?? rootView
        
        if let rootView = rootView {
            rootView.addSubview(self)
            let views = ["view": self]
            
            let horizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[view]-0-|",
                metrics: nil,
                views: views)
            
            rootView.addConstraints(horizontalConstraints)
            
            hiddenConstraint = NSLayoutConstraint(
                item: self,
                attribute: .top,
                relatedBy: .equal,
                toItem: rootView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0)
            
            showingConstraint = NSLayoutConstraint(
                item: self,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: rootView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0)
            
            rootView.addConstraint(hiddenConstraint!)
        }
        
        if let text = text, let textLabel = textLabel {
            textLabel.text = text
        }
        
        if let actionTitle = actionTitle, let actionButton = actionButton {
            actionButton.setTitle(actionTitle, for: .normal)
        }
    }
    
    fileprivate func displaySnackbar() {
        if isShowing || isAnimating {
            return
        }
        
        isShowing = true
        isAnimating = true
        
        arrangeContent()
        addToScreen()
        
        if let rootView = rootView {
            rootView.layoutIfNeeded()
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                animations: {
                    if let hiddenConstraint = self.hiddenConstraint,
                        let showingConstraint = self.showingConstraint {
                        self.textLabel?.alpha = 1
                        self.actionButton?.alpha = 1
                        rootView.removeConstraint(hiddenConstraint)
                        rootView.addConstraint(showingConstraint)
                        rootView.layoutIfNeeded()
                    }
                    
            }, completion: { finished in
                if finished {
                    self.isAnimating = false
                    self.performDelegateAction(#selector(MKSnackbarDelegate.snackbarShown(_:)))
                    self.perform(
                        #selector(MKSnackbar.dismiss),
                        with: nil,
                        afterDelay: self.duration)
                    if let actionButton = self.actionButton {
                        actionButton.isEnabled = true
                    }
                }
            })
        }
    }
    
    private func performDelegateAction(_ action: Selector) {
        for delegate in delegates {
            if let delegate = delegate as? MKSnackbarDelegate,
                delegate.responds(to: action) {
                delegate.perform(action, with: self)
            }
        }
    }
    
}

// MARK:- MKSnackbar Delegate
@objc public protocol MKSnackbarDelegate: NSObjectProtocol {
    @objc optional func snackbarShown(_ snackbar: MKSnackbar)
    @objc optional func snackbabrDismissed(_ snackbar: MKSnackbar)
    @objc optional func actionClicked(_ snackbar: MKSnackbar)
}

// MARK:- MKSnackbar Manager

private class MKSnackbarManager: NSObject, MKSnackbarDelegate {
    
    public static let instance = MKSnackbarManager()
    
    private var snackbarQueue = [MKSnackbar]()
    
    func showSnackbar(_ snackbar: MKSnackbar) {
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
    
    @objc fileprivate func snackbabrDismissed(_ snackbar: MKSnackbar) {
        if let index = snackbarQueue.index(of: snackbar) {
            snackbarQueue.remove(at: index)
        }
        snackbarQueue.first?.displaySnackbar()
    }
}
