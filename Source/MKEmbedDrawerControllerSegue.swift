//
//  MKEmbedDrawerControllerSegue.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 10/02/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//

import UIKit

open class MKEmbedDrawerControllerSegue: UIStoryboardSegue {

    final override public func perform() {
        if let sourceViewController = source as? MKSideDrawerViewController {
            sourceViewController.drawerViewController = destination
        } else {
            assertionFailure("SourceViewController must be MKDrawerViewController!")
        }
    }
}
