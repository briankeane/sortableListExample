//
//  CellInfo.swift
//  dragAndDropLists
//
//  Created by Brian D Keane on 1/4/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

struct CellInfo {
    var startingIndexPath:NSIndexPath!
    var startingTableView:UITableView!
    
    init(startingTableView:UITableView!, startingIndexPath:NSIndexPath!) {
        self.startingIndexPath = startingIndexPath
        self.startingTableView = startingTableView
    }
}