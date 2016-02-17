//
//  MKEmbedDrawerControllerSegue.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 10/02/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//

import UIKit

public class MKEmbedDrawerControllerSegue: UIStoryboardSegue {

    final override public func perform() {
        if let sourceViewController = sourceViewController as? MKSideDrawerViewController {
            sourceViewController.drawerViewController = destinationViewController
        } else {
            assertionFailure("SourceViewController must be MKDrawerViewController!")
        }
    }
}
