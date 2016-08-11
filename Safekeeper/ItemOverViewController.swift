import UIKit

class ItemOverviewController: UITableViewController, ItemTrackerDelegate {
    private var items = [String:Item]()
	private var indexForItems = [String:NSIndexPath]()
	private var itemsForIndex = [NSIndexPath:String]()
	private var locationManager = ItemTracker.getInstance()
    
    @IBOutlet weak var addItemCell: UIView!
    
	private struct TableCellTag {
		static let DistanceLabel = 3
	}
	
	//MARK: - Lifecycle methods
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
        loadSavedItems()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		locationManager.delegate = self
		locationManager.startRangingNearbyItems()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	private func loadSavedItems(){
		
	}
	
	private func saveItems(){
		for (_, item) in items {

		}
	}
	
	
	//MARK: - itemtracker methods
	func itemTracker(didRangeItem item: Item) {

	}
	
	func itemTracker(didLoseItem item: Item){

	}
	
	func itemTracker(rangedNearables nearables: [ESTNearable]) {}

    // MARK: - Table view methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 5 : items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
		//Inte implementerad helt.
        return cell
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Item Overview"
		
	}
	
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let identifier = tableView.cellForRowAtIndexPath(indexPath)?.accessibilityIdentifier where editingStyle == .Delete {
            // Delete the row from the data source
			items.removeValueForKey(identifier)
			saveItems()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? UITableViewCell where segue.identifier == Segue.ShowItemDetails.rawValue && cell.accessibilityIdentifier != nil {
			if let destination = segue.destinationViewController as? ItemDetailsViewController {
				destination.item = items[(cell.accessibilityIdentifier)!]
			}
		}
    }
}
