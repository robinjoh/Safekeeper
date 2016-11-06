//
//  OverViewTrackerExtension.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-06.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

extension ItemOverviewController: ItemTrackerDelegate {
	
	//MARK: - itemtracker methods
	func itemTracker(didRangeItem item: Item) {
		print("hehe \(item)")
	}
	
	func itemTracker(didLoseItem item: Item){
		print("förlorade \(item)")
	}
	
}
