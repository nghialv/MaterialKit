//
//  MKExtensions.swift
//  MaterialKit
//
//  Created by Apollo Zhu on 2018/3/3.
//  Copyright © 2018 Le Van Nghia. All rights reserved.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
@available(watchOSApplicationExtension, unavailable)
@available(tvOSApplicationExtension, unavailable)
@available(iOSMacApplicationExtension, unavailable)
@available(OSXApplicationExtension, unavailable)
extension UIApplication {
    class var this: UIApplication? {
        return UIApplication.shared
    }
}
