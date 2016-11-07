//
//  AddItemTrackerExtensions.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-06.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation
import UIKit

extension AddItemViewController: ItemTrackerDelegate {
	
	//MARK: ItemTracker methods
	func itemTracker(rangedNearables nearables: [ESTNearable]) {
		var nearablesToRefresh = [ESTNearable]()
		for nearable in nearables {
			if !alreadyUsedIdentifiers.contains(nearable.identifier){
				nearablesToRefresh.append(nearable)
			}
		}
		let result = refreshModel(nearablesToRefresh)
		let nearablesInserted = result.0
		let deleteRowsAt = result.1
		if !deleteRowsAt.isEmpty {
			tableView.deleteRows(at: deleteRowsAt, with: UITableViewRowAnimation.fade)
		}
		if nearablesInserted {
			tableView.reloadSections(IndexSet(integer: UITableView.TableSection.BeaconSection.sectionNumber), with: UITableViewRowAnimation.automatic)
		}
		
	
	}
	
}
