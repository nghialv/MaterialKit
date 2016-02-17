//
//  TableViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/16/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var labels = ["MKButton", "MKTextField", "MKTableViewCell", "MKTextView", "MKColor", "MKLayer", "MKAlert", "MKCheckBox"]
    var circleColors = [UIColor.MKColor.Blue.P500, UIColor.MKColor.Grey.P500, UIColor.MKColor.Green.P500]

    var refreshView: MKRefreshControl?

    override func viewDidLoad() {
        refreshView = MKRefreshControl()
        refreshView!.addToScrollView(self.tableView, withRefreshBlock: { () -> Void in
            self.tableViewRefresh()
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! MyCell
        cell.setMessage(labels[indexPath.row % labels.count])

        let index = indexPath.row % circleColors.count
        cell.rippleLayerColor = circleColors[index]

        return cell
    }

    func tableViewRefresh() {
        NSLog("Refresh Block")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            NSLog("End refreshing")
            self.refreshView!.endRefreshing()
        })
    }
}