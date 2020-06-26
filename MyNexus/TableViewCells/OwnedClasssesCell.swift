//
//  OwnedClasssesCell.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/17/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class OwnedClasssesCell: UITableViewCell {

    
    @IBOutlet weak var className: UILabel!
  
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var red: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        red.layer.cornerRadius = 18
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
