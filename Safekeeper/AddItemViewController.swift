//
//  AddItemViewControllerNew.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-27.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
	@IBOutlet weak var tableView: UITableView!
	
	private struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}
	
	
	private func performSetup(){
		self.view.setGradientBackground([UIColor.mainTextColor.cgColor, UIColor.mainColor.cgColor, UIColor.mainColor.cgColor, UIColor.mainTextColor.cgColor], locations: [0,1], startPoint: CGPoint(x: 0.7, y:0), endPoint: CGPoint(x: 0.9, y: 1), bounds: view.bounds)
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
		tableView.delegate = self
		tableView.dataSource = self
		if !itemTracker.isRanging{
			itemTracker.performOperation(ItemTracker.Operation.startRanging)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//NotificationCenter.default.addObserver(self, selector: #selector(appeared), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
		performSetup()
    }
	
//	@objc func appeared() {
//		print("appeared")
//	}
	
	override func viewDidAppear(_ animated: Bool) {
		itemTracker.delegate = self
		if !itemTracker.isRanging {
			itemTracker.performOperation(ItemTracker.Operation.startRanging)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func resetTrackedNearables(){
		rangedNearables.removeAll()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let txt = textField.text as NSString?
		var test = txt?.replacingCharacters(in: range, with: string)
		if test != nil && (test?.characters.count)! > 0 && allRequiredItemsSelected(){
			navigationItem.rightBarButtonItem?.isEnabled = true
		}else {
			navigationItem.rightBarButtonItem?.isEnabled = false
		}
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		navigationItem.rightBarButtonItem?.isEnabled = false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		itemName = textField.text
		if allRequiredItemsSelected() {
			navigationItem.rightBarButtonItem?.isEnabled = true
		}
	}
    
	@IBAction func textFieldEdited(_ sender: UITextField) {
		itemName = sender.text
		if allRequiredItemsSelected(){
		navigationItem.rightBarButtonItem?.isEnabled = true
		}
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
	
	@IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
		showImagePickerChoiceDialog()
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
	
	func refreshModel(_ nearables: [ESTNearable]) -> Bool {
		var shouldRefreshTable = false
		for nearable in nearables {
			if let value = rangedNearables.updateValue(nearable, forKey: nearable.identifier), value.isEqual(nearable) {
				if !value.isEqual(nearable) {
					shouldRefreshTable = true
				}
			} else {
				shouldRefreshTable = true
			}
		}
		let newNearableIds = Set(nearables.map({nearable in return nearable.identifier}))
		let oldIds = Set(rangedNearables.keys)
		if let lostNearableIds = hasLostNearables(oldIds, newIds: newNearableIds) {
			shouldRefreshTable = shouldRefreshTable||removeLostNearables(lostNearableIds)
		}
		return shouldRefreshTable
	}
	
	fileprivate func hasLostNearables(_ oldIds: Set<String>, newIds: Set<String>) -> Set<String>? {
		let remove = oldIds.subtracting(newIds)
		return remove.isEmpty ? nil : remove
	}
	
	@objc fileprivate func removeLostNearables(_ removeIds: Set<String>) -> Bool {
		let removed = !removeIds.isDisjoint(with: Set(rangedNearables.keys))
		for id in removeIds {
			rangedNearables.removeValue(forKey: id)
		}
		return removed
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		selectedImage = image
		dismiss(animated: true, completion: nil)
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))! as!AddItemImageTableViewCell
		cell.roundedImageView.image = image
	}
	
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if indexPath.section == UITableView.TableSection.ImageSection.sectionNumber {
			//showImagePickerChoiceDialog()
		}
		return indexPath
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let beacon = _selectedBeacon, beacon.identifier == cell.accessibilityIdentifier {
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
		} else {
			cell.accessoryType = UITableViewCellAccessoryType.none
		}
	}
}

