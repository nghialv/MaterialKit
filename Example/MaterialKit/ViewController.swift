//
//  ViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        let hamburgerButton = MKButton(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
        hamburgerButton.setImage(UIImage(named: "uibaritem_icon.png"), forState: .Normal)
        hamburgerButton.maskEnabled = false
        hamburgerButton.backgroundAnimationEnabled = false
        hamburgerButton.rippleDuration = 0.15
        hamburgerButton.addTarget(self, action: Selector("toggleDrawer"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hamburgerButton)
    }

    func toggleDrawer() {
        if let sideDrawerViewController = self.sideDrawerViewController {
            sideDrawerViewController.toggleDrawer()
        }
    }

    @IBAction func cardViewClicked(sender: AnyObject) {
        let snackbar = MKSnackbar(
            withTitle: "You clicked on CardView\nThis is a SnackBar :)",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "Done",
            withActionButtonColor: UIColor.MKColor.Red.P100)
        snackbar.show()
    }
}