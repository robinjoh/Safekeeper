//
//  AddItemViewControllerNew.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-27.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ItemTrackerDelegate {
	fileprivate var _selectedBeacon: ESTNearable?
	fileprivate var selectedCell: UITableViewCell?
	var alreadyUsedIdentifiers = Set<String>()
	fileprivate(set) var selectedBeacon: ESTNearable! {
		get {
			return _selectedBeacon ?? nil
		}
		set {
			_selectedBeacon = newValue
		}
	}
	private(set) var selectedImage: UIImage? {
		didSet{
			if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: TableSection.ImageSection.sectionNumber)) as? AddItemImageTableViewCell {
				if selectedImage != nil {
					cell.chooseImageLbl.text = ""
				} else {
					cell.chooseImageLbl.text = cell.chooseImageText
				}
			}
		}
	}
	private let imagePicker = UIImagePickerController()
	private var itemTracker: ItemTracker!
	fileprivate var rangedNearables = [String:ESTNearable]()
	private(set) var itemName: String?
	fileprivate var nameCell: NameTableViewCell?

	private struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}
	
	fileprivate struct TableSection {
		static let numberOfSections = 3
		
		struct NameSection {
			static let sectionNumber = 0
			static let sectionHeaderTitle = "NAME"
		}
		struct ImageSection {
			static let sectionNumber = 1
			static let sectionHeaderTitle = "IMAGE"
		}
		struct BeaconSection{
			static let sectionNumber = 2
			static let sectionHeaderTitle = "PICK BEACON"
			static let sectionFooterText = "Select one of the beacon IDs showing up in the list to connect it to the item you are about to create."
		}
		
		static func sectionHeaderTitle(_ sectionNumber: Int) -> String {
			return sectionNumber == NameSection.sectionNumber ? NameSection.sectionHeaderTitle : sectionNumber == ImageSection.sectionNumber ? ImageSection.sectionHeaderTitle : sectionNumber == BeaconSection.sectionNumber ? BeaconSection.sectionHeaderTitle : ""
		}
	}

	private func performSetup(){
		tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		imagePicker.navigationBar.tintColor = UIColor.mainTextColor
		imagePicker.navigationBar.barTintColor = UIColor.navbarColor
		imagePicker.navigationBar.isTranslucent = false
		imagePicker.delegate = self
		itemTracker = ItemTracker.getInstance()
	}


	
    override func viewDidLoad() {
        super.viewDidLoad()
		performSetup()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		itemTracker.delegate = self
		itemTracker.performOperation(ItemTracker.Operation.ranging(numberOfTimes: 0))
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func textFieldEdited(_ sender: UITextField) {
		navigationItem.rightBarButtonItem?.isEnabled = allRequiredItemsSelected()
	}
	
	fileprivate func allRequiredItemsSelected() -> Bool {
		return (self._selectedBeacon != nil && itemName != nil && !(itemName?.isEmpty)!)
	}
	
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		navigationItem.rightBarButtonItem?.isEnabled = false
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return (nameCell?.nameField.resignFirstResponder())!
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		itemName = textField.text
	}
	
	func showImagePickerChoiceDialog() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		alertController.addAction(UIAlertAction(title: AlertTitle.Camera, style: UIAlertActionStyle.default, handler: {[weak self] (action) -> Void in self?.showImagePickerController(.camera)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Library, style: UIAlertActionStyle.default, handler: { [weak self] (action) -> Void in self?.showImagePickerController(.photoLibrary)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Cancel, style: UIAlertActionStyle.cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
		alertController.view.tintColor = UIColor.mainColor
	}
	
	private func showImagePickerController(_ choice: UIImagePickerControllerSourceType){
		if choice == .camera && UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		self.present(imagePicker, animated: true, completion: nil)
	}

	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		selectedImage = image
		dismiss(animated: true, completion: nil)
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))! as!AddItemImageTableViewCell
		cell.roundedImageView.image = image
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
		if let id = self.tableView.cellForRow(at: path)?.accessibilityIdentifier {
			return rangedNearables[id]
		}
		return nil
	}
	
	@objc private func refreshModel(_ nearables: [ESTNearable]) {
		var shouldRefresh = false
		for nearable in nearables {
			if rangedNearables.updateValue(nearable, forKey: nearable.identifier) == nil {
				shouldRefresh = true
			}
		}
		let newNearableIds = Set(nearables.map({nearable in return nearable.identifier}))
		let oldIds = Set(rangedNearables.keys)
		if let lostNearableIds = hasLostNearables(oldIds, newIds: newNearableIds) {
			removeLostNearables(lostNearableIds)
		}
		if shouldRefresh {
			tableView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.automatic)
		}
	}
	
	fileprivate func hasLostNearables(_ oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtracting(newIds)
		return remove.isEmpty ? nil : remove
	}
	
	@objc fileprivate func removeLostNearables(_ removeIds: Set<String>) {
		for id in removeIds {
			if let path = tableView.indexPath(forBeaconId: id)
				, tableView.cellForRow(at: path as IndexPath) != nil {
				rangedNearables.removeValue(forKey: id)
				tableView.deleteRows(at: [path as IndexPath], with: UITableViewRowAnimation.automatic)
			}
		}
	}
}



//MARK: TABLEVIEW DELEGATE METHODS
extension AddItemViewController {
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		var view:UIView? = nil
//		if section == TableSection.BeaconSection.sectionNumber {
//			view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.rowHeight))
//			let lbl = UILabel(frame: CGRect(x: 15, y: 6, width: 100, height: 20))
//			lbl.adjustsFontSizeToFitWidth = true
//			lbl.font = UIFont.systemFont(ofSize: 13.5)
//			lbl.textColor = UIColor.gray
//			lbl.text = TableSection.sectionHeaderTitle(section)
//			let indicator = UIActivityIndicatorView(frame: CGRect(x: lbl.bounds.width + 15, y: 10, width: 10, height: 10))
//			indicator.color = UIColor.mainTextColor
//			indicator.startAnimating()
//			view!.backgroundColor = UIColor.tableSectionHeaderBackgroundColor
//			view!.addSubview(lbl)
//			view!.addSubview(indicator)
//		}
//		return view
//	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if let headerView = view as? UITableViewHeaderFooterView {
			headerView.textLabel?.textColor = UIColor.darkGray
			headerView.backgroundView?.backgroundColor = UIColor.clear
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		if let footerView = view as? UITableViewHeaderFooterView {
			footerView.backgroundView?.backgroundColor = UIColor.clear
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.section == TableSection.BeaconSection.sectionNumber {
			let pickBeaconCell = cell as! PickBeaconTableViewCell
			let id = [String](rangedNearables.keys)[indexPath.row]
			if let nearable = rangedNearables[id] {
				pickBeaconCell.typeLabel.text = PickBeaconTableViewCell.LabelString.ItemType(nearable.type.string)
				pickBeaconCell.idLabel.text = PickBeaconTableViewCell.LabelString.Id(id)
				pickBeaconCell.accessibilityIdentifier = id
			}
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return TableSection.sectionHeaderTitle(section)
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return TableSection.numberOfSections
	}
	
	//TODO: använd cellerna istället för hårdkodade värden för höjd.
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var cell = UITableViewCell()
		switch indexPath.section {
		case TableSection.NameSection.sectionNumber:
			if let nameCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemNameCell) {
				cell = nameCell
			}
			break
		case TableSection.ImageSection.sectionNumber:
			if let imageCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemImageCell) {
				cell = imageCell
			}
			break
		case TableSection.BeaconSection.sectionNumber:
			if let beaconCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.PickBeaconCell) {
				cell = beaconCell
			}
		default:
			break
		}
		return cell.bounds.size.height
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == TableSection.BeaconSection.sectionNumber ? rangedNearables.count : 1
	}
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		switch indexPath.section {
		case TableSection.BeaconSection.sectionNumber:
			let cell = tableView.cellForRow(at: indexPath) as! PickBeaconTableViewCell
			selectedCell?.accessoryType = UITableViewCellAccessoryType.none
			selectedCell = cell
			_selectedBeacon = rangedNearables[cell.idLabel.text!]
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
			let nearable = nearableForIndexPath(indexPath)
			_selectedBeacon = nearable
			break
		case TableSection.ImageSection.sectionNumber:
			showImagePickerChoiceDialog()
			break;
		default: return nil
		}
		return indexPath
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return section == TableSection.BeaconSection.sectionNumber ? TableSection.BeaconSection.sectionFooterText : nil
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return UITableView.footerHeight
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableView.headerHeight
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		switch indexPath.section {
		case TableSection.NameSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemNameCell, for: indexPath)
			let nameCell = cell as! NameTableViewCell
			self.nameCell = nameCell
			nameCell.nameField.delegate = self
			break
		case TableSection.ImageSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemImageCell, for: indexPath)
			break
		case TableSection.BeaconSection.sectionNumber:
			cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.PickBeaconCell, for: indexPath)
			break
		default:
			cell = UITableViewCell()
			break
		}
		return cell
	}
}
