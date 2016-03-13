//
//  BarButtonItemViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class BarButtonItemViewController: UIViewController {

    @IBOutlet var progressView: MKActivityIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.startAnimating()
    }
}
