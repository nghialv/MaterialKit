//
//  ViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func cardViewClicked(sender: AnyObject) {
        let snackbar = MKSnackbar(
            withTitle: "You clicked on CardView\nThis is a SnackBar :)",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "Done",
            withActionButtonColor: UIColor.MKColor.Blue)
        snackbar.show()
    }
}