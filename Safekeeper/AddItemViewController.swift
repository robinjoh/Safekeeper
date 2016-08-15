//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
	private let SECTION_TITLE = "Item"
	private var selectedBeacon: ESTNearable?
	var selectedImage: UIImage?
	@IBOutlet weak var nameField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.attributedPlaceholder = NSAttributedString(string: "ITEM NAME", attributes: [NSForegroundColorAttributeName: (nameField.textColor!)])
		tableView.tableHeaderView?.backgroundColor = UIColor.NavbarColor()
        nameField.delegate = self
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
			self.selectedBeacon = ctrl.selectedBeacon
			cell?.textLabel?.text = ctrl.selectedBeacon.identifier
			navigationItem.rightBarButtonItem?.enabled = allRequiredItemsSelected()
		}
	}
	
	private func allRequiredItemsSelected() -> Bool {
		return (self.selectedBeacon != nil && nameField.text != nil && !(nameField.text?.isEmpty)!)
	}
	
	//MARK: - Tableview
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
