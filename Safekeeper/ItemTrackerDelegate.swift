//
//  ItemTrackerDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

protocol ItemTrackerDelegate: class {
	func didFindItem(item: String)
	func didLoseItem(item: String)
	func didRangeItems(items: [Item])
}