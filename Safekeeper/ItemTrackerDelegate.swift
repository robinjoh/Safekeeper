//
//  ItemTrackerDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

protocol ItemTrackerDelegate: class {
	func itemTracker(found: Bool, item: Item)
	func itemTracker(rangedItems items: [Item])
}