//
//  TextViewController.swift
//  MaterialKit
//
//  Created by Kaushal Deo on 12/26/15.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    
    @IBOutlet weak var textView1 : MKTextView!
    @IBOutlet weak var textView2: MKTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView2.layer.borderColor = UIColor.clearColor().CGColor
        textView2.tintColor = UIColor.MKColor.Blue
        textView2.rippleLocation = .Right
        textView2.cornerRadius = 0
        textView2.bottomBorderEnabled = true
        
    }
    
    func buttonPressed() {
        print("Button pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.view.endEditing(true)
    }

}
