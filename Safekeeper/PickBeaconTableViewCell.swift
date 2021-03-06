//
//  PickBeaconTableViewCell.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-15.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class PickBeaconTableViewCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	
	var beaconView = BeaconView()

	struct LabelString {
		static let ItemType:(String) -> String = { "\($0)"}
		static let Color:(String) -> String = { "Color: \($0)"}
	}
}
