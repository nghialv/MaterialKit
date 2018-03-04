//
//  MKExtensions.swift
//  MaterialKit
//
//  Created by Apollo Zhu on 2018/3/3.
//  Copyright © 2018 Le Van Nghia. All rights reserved.
//

import UIKit

extension UIApplication {
    class var this: UIApplication? {
        if #available(iOSApplicationExtension 8.0, tvOSApplicationExtension 9.0, *) {
            return nil
        } else {
            return UIApplication.value(forKeyPath: #keyPath(shared)) as? UIApplication
        }
    }
}
