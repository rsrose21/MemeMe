//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/19/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit

class MemeTableCell: UITableViewCell
{
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}