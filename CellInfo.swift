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
    var movedElement:AnyObject
    
    init(startingTableView:UITableView!, startingIndexPath:NSIndexPath!, movedElement:AnyObject) {
        self.startingIndexPath = startingIndexPath
        self.startingTableView = startingTableView
        self.movedElement = movedElement
    }
}