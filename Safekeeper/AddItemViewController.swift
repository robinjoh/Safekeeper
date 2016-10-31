//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	fileprivate let SECTION_TITLE = "Item"
	fileprivate let ImageRow = 2
	fileprivate var _selectedBeacon: ESTNearable?
	var alreadyUsedIdentifiers = Set<String>()
	fileprivate(set) var selectedBeacon: ESTNearable! {
		get {
			return _selectedBeacon
		}
		set {
			_selectedBeacon = newValue
		}
	}
	fileprivate(set) var selectedImage: UIImage?
	fileprivate let imagePicker = UIImagePickerController()
	@IBOutlet weak var nameField: UITextField!
	
	struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}
	
	private func performSetup(){
		//tableView.setGradientBackground(toView: UIView(frame: tableView.bounds))
		nameField.attributedPlaceholder = NSAttributedString(string: "Item Name", attributes: [NSForegroundColorAttributeName: (nameField.textColor!)])
		tableView.tableHeaderView?.backgroundColor = UIColor.mainColor
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		imagePicker.navigationBar.tintColor = UIColor.mainTextColor
		imagePicker.navigationBar.barTintColor = UIColor.navbarColor
		let font = UIFont(name: "Chalkduster", size: 17)!
		let attributes = [NSForegroundColorAttributeName: UIColor.mainTextColor,NSFontAttributeName: font] as [String : Any]
		imagePicker.navigationBar.titleTextAttributes = attributes
		imagePicker.navigationBar.isTranslucent = false
		nameField.delegate = self
		imagePicker.delegate = self
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		performSetup()
		
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		if (nameField.text?.isEmpty)! {
			nameField.becomeFirstResponder()
		}

    }
	
	override func viewWillDisappear(_ animated: Bool) {
		nameField.resignFirstResponder()
	}
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem?.isEnabled = false
		return textField.text != nil
	}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return nameField.resignFirstResponder()
    }
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
			navigationItem.rightBarButtonItem?.isEnabled = allRequiredItemsSelected()
    }
	
	@IBAction func beaconPicked(_ segue: UIStoryboardSegue){
		let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0))
		if let ctrl = segue.source as? PickBeaconTableViewController , ctrl.selectedBeacon != nil {
			self._selectedBeacon = ctrl.selectedBeacon
			cell?.textLabel?.text = ctrl.selectedBeacon.identifier
			navigationItem.rightBarButtonItem?.isEnabled = allRequiredItemsSelected()
		}
	}
	
	fileprivate func allRequiredItemsSelected() -> Bool {
		return (self._selectedBeacon != nil && nameField.text != nil && !(nameField.text?.isEmpty)!)
	}
	
	//MARK: - Tableview
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).row == ImageRow {
			showImagePickerChoiceDialog()
		}
	}
	
	fileprivate func showImagePickerChoiceDialog() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		alertController.addAction(UIAlertAction(title: AlertTitle.Camera, style: UIAlertActionStyle.default, handler: {[weak self] (action) -> Void in self?.showImagePickerController(.camera)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Library, style: UIAlertActionStyle.default, handler: { [weak self] (action) -> Void in self?.showImagePickerController(.photoLibrary)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Cancel, style: UIAlertActionStyle.cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
		alertController.view.tintColor = UIColor.mainColor
	}
	
	fileprivate func showImagePickerController(_ choice: UIImagePickerControllerSourceType){
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
		let path = IndexPath(item:2, section: 0)
		let cell = tableView.cellForRow(at: path)!
		cell.imageView?.image = selectedImage
		cell.textLabel?.text = "Choose Item Image"
		cell.setNeedsLayout()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? PickBeaconTableViewController {
			dest.alreadyUsedIdentifiers = alreadyUsedIdentifiers
		}
	}
}
