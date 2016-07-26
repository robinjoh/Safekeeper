//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, ItemTrackerDelegate, UITableViewDelegate {
	private var locationManager = ItemTracker.getInstance()
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerParentView: UIView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.titleView = nil
        // Do any additional setup after loading the view.
    }
	
	func didFindItem(item: String) {
		//stub
	}
	
	func didLoseItem(item: String) {
		//stub
	}
	
	func didRangeItems(items: [Item]) {
		
	}
	
	@IBAction func pickBeaconClicked(sender: AnyObject) {

	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
