//
//  PickBeaconTableViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class PickBeaconTableViewController: UITableViewController, ItemTrackerDelegate {
	fileprivate var itemTracker: ItemTracker!
	fileprivate var rangedNearables = [String:ESTNearable]() {
		didSet {
			beaconView.reloadData()
		}
	}
	fileprivate var _selectedBeacon: ESTNearable?
	var alreadyUsedIdentifiers = Set<String>()
	fileprivate var beaconView: BeaconTableView! {
		return tableView as! BeaconTableView
	}
	var selectedBeacon: ESTNearable! {
		get{
			return _selectedBeacon ?? nil
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		itemTracker = ItemTracker.getInstance()
	}
	
	override func viewWillAppear(_ animated:Bool) {
		super.viewWillAppear(animated)
		itemTracker.delegate = self
		itemTracker.performOperation(ItemTracker.Operation.ranging(numberOfTimes: 0))
	}
	
	//MARK: ItemTracker methods
	func itemTracker(rangedNearables nearables: [ESTNearable]) {
		var nearablesToRefresh = [ESTNearable]()
		for nearable in nearables {
			if !alreadyUsedIdentifiers.contains(nearable.identifier){
				nearablesToRefresh.append(nearable)
			}
		}
		refreshModel(nearablesToRefresh)
	}
	
	fileprivate func nearableForIndexPath(_ path: IndexPath) -> ESTNearable? {
		if let id = tableView.cellForRow(at: path)?.accessibilityIdentifier {
			return rangedNearables[id]
		}
		return nil
	}
	
	@objc fileprivate func refreshModel(_ nearables: [ESTNearable]) {
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
			UIView.transition(with: beaconView, duration: 0.35, options: .transitionCrossDissolve, animations: { [weak self] in self?.beaconView.reloadData() }, completion: nil)
		}
	}
	
	fileprivate func hasLostNearables(_ oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtracting(newIds)
		return remove.isEmpty ? nil : remove
	}
	
	@objc fileprivate func removeLostNearables(_ removeIds: Set<String>) {
		for id in removeIds {
			if let path = beaconView.indexPath(forBeaconId: id)
				, beaconView.cellForRow(at: path as IndexPath) != nil {
				rangedNearables.removeValue(forKey: id)
				beaconView.deleteRows(at: [path as IndexPath], with: UITableViewRowAnimation.fade)
			}
		}
	}
	
	
	// MARK: - Table view methods
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rangedNearables.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Nearby Beacons"
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: tableView.bounds.width, y: 5, width: tableView.bounds.width, height: tableView.rowHeight))
		let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 34, width: 10, height: 10))
		indicator.color = UIColor.NavbarColor()
		indicator.startAnimating()
		let lbl = UILabel(frame: CGRect(x: indicator.frame.size.width + 17, y: 30, width: 160, height: 20))
		lbl.adjustsFontSizeToFitWidth = true
		lbl.textColor = UIColor.NavbarColor()
		lbl.text = "Scanning for beacons"
		view.addSubview(lbl)
		view.addSubview(indicator)
		return view
	}
	
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell", for: indexPath) as! PickBeaconTableViewCell
		let id = [String](rangedNearables.keys)[(indexPath as NSIndexPath).row]
		if let nearable = rangedNearables[id] {
			cell.idLabel.text = PickBeaconTableViewCell.LabelString.Id(id)
			cell.accessibilityIdentifier = id
			let type = nearable.type
			cell.typeLabel.text = PickBeaconTableViewCell.LabelString.ItemType(type.string)
			cell.colorLabel.text = PickBeaconTableViewCell.LabelString.Color(nearable.color.string)
		}
        return cell
    }
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let nearable = nearableForIndexPath(indexPath)
		_selectedBeacon = nearable
		tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
		return indexPath
	}
}
