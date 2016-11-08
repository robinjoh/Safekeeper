//
//  TableViewDataSourceExtensions.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-06.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation
import UIKit


//MARK: TableViewDataSource methods.
extension AddItemViewController: UITableViewDataSource {
	
	//MARK: TABLEVIEWDATASOURCE
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return UITableView.TableSection.sectionHeaderTitle(section)
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return section == UITableView.TableSection.BeaconSection.sectionNumber ? UITableView.TableSection.BeaconSection.sectionFooterText : nil
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return UITableView.TableSection.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == UITableView.TableSection.BeaconSection.sectionNumber ? rangedNearables.count : 1
	}
	
	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		switch indexPath.section {
		case UITableView.TableSection.NameSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemNameCell)!
			(cell as! NameTableViewCell).nameField.delegate = self
			break
		case UITableView.TableSection.ImageSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemImageCell, for: indexPath)
			break
		case UITableView.TableSection.BeaconSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.PickBeaconCell, for: indexPath)
			let pickBeaconCell = cell as! PickBeaconTableViewCell
			let id = [String](rangedNearables.keys)[indexPath.row]
			guard let nearable = rangedNearables[id] else {
				break
			}
			pickBeaconCell.typeLabel.text = PickBeaconTableViewCell.LabelString.ItemType(nearable.type.string)
			pickBeaconCell.idLabel.text = id
			pickBeaconCell.accessibilityIdentifier = id
			break
		default:
			break
		}
		return cell
	}
	
}
