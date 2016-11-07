//
//  AddItemViewControllerNew.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-27.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	fileprivate var _selectedBeacon: ESTNearable? {
		didSet {
			saveButton.isEnabled = allRequiredItemsSelected()
		}
	}
	private(set) var rangedNearables = [String:ESTNearable]()
	private var itemTracker = ItemTracker.getInstance()
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
			if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: UITableView.TableSection.ImageSection.sectionNumber)) as? AddItemImageTableViewCell {
				if selectedImage != nil {
					cell.chooseImageLbl.text = ""
				} else {
					cell.chooseImageLbl.text = cell.chooseImageText
				}
			}
			if allRequiredItemsSelected() {
				self.saveButton.isEnabled = true
			}
		}
	}
	private let imagePicker = UIImagePickerController()
	private(set) var itemName: String? {
		didSet {
			saveButton.isEnabled = allRequiredItemsSelected()
		}
	}
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
	private struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}
	
	
	private func performSetup(){
		tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
		tableView.backgroundView?.backgroundColor = UIColor.clear
		tableView.backgroundView?.setGradientBackground([UIColor.mainColor.cgColor, UIColor.mainTextColor.cgColor], locations: [0, 0.7, 1.0], startPoint: CGPoint(x: 0.5, y:0), endPoint: CGPoint(x: 1, y: 1), bounds: tableView.bounds)
		tableView.estimatedRowHeight = 210
		tableView.rowHeight = UITableViewAutomaticDimension
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		imagePicker.navigationBar.tintColor = UIColor.mainTextColor
		imagePicker.navigationBar.barTintColor = UIColor.navbarColor
		imagePicker.navigationBar.isTranslucent = false
		imagePicker.delegate = self
		itemTracker.delegate = self
		itemTracker.performOperation(ItemTracker.Operation.startRanging)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		performSetup()
    }

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func textFieldEdited(_ sender: UITextField) {
		itemName = sender.text
	}
	
	fileprivate func allRequiredItemsSelected() -> Bool {
		return (self._selectedBeacon != nil && itemName != nil && !(itemName!).isEmpty && selectedImage != nil)
	}
	
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		navigationItem.rightBarButtonItem?.isEnabled = false
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		itemName = textField.text
		return textField.resignFirstResponder()
	}
	
	func showImagePickerChoiceDialog() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		alertController.addAction(UIAlertAction(title: AlertTitle.Camera, style: UIAlertActionStyle.default, handler: {[weak self] (action) -> Void in self?.showImagePickerController(.camera)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Library, style: UIAlertActionStyle.default, handler: { [weak self] (action) -> Void in self?.showImagePickerController(.photoLibrary)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Cancel, style: UIAlertActionStyle.cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
		alertController.view.tintColor = UIColor.navbarColor
	}
	
	private func showImagePickerController(_ choice: UIImagePickerControllerSourceType){
		if choice == .camera && UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	func refreshModel(_ nearables: [ESTNearable]) -> (Bool, [IndexPath]) {
		var shouldRefreshTable = false
		for nearable in nearables {
			if let value = rangedNearables.updateValue(nearable, forKey: nearable.identifier) {
				if !value.isEqual(nearable) {
					shouldRefreshTable = true
				}
			} else {
				shouldRefreshTable = true
			}
		}
		let newNearableIds = Set(nearables.map({nearable in return nearable.identifier}))
		let oldIds = Set(rangedNearables.keys)
		var indexPathsForDeletedCells = [IndexPath]()
		if let lostNearableIds = hasLostNearables(oldIds, newIds: newNearableIds) {
			indexPathsForDeletedCells = removeLostNearables(lostNearableIds)
		}
		return (shouldRefreshTable, indexPathsForDeletedCells)
	}
	fileprivate func hasLostNearables(_ oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtracting(newIds)
		return remove.isEmpty ? nil : remove
	}
	
	@objc fileprivate func removeLostNearables(_ removeIds: Set<String>) -> [IndexPath] {
		var removeTableCells = [IndexPath]();
		for id in removeIds {
			if let path = tableView.indexPath(forBeaconId: id)
				, tableView.cellForRow(at: path as IndexPath) != nil {
				rangedNearables.removeValue(forKey: id)
				removeTableCells.append(path)
			}
		}
		return removeTableCells
	}
	
	private func nearableForIndexPath(path: IndexPath) -> ESTNearable? {
		if let id = tableView.cellForRow(at: path)?.accessibilityIdentifier {
			return rangedNearables[id]
		}
		return nil
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		selectedImage = image
		dismiss(animated: true, completion: nil)
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))! as!AddItemImageTableViewCell
		cell.roundedImageView.image = image
	}
	
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if indexPath.section == UITableView.TableSection.ImageSection.sectionNumber {
			showImagePickerChoiceDialog()
		}
		return indexPath
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == UITableView.TableSection.BeaconSection.sectionNumber {
			let cell = tableView.cellForRow(at: indexPath) as! PickBeaconTableViewCell
			let nearable = rangedNearables[(cell.idLabel.text)!]!
			if let beacon = _selectedBeacon {
				if let idxPath = tableView.indexPath(forBeaconId: beacon.identifier){
					let cell = tableView.cellForRow(at:idxPath)
					cell?.accessoryType = UITableViewCellAccessoryType.none
				}
			}
			_selectedBeacon = nearable
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let beacon = _selectedBeacon, beacon.identifier == cell.accessibilityIdentifier {
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
		} else {
			cell.accessoryType = UITableViewCellAccessoryType.none
		}
	}
}

