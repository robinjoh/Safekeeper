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
		static let StorageDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
		static let ArchiveURL = StorageDirectory.appendingPathComponent("items")
	}
    
	private struct TableCellTag {
		static let ImageView = 1
		static let NameLabel = 2
		static let DistanceLabel = 3
	}
	
	//MARK: - Lifecycle methods
    @IBAction func unwindFromSegue(_ segue: UIStoryboardSegue) {}
	
	//UNWIND FROM ADDING A NEW ITEM
	@IBAction func saveButtonClicked(_ segue: UIStoryboardSegue) {
		if let vc = segue.source as? AddItemViewController {
				let id = vc.selectedBeacon.identifier
				let name = vc.nameField.text
				let beacon = vc.selectedBeacon
			if saveItem(Item(id: id, name: name!, nearable: beacon, image: vc.selectedImage, lastDetected: nil)!) {
				tableView.reloadData()
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tableView.isEditing = false
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		performSetup()
		self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
	}
	
	private func performSetup(){
		do {
			try loadItems()
			itemTracker.performOperation(ItemTracker.Operation.ranging(numberOfTimes: ItemTracker.Operation.Infinity))
		} catch FileSystemError.filePathNotFound(msg: let msg, path: let path) {
			print("\(msg): \(path)")
		} catch let error {
			print("An unknown error occurred: \(error)")
		}
		if items.isEmpty {
			self.navigationItem.leftBarButtonItem?.isEnabled = false
		} else {
			itemTracker.delegate = self
			itemTracker.performOperation(ItemTracker.Operation.monitoring(Array(items.values)))
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if itemTracker.isRanging {
			itemTracker.performOperation(ItemTracker.Operation.stopRanging)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("Overview fick minnesvarning")
	}
	
	fileprivate func loadItems() throws {
		guard (Storage.ArchiveURL as NSURL).checkResourceIsReachableAndReturnError(nil) else {
			throw FileSystemError.filePathNotFound(msg: "Could not load items from path", path: Storage.ArchiveURL.path)
		}
		items = NSKeyedUnarchiver.unarchiveObject(withFile: Storage.ArchiveURL.path) as! [String:Item]
	}
	
	fileprivate func saveItems() -> Bool {
		guard NSKeyedArchiver.archiveRootObject(items, toFile: Storage.ArchiveURL.path) else {
			//visa en alert om att det inte gick att spara.
			return false
		}
		return true
	}
	
	fileprivate func saveItem(_ item: Item) -> Bool {
		if items.index(forKey: item.itemId) == nil {
			itemTracker.performOperation(ItemTracker.Operation.monitoring([item]))
		}
		items[item.itemId] = item
		return saveItems()
	}
	
	//MARK: - itemtracker methods
	func itemTracker(didRangeItem item: Item) {
		print("hehe \(item)")
	}
	
	func itemTracker(didLoseItem item: Item){
		print("förlorade \(item)")
	}
	
    // MARK: - Table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.isEmpty ? 1 : items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if items.isEmpty{
			tableView.isScrollEnabled = false
			let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.ReuseIdentifier.NoItemsCell)!
			return cell
		} else{
			tableView.isScrollEnabled = true
		}
		let cell = configureItemCell(withIdentifier: UITableViewCell.ReuseIdentifier.ItemCell, forIndexPath: indexPath)
		return cell
    }
	
	private func configureItemCell(withIdentifier id: String, forIndexPath indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
		let keys = [String](items.keys)
		let key = keys[(indexPath as NSIndexPath).row]
		if let item = items[key]{
			let nameLbl = cell.viewWithTag(TableCellTag.NameLabel) as! UILabel
			let imageView = cell.viewWithTag(TableCellTag.ImageView) as! RoundedImageView
			let distanceLbl = cell.viewWithTag(TableCellTag.DistanceLabel) as! UILabel
			nameLbl.text = item.name
			nameLbl.textAlignment = NSTextAlignment.center
			distanceLbl.text = item.location.description
			if let img = item.image {
				imageView.image = img
			} else {
				imageView.image = UIImage(named: UIImage.Name.Radar)
			}
			cell.accessibilityIdentifier = item.itemId
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.clear
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return items.isEmpty ? tableView.bounds.height / 2 : tableView.rowHeight
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return items.isEmpty ? nil : "My Tracked Items"
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return !items.isEmpty||tableView.cellForRow(at: indexPath)?.reuseIdentifier != UITableViewCell.ReuseIdentifier.NoItemsCell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if let identifier = tableView.cellForRow(at: indexPath)?.accessibilityIdentifier , editingStyle == .delete {
			if let item = items.removeValue(forKey: identifier) {
				if !items.isEmpty{
					tableView.deleteRows(at: [indexPath], with: .fade)
				} else {
					tableView.isEditing = false
				}
				itemTracker.performOperation(ItemTracker.Operation.stopMonitoring([item]))
				saveItems()
			}
		}
	}

	//MARK: - Animation
	
	private func startAnimatingRadar(_ radar: UIImageView){
		var animation: CABasicAnimation
		animation = CABasicAnimation(keyPath: "transform.rotation")
		animation.fromValue = CGFloat(M_PI)
		animation.byValue = CGFloat((360*M_PI) / 180)
		animation.repeatCount = 10000000
		animation.duration = 5.0
		radar.layer.add(animation, forKey: "transform.rotation")
	}
	
	
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell , segue.identifier == Segue.ShowItemDetails.rawValue && cell.accessibilityIdentifier != nil {
			if let destination = segue.destination as? ItemDetailsViewController {
				destination.item = items[(cell.accessibilityIdentifier)!]
			}
		}
    }
}
