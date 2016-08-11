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
	var selectedBeacon: ESTNearable?
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
			navigationItem.rightBarButtonItem?.enabled = !(sender.text?.isEmpty)!
    }
	
	@IBAction func beaconPicked(segue: UIStoryboardSegue){
		print(segue)
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
