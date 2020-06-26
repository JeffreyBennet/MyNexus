//
//  JoinedClassCell.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/17/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class JoinedClassCell: UITableViewCell {
@IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var view1: UIImageView!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var redView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        view1.layer.cornerRadius = 18
       // view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor(named: "Color")?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
