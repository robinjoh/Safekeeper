//
//  ItemTrackerDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

@objc protocol ItemTrackerDelegate: class {
	@objc optional func itemTracker(didRangeItem item: Item)
	@objc optional func itemTracker(didLoseItem item: Item)
	@objc optional func itemTracker(didFindMonitoredItem item: Item)
	@objc optional func itemTracker(rangedNearables nearables: [ESTNearable])
	@objc optional func itemTracker(rangedItems items: [Item])
}
