//
//  PickBeaconTableViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class PickBeaconTableViewController: UITableViewController, ItemTrackerDelegate {
	private var locationManager = ItemTracker.getInstance()
	private var rangedNearables = [String:ESTNearable]()
	private var _selectedBeacon: ESTNearable?
	private var beaconView: BeaconTableView! {
		return tableView as! BeaconTableView
	}
	var selectedBeacon: ESTNearable! {
		get{
			return _selectedBeacon ?? nil
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		locationManager.startRangingNearbyItems()
		locationManager.delegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
//		super.viewDidAppear(animated)
//		if rangedNearables.count == 0 {
//			let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 400))
//			let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
//			lbl.text = "hej"
//			view.addSubview(lbl)
//			tableView.backgroundView = view
//		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rangedNearables.count
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Nearby Beacons"
	}
	
	func itemTracker(didLoseItem item: Item) {}
	
	func itemTracker(didRangeItem item: Item) {}
	
	func itemTracker(rangedNearables nearables: [ESTNearable]) {
		refreshModel(nearables)
	}
	
	private func nearableForIndexPath(path: NSIndexPath) -> ESTNearable? {
		if let id = tableView.cellForRowAtIndexPath(path)?.accessibilityIdentifier {
			return rangedNearables[id]
		}
		return nil
	}
	
	@objc private func refreshModel(nearables: [ESTNearable]) {
		var reload = false
		for nearable in nearables {
			if rangedNearables.updateValue(nearable, forKey: nearable.identifier) == nil {
				reload = true
			}
		}
		let newNearableIds = Set(nearables.map({nearable in
			return nearable.identifier}))
		let oldIds = Set(rangedNearables.keys)
		if let lostNearableIds = hasLostNearables(oldIds, newIds: newNearableIds) {
			removeLostNearables(lostNearableIds)
			reload = true
		}
		if reload {
			tableView.reloadData()
		}
	}
	
	private func hasLostNearables(oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtract(newIds)
		return !remove.isEmpty ? remove : nil
	}
	
	@objc private func removeLostNearables(removeIds: Set<String>) -> Bool {
		for id in removeIds {
			if rangedNearables.removeValueForKey(id) != nil {
				for cell in tableView.subviews where cell is PickBeaconTableViewCell {
					let castCell = cell as! PickBeaconTableViewCell
					if cell.accessibilityIdentifier == id {
						tableView.deleteRowsAtIndexPaths([tableView.indexPathForCell(castCell)!]
, withRowAnimation: UITableViewRowAnimation.Left)
					}
				}
			}
		}
		return !removeIds.isEmpty
	}
		
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as! PickBeaconTableViewCell
		let id = Array(rangedNearables.keys)[indexPath.row]
		if let nearable = rangedNearables[id] {
			cell.idLabel.text = PickBeaconTableViewCell.LabelString.Id(id)
			cell.accessibilityIdentifier = id
			let type = nearable.type
			cell.typeLabel.text = PickBeaconTableViewCell.LabelString.Type(type.string)
			cell.colorLabel.text = PickBeaconTableViewCell.LabelString.Color(nearable.color.string)
		}
		beaconView.indexPathForBeaconId[id] = indexPath
        return cell
    }
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		let nearable = nearableForIndexPath(indexPath)
		_selectedBeacon = nearable
		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
		return indexPath
	}
}
