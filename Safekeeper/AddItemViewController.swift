//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	private let SECTION_TITLE = "Item"
	private let ImageRow = 2
	private var _selectedBeacon: ESTNearable?
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
	
	struct AlertTitle {
		static let Library =  "Choose from Camera Roll"
		static let Camera = "Take a picture"
		static let Cancel = "Cancel"
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.attributedPlaceholder = NSAttributedString(string: "Item Name", attributes: [NSForegroundColorAttributeName: (nameField.textColor!)])
		tableView.tableHeaderView?.backgroundColor = UIColor.NavbarColor()
		if UIImagePickerController.isSourceTypeAvailable(.Camera){
			imagePicker.sourceType = .Camera
		} else {
			imagePicker.sourceType = .PhotoLibrary
		}
		imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nameField.delegate = self
		imagePicker.delegate = self
		
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		if (nameField.text?.isEmpty)! {
			nameField.becomeFirstResponder()
		}

    }
	
	override func viewWillDisappear(animated: Bool) {
		nameField.resignFirstResponder()
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem?.enabled = false
		return textField.text != nil
	}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return nameField.resignFirstResponder()
    }
    
    @IBAction func textFieldEdited(sender: UITextField) {
			navigationItem.rightBarButtonItem?.enabled = allRequiredItemsSelected()
    }
	
	@IBAction func beaconPicked(segue: UIStoryboardSegue){
		let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))
		if let ctrl = segue.sourceViewController as? PickBeaconTableViewController where ctrl.selectedBeacon != nil {
			self._selectedBeacon = ctrl.selectedBeacon
			cell?.textLabel?.text = ctrl.selectedBeacon.identifier
			navigationItem.rightBarButtonItem?.enabled = allRequiredItemsSelected()
		}
	}
	
	private func allRequiredItemsSelected() -> Bool {
		return (self._selectedBeacon != nil && nameField.text != nil && !(nameField.text?.isEmpty)!)
	}
	
	//MARK: - Tableview
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == ImageRow {
			showImagePickerChoiceDialog()
		}
	}
	
	private func showImagePickerChoiceDialog() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
		alertController.addAction(UIAlertAction(title: AlertTitle.Camera, style: UIAlertActionStyle.Default, handler: {[weak self] (action) -> Void in self?.showImagePickerController(.Camera)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Library, style: UIAlertActionStyle.Default, handler: { [weak self] (action) -> Void in self?.showImagePickerController(.PhotoLibrary)}))
		alertController.addAction(UIAlertAction(title: AlertTitle.Cancel, style: UIAlertActionStyle.Cancel, handler: nil))
		presentViewController(alertController, animated: true, completion: nil)
		alertController.view.tintColor = UIColor.NavbarColor()
	}
	
	private func showImagePickerController(choice: UIImagePickerControllerSourceType){
		if choice == .Camera && UIImagePickerController.isSourceTypeAvailable(.Camera){
			imagePicker.sourceType = .Camera
		} else {
			imagePicker.sourceType = .PhotoLibrary
		}
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		selectedImage = image
		dismissViewControllerAnimated(true, completion: nil)
		let path = NSIndexPath(forItem:2, inSection: 0)
		let cell = tableView.cellForRowAtIndexPath(path)!
		cell.imageView?.image = selectedImage
		cell.textLabel?.text = "Choose Item Image"
		cell.setNeedsLayout()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
