import UIKit

class ItemOverviewController: UITableViewController, ItemTrackerDelegate {
	private var items = [String:Item]() {
		didSet {
			if oldValue.count < items.count || items.isEmpty {
				tableView.reloadData()
			}
		}
	}
	private var itemTracker = ItemTracker.getInstance()
	
	struct Storage {
		static let StorageDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
		static let ArchiveURL = StorageDirectory.URLByAppendingPathComponent("items")
	}
    
	private struct TableCellTag {
		static let ImageView = 1
		static let NameLabel = 2
		static let DistanceLabel = 3
	}
	
	//MARK: - Lifecycle methods
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {}
	
	//UNWIND FROM ADDING A NEW ITEM
	@IBAction func saveButtonClicked(segue: UIStoryboardSegue) {
		if let vc = segue.sourceViewController as? AddItemViewController {
				let id = vc.selectedBeacon.identifier
				let name = vc.nameField.text
				let beacon = vc.selectedBeacon
			if saveItem(Item(id: id, name: name!, nearable: beacon, image: vc.selectedImage, lastDetected: nil)!) {
				//tableView.reloadData()
			}
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.tableView.editing = false
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		do {
			try loadItems()
			itemTracker.performOperation(ItemTracker.Operation.Ranging(numberOfTimes: ItemTracker.Operation.Infinity))
		} catch FileSystemError.FilePathNotFound(msg: let msg, path: let path) {
			print("\(msg): \(path)")
		} catch let error {
			print("An unknown error occurred: \(error)")
		}
		if items.isEmpty {
			self.navigationItem.leftBarButtonItem?.enabled = false
		} else {
			itemTracker.delegate = self
			itemTracker.performOperation(ItemTracker.Operation.Monitoring(Array(items.values)))
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("Overview fick minnesvarning")
	}
	
	private func loadItems() throws {
		guard Storage.ArchiveURL.checkResourceIsReachableAndReturnError(nil) else {
			throw FileSystemError.FilePathNotFound(msg: "Could not load items from path", path: Storage.ArchiveURL.path!)
		}
		items = NSKeyedUnarchiver.unarchiveObjectWithFile(Storage.ArchiveURL.path!) as! [String:Item]
	}
	
	private func saveItems() -> Bool {
		guard NSKeyedArchiver.archiveRootObject(items, toFile: Storage.ArchiveURL.path!) else {
			//visa en alert om att det inte gick att spara.
			return false
		}
		return true
	}
	
	private func saveItem(item: Item) -> Bool {
		if items.indexForKey(item.itemId) == nil {
			itemTracker.performOperation(ItemTracker.Operation.Monitoring([item]))
		}
		items[item.itemId] = item
		return saveItems()
	}
	
	//MARK: - itemtracker methods
	func itemTracker(didRangeItem item: Item) {
		print(item)
	}
	
	func itemTracker(didLoseItem item: Item){
		print(item)
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
			return tableView.dequeueReusableCellWithIdentifier(UITableViewCell.ReuseIdentifier.NoItemsCell)!
		}
		let cell = configureItemCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemCell, forIndexPath: indexPath)
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
				imageView.image = UIImage(named: UIImage.Name.Wallet)
			}
			cell.accessibilityIdentifier = item.itemId
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return items.isEmpty ? tableView.bounds.height / 2 : tableView.rowHeight
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Item Overview"
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return !items.isEmpty||tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier != UITableViewCell.ReuseIdentifier.NoItemsCell
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if let identifier = tableView.cellForRowAtIndexPath(indexPath)?.accessibilityIdentifier where editingStyle == .Delete {
			if let item = items.removeValueForKey(identifier) {
				if !items.isEmpty{
					tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
				} else {
					tableView.editing = false
				}
				itemTracker.performOperation(ItemTracker.Operation.StopMonitoring([item]))
				saveItems()
			}
		}
	}

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? UITableViewCell where segue.identifier == Segue.ShowItemDetails.rawValue && cell.accessibilityIdentifier != nil {
			if let destination = segue.destinationViewController as? ItemDetailsViewController {
				destination.item = items[(cell.accessibilityIdentifier)!]
			}
		}
		if segue.identifier == Segue.AddItem.rawValue {
				let destination = segue.destinationViewController as! NavbarViewController
				destination.alreadyUsedIdentifiers = Set(items.keys)
		}
    }
}
