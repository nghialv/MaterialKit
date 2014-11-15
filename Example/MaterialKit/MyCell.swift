//
//  MyCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/16/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class MyCell : MKTableViewCell {
    @IBOutlet var messageLabel: UILabel!
    
    func setMessage(message: String) {
        messageLabel.text = message
    }
}
