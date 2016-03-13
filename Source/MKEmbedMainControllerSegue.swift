//
//  MKEmbedMainControllerSegue.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 10/02/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//
//  Based on KYDrawerController (https://github.com/ykyouhei/KYDrawerController)

import UIKit

public class MKEmbedMainControllerSegue: UIStoryboardSegue {

    final override public func perform() {
        if let sourceViewController = sourceViewController as? MKSideDrawerViewController {
            sourceViewController.mainViewController = destinationViewController
        } else {
            assertionFailure("SourceViewController must be MKDrawerViewController!")
        }
    }
}
