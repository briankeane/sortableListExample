//
//  LetterTableViewCell.swift
//  dragAndDropLists
//
//  Created by Brian D Keane on 1/2/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

let kLetterTableViewCellReuseIdentifier = "letterTableViewCell"

class LetterTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
