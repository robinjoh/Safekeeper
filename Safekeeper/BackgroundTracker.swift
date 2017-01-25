//
//  BackgroundTrackingDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2017-01-18.
//  Copyright © 2017 Robin. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

let DEFAULT_INTERVAL: Double = 15

class BackgroundTracker: ItemTrackerDelegate {
	fileprivate var itemStorage = ItemStorage.instance
	fileprivate var potentiallyLostItems = [String:Item]()
	fileprivate var timer = Timer()
	fileprivate let ELAPSED_TIME_BEFORE_NOTIFYING = 10
	fileprivate var badges = UIApplication.shared.applicationIconBadgeNumber
	fileprivate var itemsLastDetected = [String:Date]()
	
	struct LostItemNotificationText {
		static let title = "ITEM LOST!"
		static var body: (String) -> String = {
			$0 + " is out of range! You didn't leave it behind did you?"
		}
	}
	
	func startLostItemsChecking(_ interval: Double? = DEFAULT_INTERVAL) {
		timer = Timer.scheduledTimer(timeInterval: interval!, target: self, selector: #selector(checkForLostItems), userInfo: nil, repeats: true)
	}
	
	func stopLostItemsChecking() {
		if timer.isValid {
			timer.invalidate()
		}
	}
	
	@objc private func checkForLostItems() {
		let items = Set(potentiallyLostItems.values)
		print(items)
		for item in items {
			let elapsed = Date().timeIntervalSince(itemsLastDetected[item.itemId]!)
			let seconds = Int(elapsed)
			print(seconds)
			if seconds > ELAPSED_TIME_BEFORE_NOTIFYING {
				let center = UNUserNotificationCenter.current()
				let content = UNMutableNotificationContent()
				content.title = LostItemNotificationText.title
				content.body = LostItemNotificationText.body(item.name)
				content.sound = UNNotificationSound.default()
				badges += 1
				content.badge = NSNumber(integerLiteral: badges)
				let request = UNNotificationRequest(identifier: "lostItem", content: content, trigger: nil)
				center.add(request)
				potentiallyLostItems.removeValue(forKey: item.itemId)
			}
		}
	}
	
	func itemTracker(didLoseItem item: Item) {
		print("lost item")
		itemsLastDetected[item.itemId] = Date()
		item.lastDetected = Date()//tiden då föremålet försvann
		potentiallyLostItems[item.itemId] = item
	}
	
	func itemTracker(didFindMonitoredItem item: Item) {
		print("Found item")
		potentiallyLostItems.removeValue(forKey: item.itemId)
	}
}
