//
//  BeaconTableView.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-15.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class BeaconTableView: UITableView {
	private var indexPathForBeaconId = [String:NSIndexPath]()
	
	func indexPath(forBeaconId: String) -> NSIndexPath? {
		return indexPathForBeaconId[forBeaconId]
	}
	
	func setIndexPath(forBeaconId: String, indexPath: NSIndexPath) {
		indexPathForBeaconId[forBeaconId] = indexPath
	}
}
