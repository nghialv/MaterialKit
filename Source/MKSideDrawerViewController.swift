//
//  MKSideDrawerViewController.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 10/02/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//
//  Based on KYDrawerController (https://github.com/ykyouhei/KYDrawerController)

import UIKit

public extension UIViewController {
    /**
     A convenience property that provides access to the SideNavigationViewController.
     This is the recommended method of accessing the SideNavigationViewController
     through child UIViewControllers.
     */
    public var sideDrawerViewController: MKSideDrawerViewController? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is MKSideDrawerViewController {
                return viewController as? MKSideDrawerViewController
            }
            viewController = viewController?.parentViewController
        }
        return nil
    }
}

@objc public protocol MKSideDrawerControllerDelegate {
    optional func drawerController(drawerController: MKSideDrawerViewController, stateChanged state: MKSideDrawerViewController.DrawerState)
}

public class MKSideDrawerViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Types

    @objc public enum DrawerDirection: Int {
        case Left, Right
    }

    @objc public enum DrawerState: Int {
        case Opened, Closed
    }

    private let _kContainerViewMaxAlpha : CGFloat = 0.2

    private let _kDrawerAnimationDuration: NSTimeInterval = 0.25

    // MARK: - Properties

    @IBInspectable var mainSegueIdentifier: String?

    @IBInspectable var drawerSegueIdentifier: String?

    private var _drawerConstraint: NSLayoutConstraint!

    private var _drawerWidthConstraint: NSLayoutConstraint!

    private var _panStartLocation = CGPointZero

    private var _panDelta: CGFloat = 0

    lazy private var _containerView: UIView = {
        let view = UIView(frame: self.view.frame)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: "didtapContainerView:"
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0)
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        return view
    }()

    public var screenEdgePanGestreEnabled = true

    lazy private(set) var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: "handlePanGesture:"
        )
        switch self.drawerDirection {
        case .Left: gesture.edges = .Left
        case .Right: gesture.edges = .Right
        }
        gesture.delegate = self
        return gesture
    }()

    lazy private(set) var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: "handlePanGesture:"
        )
        gesture.delegate = self
        return gesture
    }()

    public weak var delegate: MKSideDrawerControllerDelegate?

    public var drawerDirection: DrawerDirection = .Left {
        didSet {
            switch drawerDirection {
            case .Left: screenEdgePanGesture.edges = .Left
            case .Right: screenEdgePanGesture.edges = .Right
            }
            let tmp = drawerViewController
            drawerViewController = tmp
        }
    }

    public var drawerState: DrawerState {
        get { return _containerView.hidden ? .Closed : .Opened }
        set { setDrawerState(drawerState, animated: false) }
    }

    @IBInspectable public var drawerWidth: CGFloat = 240 {
        didSet { _drawerWidthConstraint?.constant = drawerWidth }
    }

    public var mainViewController: UIViewController! {
        didSet {
            if let oldController = oldValue {
                oldController.willMoveToParentViewController(nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            guard let mainViewController = mainViewController else { return }
            let viewDictionary = ["mainView" : mainViewController.view]
            mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
            addChildViewController(mainViewController)
            view.insertSubview(mainViewController.view, atIndex: 0)
            view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[mainView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
            )
            view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[mainView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
            )
            mainViewController.didMoveToParentViewController(self)
        }
    }

    public var drawerViewController : UIViewController? {
        didSet {
            if let oldController = oldValue {
                oldController.willMoveToParentViewController(nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            guard let drawerViewController = drawerViewController else { return }
            let viewDictionary = ["drawerView" : drawerViewController.view]
            let itemAttribute: NSLayoutAttribute
            let toItemAttribute: NSLayoutAttribute
            switch drawerDirection {
            case .Left:
                itemAttribute = .Right
                toItemAttribute = .Left
            case .Right:
                itemAttribute = .Left
                toItemAttribute = .Right
            }

            drawerViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
            drawerViewController.view.layer.shadowOpacity = 0.4
            drawerViewController.view.layer.shadowRadius = 5.0
            drawerViewController.view.translatesAutoresizingMaskIntoConstraints = false
            addChildViewController(drawerViewController)
            _containerView.addSubview(drawerViewController.view)
            _drawerWidthConstraint = NSLayoutConstraint(
                item: drawerViewController.view,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1,
                constant: drawerWidth
            )
            drawerViewController.view.addConstraint(_drawerWidthConstraint)

            _drawerConstraint = NSLayoutConstraint(
                item: drawerViewController.view,
                attribute: itemAttribute,
                relatedBy: NSLayoutRelation.Equal,
                toItem: _containerView,
                attribute: toItemAttribute,
                multiplier: 1,
                constant: 0
            )
            _containerView.addConstraint(_drawerConstraint)
            _containerView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[drawerView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
            )
            _containerView.updateConstraints()
            drawerViewController.updateViewConstraints()
            drawerViewController.didMoveToParentViewController(self)
        }
    }

    // MARK: - initialize

    public convenience init(drawerDirection: DrawerDirection, drawerWidth: CGFloat) {
        self.init()
        self.drawerDirection = drawerDirection
        self.drawerWidth = drawerWidth
    }

    // MARK: - Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewDictionary = ["_containerView": _containerView]

        view.addGestureRecognizer(screenEdgePanGesture)
        view.addGestureRecognizer(panGesture)
        view.addSubview(_containerView)
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[_containerView]-0-|",
            options: [],
            metrics: nil,
            views: viewDictionary
        )
        )
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[_containerView]-0-|",
            options: [],
            metrics: nil,
            views: viewDictionary
        )
        )
        _containerView.hidden = true

        if let mainSegueID = mainSegueIdentifier {
            performSegueWithIdentifier(mainSegueID, sender: self)
        }
        if let drawerSegueID = drawerSegueIdentifier {
            performSegueWithIdentifier(drawerSegueID, sender: self)
        }
    }

    // MARK: - Public Method

    public func setDrawerState(state: DrawerState, animated: Bool) {
        _containerView.hidden = false
        let duration: NSTimeInterval = animated ? _kDrawerAnimationDuration : 0
        setWindowLevel(state == .Opened ? UIWindowLevelStatusBar + 1 : UIWindowLevelNormal)
        UIView.animateWithDuration(duration,
            delay: 0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                switch state {
                case .Closed:
                    self._drawerConstraint.constant = 0
                    self._containerView.backgroundColor = UIColor(white: 0, alpha: 0)
                case .Opened:
                    let constant: CGFloat
                    switch self.drawerDirection {
                    case .Left:
                        constant = self.drawerWidth
                    case .Right:
                        constant = -self.drawerWidth
                    }
                    self._drawerConstraint.constant = constant
                    self._containerView.backgroundColor = UIColor(
                        white: 0
                    , alpha: self._kContainerViewMaxAlpha
                    )
                }
                self._containerView.layoutIfNeeded()
            }) { (finished: Bool) -> Void in
                if state == .Closed {
                    self._containerView.hidden = true
                }
                self.delegate?.drawerController?(self, stateChanged: state)
            }
    }

    public func transitionFromMainViewController(toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        mainViewController.willMoveToParentViewController(nil)
        addChildViewController(toViewController)
        toViewController.view.frame = view.bounds
        transitionFromViewController(
            mainViewController,
            toViewController: toViewController,
            duration: duration,
            options: options,
            animations: animations,
            completion: { [unowned self](result: Bool) in
                toViewController.didMoveToParentViewController(self)
                self.mainViewController.removeFromParentViewController()
                self.mainViewController = toViewController
                if let completion = completion {
                    completion(result)
                }
            })
    }

    public func toggleDrawer(animated: Bool = true) {
        setDrawerState(
            drawerState == .Opened ? .Closed : .Opened,
            animated: animated)
    }

    // MARK: - Private Method

    final func handlePanGesture(sender: UIGestureRecognizer) {
        _containerView.hidden = false
        if sender.state == .Began {
            _panStartLocation = sender.locationInView(view)
        }

        let delta = CGFloat(sender.locationInView(view).x - _panStartLocation.x)
        let constant : CGFloat
        let backGroundAlpha : CGFloat
        let drawerState : DrawerState

        switch drawerDirection {
        case .Left:
            drawerState = _panDelta < 0 ? .Closed : .Opened
            constant = min(_drawerConstraint.constant + delta, drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha * (abs(constant) / drawerWidth)
            )
        case .Right:
            drawerState = _panDelta > 0 ? .Closed : .Opened
            constant = max(_drawerConstraint.constant + delta, -drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha * (abs(constant) / drawerWidth)
            )
        }

        if (sender.state == .Began) {
            if drawerState == .Closed {
                setWindowLevel(UIWindowLevelStatusBar + 1)
            }
        }

        _drawerConstraint.constant = constant
        _containerView.backgroundColor = UIColor(
            white: 0,
            alpha: backGroundAlpha
        )

        switch sender.state {
        case .Changed:
            _panStartLocation = sender.locationInView(view)
            _panDelta = delta
        case .Ended, .Cancelled:
            setDrawerState(drawerState, animated: true)
        default:
            break
        }
    }

    final func didtapContainerView(gesture: UITapGestureRecognizer) {
        setDrawerState(.Closed, animated: true)
    }

    private func setWindowLevel(windowLevel: UIWindowLevel) {
        if let delegate = UIApplication.sharedApplication().delegate {
            if let window = delegate.window {
                if let window = window {
                    window.windowLevel = windowLevel
                }
            }
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        switch gestureRecognizer {
        case panGesture:
            return drawerState == .Opened
        case screenEdgePanGesture:
            return screenEdgePanGestreEnabled ? drawerState == .Closed : false
        default:
            return touch.view == gestureRecognizer.view
        }
    }
}
