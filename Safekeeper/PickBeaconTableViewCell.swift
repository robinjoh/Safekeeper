//
//  PickBeaconTableViewCell.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-15.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class PickBeaconTableViewCell: UITableViewCell {
	@IBOutlet weak var colorLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!

	struct LabelString {
		static let Id: String -> String = { $0 }
		static let Type:String -> String = { "Type: " + $0}
		static let Color:String -> String = { "Color: " + $0}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
