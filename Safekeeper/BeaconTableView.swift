//
//  BeaconTableView.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-15.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class BeaconTableView: UITableView {	
	func indexPath(forBeaconId id: String) -> NSIndexPath? {
		for cell in self.subviews where cell is PickBeaconTableViewCell {
			if cell.accessibilityIdentifier == id {
				return self.indexPathForCell(cell as! PickBeaconTableViewCell)
			}
		}
		return nil
	}
}
