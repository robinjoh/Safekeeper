import UIKit

class ItemOverviewController: UITableViewController, ItemTrackerDelegate {
    private var items = [String:Item]()
	private var locationManager = ItemTracker.getInstance()
	struct Storage {
		static let StorageDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
		static let ArchiveURL = StorageDirectory.URLByAppendingPathComponent("items")
	}
    
    @IBOutlet weak var addItemCell: UIView!
    
	private struct TableCellTag {
		static let ImageView = 1
		static let NameLabel = 2
		static let DistanceLabel = 3
	}
	
	//MARK: - Lifecycle methods
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
	}
	
	//UNWIND FROM ADDING A NEW ITEM
	@IBAction func saveButtonClicked(segue: UIStoryboardSegue) {
		if let vc = segue.sourceViewController as? AddItemViewController {
				let id = vc.selectedBeacon.identifier
				let name = vc.nameField.text
				let beacon = vc.selectedBeacon
				saveItem(Item(id: id, name: name!, nearable: beacon, image: vc.selectedImage, lastDetected: nil)!)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.tableView.editing = false
		self.editing = false
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
        loadItems()
		if items.isEmpty {
			self.navigationItem.leftBarButtonItem?.enabled = false
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		locationManager.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	private func loadItems(){
		items = NSKeyedUnarchiver.unarchiveObjectWithFile(Storage.ArchiveURL.path!) as! [String:Item]
		tableView.reloadData()
	}
	
	private func saveItems(){
		if NSKeyedArchiver.archiveRootObject(items, toFile: Storage.ArchiveURL.path!) {
			tableView.reloadData()
			navigationItem.leftBarButtonItem?.enabled = !items.isEmpty
		} else {
			//visa alert om att det inte gick att spara.
			presentViewController(UIAlertController(), animated: true, completion: nil)
		}
	}
	
	private func saveItem(item: Item){
		items[item.itemId] = item
		saveItems()
	}
	
	//MARK: - itemtracker methods
	func itemTracker(didRangeItem item: Item) {
		
	}
	
	func itemTracker(didLoseItem item: Item){

	}
	
    // MARK: - Table view methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.isEmpty ? 1 : items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if items.isEmpty{
			return tableView.dequeueReusableCellWithIdentifier("noItemsCell")!
		}
		let cell = configureItemCell(withIdentifier: "itemCell", forIndexPath: indexPath)
		return cell
    }
	
	private func configureItemCell(withIdentifier id: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath)
		let keys = [String](items.keys)
		let key = keys[indexPath.row]
		if let item = items[key]{
			let nameLbl = cell.viewWithTag(TableCellTag.NameLabel) as! UILabel
			let imageView = cell.viewWithTag(TableCellTag.ImageView) as! UIImageView
			let distanceLbl = cell.viewWithTag(TableCellTag.DistanceLabel) as! UILabel
			nameLbl.text = item.name
			distanceLbl.text = item.location.description
			if let img = item.image {
				imageView.image = img
			} else {
				imageView.image = UIImage(named: "Wallet Filled")
			}
			cell.accessibilityIdentifier = item.itemId
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Item Overview"
		
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return !items.isEmpty
	}

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let identifier = tableView.cellForRowAtIndexPath(indexPath)?.accessibilityIdentifier where editingStyle == .Delete {
			items.removeValueForKey(identifier)
			if !items.isEmpty{
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			} else {
				tableView.reloadData()
			}
			saveItems()
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? UITableViewCell where segue.identifier == Segue.ShowItemDetails.rawValue && cell.accessibilityIdentifier != nil {
			if let destination = segue.destinationViewController as? ItemDetailsViewController {
				destination.item = items[(cell.accessibilityIdentifier)!]
			}
		}
    }
}
