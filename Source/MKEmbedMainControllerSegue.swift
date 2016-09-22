//
//  MKEmbedMainControllerSegue.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 10/02/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//
//  Based on KYDrawerController (https://github.com/ykyouhei/KYDrawerController)

import UIKit

open class MKEmbedMainControllerSegue: UIStoryboardSegue {

    final override public func perform() {
        if let sourceViewController = source as? MKSideDrawerViewController {
            sourceViewController.mainViewController = destination
        } else {
            assertionFailure("SourceViewController must be MKDrawerViewController!")
        }
    }
}
