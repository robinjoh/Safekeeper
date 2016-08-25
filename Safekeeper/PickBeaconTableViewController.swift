//
//  PickBeaconTableViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class PickBeaconTableViewController: UITableViewController, ItemTrackerDelegate {
	private var locationManager: ItemTracker!
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
		locationManager = ItemTracker.getInstance()
	}
	
	override func viewWillAppear(animated:Bool) {
		super.viewWillAppear(animated)
		locationManager.delegate = self
		locationManager.startRangingNearbyItems()
	}
	
	//MARK: ItemTracker methods
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
		var shouldReload = false
		for nearable in nearables {
			if rangedNearables.updateValue(nearable, forKey: nearable.identifier) == nil {
				shouldReload = true
			}
		}
		let newNearableIds = Set(nearables.map({nearable in return nearable.identifier}))
		let oldIds = Set(rangedNearables.keys)
		if let lostNearableIds = hasLostNearables(oldIds, newIds: newNearableIds) {
			removeLostNearables(lostNearableIds)
			shouldReload = true
		}
		if shouldReload {
			UIView.transitionWithView(beaconView, duration: 0.35, options: .TransitionCrossDissolve, animations: { [weak self] in self?.beaconView.reloadData() }, completion: nil)
		}
	}
	
	private func hasLostNearables(oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtract(newIds)
		return remove.isEmpty ? nil : remove
	}
	
	@objc private func removeLostNearables(removeIds: Set<String>) {
		for id in removeIds {
			if let path = beaconView.indexPath(forBeaconId: id)
				where beaconView.cellForRowAtIndexPath(path) != nil {
				rangedNearables.removeValueForKey(id)
				beaconView.deleteRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Fade)
			}
		}
	}
	
	
	// MARK: - Table view methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rangedNearables.count
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Nearby Beacons"
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: tableView.bounds.width, y: 0, width: tableView.bounds.width, height: tableView.rowHeight))
		let indicator = UIActivityIndicatorView(frame: CGRect(x: tableView.bounds.width / 2, y: 10, width: 20, height: 20))
		indicator.color = UIColor.NavbarColor()
		indicator.startAnimating()
		let lbl = UILabel(frame: CGRect(x: tableView.bounds.width / 2, y: 32, width: 150, height: 20))
		lbl.text = "Nearby Beacons"
		view.addSubview(lbl)
		view.addSubview(indicator)
		return view
	}
	
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as! PickBeaconTableViewCell
		let id = [String](rangedNearables.keys)[indexPath.row]
		if let nearable = rangedNearables[id] {
			cell.idLabel.text = PickBeaconTableViewCell.LabelString.Id(id)
			cell.accessibilityIdentifier = id
			let type = nearable.type
			cell.typeLabel.text = PickBeaconTableViewCell.LabelString.Type(type.string)
			cell.colorLabel.text = PickBeaconTableViewCell.LabelString.Color(nearable.color.string)
		}
        return cell
    }
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		let nearable = nearableForIndexPath(indexPath)
		_selectedBeacon = nearable
		tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
		return indexPath
	}
}
