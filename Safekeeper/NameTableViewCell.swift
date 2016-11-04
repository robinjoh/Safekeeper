//
//  NameTableViewCell.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
	@IBOutlet weak var nameField: UITextField!

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
