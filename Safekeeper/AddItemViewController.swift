//
//  AddItemViewControllerNew.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-27.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UINavigationControllerDelegate {
	private var _selectedBeacon: ESTNearable?
	var alreadyUsedIdentifiers = Set<String>()
	private(set) var selectedBeacon: ESTNearable! {
		get {
			return _selectedBeacon
		}
		set {
			_selectedBeacon = newValue
		}
	}
	private(set) var selectedImage: UIImage?
	private let imagePicker = UIImagePickerController()
	
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pickBeaconTableView: UITableView!

	private struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}

	private func performSetup(){
		//tableView.setGradientBackground(toView: UIView(frame: tableView.bounds))
		pickBeaconTableView.tableHeaderView?.backgroundColor = UIColor.mainColor
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			imagePicker.sourceType = .camera
		} else {
			imagePicker.sourceType = .photoLibrary
		}
		imagePicker.navigationBar.tintColor = UIColor.mainTextColor
		imagePicker.navigationBar.barTintColor = UIColor.navbarColor
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
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func textFieldEdited(_ sender: UITextField) {
		navigationItem.rightBarButtonItem?.isEnabled = allRequiredItemsSelected()
	}
	
	fileprivate func allRequiredItemsSelected() -> Bool {
		return (self._selectedBeacon != nil && nameField.text != nil && !(nameField.text?.isEmpty)!)
	}
	
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		navigationItem.rightBarButtonItem?.isEnabled = false
		return nameField.text != nil
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return nameField.resignFirstResponder()
	}
	
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//INTE IMPLEMENTERAD
        return UITableViewCell()
    }
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//INTE IMPLEMENTERAD
		return 0
	}
	
	fileprivate func showImagePickerChoiceDialog() {
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
		let path = IndexPath(item: 2, section: 0)
		let cell = pickBeaconTableView.cellForRow(at: path)!
		cell.imageView?.image = selectedImage
		cell.textLabel?.text = "Choose Item Image"
	}
	
//	@IBAction func beaconPicked(_ segue: UIStoryboardSegue){
//		let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0))
//		if let ctrl = segue.source as? PickBeaconTableViewController , ctrl.selectedBeacon != nil {
//			self._selectedBeacon = ctrl.selectedBeacon
//			cell?.textLabel?.text = ctrl.selectedBeacon.identifier
//			navigationItem.rightBarButtonItem?.isEnabled = allRequiredItemsSelected()
//		}
//	}

}
