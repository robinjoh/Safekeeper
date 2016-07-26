//
//  AddItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-03.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, ItemTrackerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	private var locationManager = ItemTracker.getInstance()
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerParentView: UIView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		locationManager.delegate = self
		navigationItem.titleView = nil
		picker.delegate = self
		picker.dataSource = self
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
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 5
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "Test"
	}
	
	func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
		let label = UILabel(frame: CGRect(x: 0,y: 0, width: 300,height: 37))
		label.text = "test"
		label.textAlignment = NSTextAlignment.Center
		label.backgroundColor = UIColor.clearColor()
		return label
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	@IBAction func pickBeaconClicked(sender: AnyObject) {
		pickerParentView.hidden = !pickerParentView.hidden
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
