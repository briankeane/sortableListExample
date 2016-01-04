//
//  PlaceholderInfo.swift
//  dragAndDropLists
//
//  Created by Brian D Keane on 1/4/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

struct PlaceholderInfo {
    var tableView:UITableView?
    var indexPath:NSIndexPath?
    var movedElement:AnyObject?

    init(tableView:UITableView? = nil, indexPath:NSIndexPath? = nil, movedElement:AnyObject? = nil) {
        self.tableView = tableView
        self.indexPath = indexPath
        self.movedElement = movedElement
    }
}