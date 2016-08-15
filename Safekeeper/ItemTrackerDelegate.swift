//
//  ItemTrackerDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

@objc protocol ItemTrackerDelegate: class {
	optional func itemTracker(didRangeItem item: Item)
	optional func itemTracker(didLoseItem item: Item)
	optional func itemTracker(rangedNearables nearables: [ESTNearable])
}