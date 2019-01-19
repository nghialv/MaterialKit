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
        return UIApplication.value(forKeyPath: #keyPath(shared)) as? UIApplication
    }
}
