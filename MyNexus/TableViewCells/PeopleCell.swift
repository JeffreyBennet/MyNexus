//
//  PeopleCell.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var whiteView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
                   whiteView.layer.cornerRadius = 18
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
