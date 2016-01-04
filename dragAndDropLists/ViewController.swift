//
//  ViewController.swift
//  dragAndDropLists
//
//  Created by Brian D Keane on 1/1/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    var sortableTableViews:Array<UITableView>! = []
    var activeCellInfo:CellInfo?
    var placeholderInfo:PlaceholderInfo?
    
    var itemInfo:Dictionary<String,AnyObject>?
    
    var numbers:Array<String> = ["1",
                                "2",
                                "3",
                                "4",
                                "5",
                                "6",
                                "7",
                                "8"]
    
    var letters:Array<String> = ["a",
                                "b",
                                "c",
                                "d",
                                "e",
                                "f" 
                            ]
    
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet weak var letterTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.numberTableView.delegate = self
        self.numberTableView.dataSource = self

        self.letterTableView.delegate = self
        self.letterTableView.dataSource = self
        
        let longpressNumber = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        
        self.view.addGestureRecognizer(longpressNumber)
        //self.letterTableView.addGestureRecognizer(longpressLetter)
        
        self.sortableTableViews = [self.numberTableView, self.letterTableView]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableViewPressed(parentViewPoint:CGPoint) -> UITableView? {
        for (var i=0;i<self.sortableTableViews.count;i++) {
            if CGRectContainsPoint(self.sortableTableViews[i].frame, parentViewPoint) {
                return self.sortableTableViews[i]
            }
        }
        return nil
    }

    
    @objc func longPressed(gestureRecognizer:UILongPressGestureRecognizer) {
        let longPress = gestureRecognizer as UILongPressGestureRecognizer
        let state = longPress.state
        
        // figure is there a tableview there?
        var startingTableView:UITableView? = tableViewPressed(longPress.locationInView(self.view))
        
        let pressedLocationInTableView = longPress.locationInView(startingTableView)
        let pressedLocationInParentView = longPress.locationInView(self.view)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        
        var newIndexPath:NSIndexPath?
        var hoveredOverTableView:UITableView?
        
        for (var i=0;i<self.sortableTableViews.count;i++) {
            newIndexPath = self.sortableTableViews[i].indexPathForRowAtPoint(pressedLocationInTableView)
            if newIndexPath != nil {
                hoveredOverTableView = self.sortableTableViews[i]
                break
            }
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            // figure is there a tableview there?
            let startingTableView = tableViewPressed(longPress.locationInView(self.view))
            
            let startingLocationInTableView = longPress.locationInView(startingTableView)
            let startingLocationInParentView = longPress.locationInView(self.view)
            let indexPath = startingTableView!.indexPathForRowAtPoint(startingLocationInTableView)
            
            if indexPath != nil {
                self.activeCellInfo = CellInfo(startingTableView: startingTableView, startingIndexPath: indexPath)
                self.placeholderInfo = PlaceholderInfo(tableView: startingTableView, indexPath: indexPath)
                
                let cell = startingTableView!.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                
                My.cellSnapshot  = snapshopOfCell(cell)
                
                My.cellSnapshot!.center = pressedLocationInParentView
                
                My.cellSnapshot!.alpha = 0.0
                
                self.view.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in

                    My.cellSnapshot!.center = pressedLocationInParentView
                    
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    My.cellSnapshot!.alpha = 0.98
                    
                    cell.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        
                        if finished {
                            // hide the cell being moved after snapshot gets drawn
                            cell.hidden = true
                        }
                        
                })
                
            }
            
        case UIGestureRecognizerState.Changed:
            // chaned list
            if (hoveredOverTableView != self.placeholderInfo?.tableView) {
                
                // EXITED list
                if (hoveredOverTableView == nil) {
                    print("just left view")
                    
                    self.placeholderInfo?.tableView?.deleteRowsAtIndexPaths([placeholderInfo!.indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.placeholderInfo?.tableView = nil
                    self.placeholderInfo?.indexPath = nil
                
                // ELSE ENTERED list
                } else {
                    print("just entered \(hoveredOverTableView)")
                    placeholderInfo?.tableView = hoveredOverTableView
                    placeholderInfo?.indexPath = newIndexPath
                }
            
            } else {
                // IF moved within list
                if (newIndexPath != placeholderInfo?.indexPath) {
                    print("changed IndexPath.row to \(newIndexPath?.row)")
                    //swap(&self.numbers[indexPath!.row], &self.numbers[Path.initialIndexPath!.row])
                    hoveredOverTableView!.moveRowAtIndexPath(self.placeholderInfo!.indexPath!, toIndexPath: newIndexPath!)
                    placeholderInfo?.indexPath = newIndexPath
                }
            }
            
            if ((hoveredOverTableView != nil) && (newIndexPath != self.placeholderInfo?.indexPath)) {
                
            }
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = pressedLocationInParentView
            })
            
        default:
            // finished drag and drop
            
            // if let go outside of any tableViewCell, just put it back
            if (hoveredOverTableView == nil) {
                for (var i=0;i<self.sortableTableViews.count;i++) {
                    self.sortableTableViews[i].reloadData()
                }
            } else {
                // call received 
                self.receivedItem(placeholderInfo!.indexPath!, receivingTable: hoveredOverTableView!)
            }
            
            // place where hidden
            let cell = self.activeCellInfo!.startingTableView.cellForRowAtIndexPath(self.activeCellInfo!.startingIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        self.placeholderInfo = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
        }
    }
    
    func receivedItem(newIndexPath:NSIndexPath, receivingTable:UITableView) {
        print("received at index: \(newIndexPath.row)")
        
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.letterTableView {
            print("test")
        }
        
        
        if tableView == self.numberTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(kNumberTableViewCellIdentifier, forIndexPath: indexPath) as! NumberTableViewCell
            cell.valueLabel.text = self.numbers[indexPath.row]
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(kLetterTableViewCellReuseIdentifier, forIndexPath: indexPath) as! LetterTableViewCell
            cell.valueLabel.text = self.letters[indexPath.row]
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.numberTableView {
            return self.numbers.count
        } else {
            return self.letters.count
        }
    }

}

