//
//  NearableTableViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class ItemOverviewController: UITableViewController, ItemTrackerDelegate {
    private var items = [String:Item]()
	private var indexForItems = [String:NSIndexPath]()
	let testId = "9dd690633ac0e7f1"
	private let locationManager = ItemTracker.getInstance()
	
	
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
        
    }
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		locationManager.stopAllTracking()
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		items[testId] = Item(id: testId, name: "Plånbok", nearable: ESTNearable())
		locationManager.delegate = self
		locationManager.trackItem(items[testId]!)
    }
	
	func didFindItem(item: String) {
		
	}
	
	func didLoseItem(item: String) {
		
	}
	
	func didRangeItems(items: [Item]) {
		print(items[0].name)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
		cell.textLabel!.text = items[testId]?.name
		indexForItems[testId] = indexPath
        return cell
    }
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
    }

}
