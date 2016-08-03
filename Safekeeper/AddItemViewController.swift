//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, ItemTrackerDelegate {
	private static let SECTION_TITLES = ["Beacon to track", "Name of item", "Item image"]
	private let nearableManager = ItemTracker.getInstance()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.titleView = nil
		nearableManager.delegate = self
		nearableManager.startRangingNearbyItems()
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
		print(indexPath.section)
		switch indexPath.section {
		case 0:
			return tableView.dequeueReusableCellWithIdentifier("beaconCell")!
		case 1: return tableView.dequeueReusableCellWithIdentifier("nameCell")!
		case 2: return tableView.dequeueReusableCellWithIdentifier("addImageCell")!
		default: return UITableViewCell()
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return AddItemViewController.SECTION_TITLES[section]
	}
	
	func itemTracker(rangedItems items: [Item]) {
		
	}
	
	func itemTracker(found: Bool, item: Item) {
		
	}

	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
