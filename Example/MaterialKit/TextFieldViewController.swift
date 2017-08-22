//
//  TextFieldViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {

    @IBOutlet weak var textField1: MKTextField!

    override func viewDidLoad() {
        textField1.layer.borderColor = UIColor.clear.cgColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
