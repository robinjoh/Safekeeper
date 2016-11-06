import UIKit

class ItemOverviewController: UITableViewController {
	private var _itemStorage = ItemStorage()
	var itemStorage: ItemStorage! {
		get {
			return _itemStorage
		}
		set {
			_itemStorage = newValue
		}
	}
	private var itemTracker = ItemTracker.getInstance()
	
	//MARK: - Lifecycle methods
	
	@IBAction func unwindFromSegue(_ segue: UIStoryboardSegue){
		//cancel from adding an item.
	}
	
	//UNWIND FROM ADDING A NEW ITEM
	@IBAction func saveButtonClicked(_ segue: UIStoryboardSegue) {
		if let vc = segue.source as? AddItemViewController {
				let id = vc.selectedBeacon.identifier
				let name = vc.itemName!
				let beacon = vc.selectedBeacon
				let item = Item(id: id, name: name, nearable: beacon, image: vc.selectedImage, lastDetected: nil)!
			if itemStorage.saveItem(item) {
				tableView.reloadData()
				itemTracker.performOperation(ItemTracker.Operation.monitoring([item]))
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tableView.isEditing = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		itemTracker.delegate = self
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		performSetup()
	}
	
	private func performSetup(){
		itemTracker.performOperation(ItemTracker.Operation.startRanging)
		if itemStorage.isEmpty {
			self.navigationItem.leftBarButtonItem?.isEnabled = false
		} else {
			itemTracker.delegate = self
			itemTracker.performOperation(ItemTracker.Operation.monitoring(itemStorage.items))
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if itemTracker.isRanging {
			itemTracker.performOperation(ItemTracker.Operation.stopRanging)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    // MARK: - Table view methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemStorage.isEmpty ? 1 : itemStorage.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if itemStorage.isEmpty{
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
		let keys = [String](itemStorage.keys)
		let key = keys[(indexPath as NSIndexPath).row]
		if let item = itemStorage.getItem(key) {
			//let nameLbl = cell.viewWithTag(TableCellTag.NameLabel) as! UILabel
			//let imageView = cell.viewWithTag(TableCellTag.ImageView) as! RoundedImageView
			//let distanceLbl = cell.viewWithTag(TableCellTag.DistanceLabel) as! UILabel
//			nameLbl.text = item.name
//			nameLbl.textAlignment = NSTextAlignment.center
//			distanceLbl.text = item.location.description
//			if let img = item.image {
//				imageView.image = img
//			} else {
//				imageView.image = UIImage(named: UIImage.Name.Radar)
//			}
			cell.accessibilityIdentifier = item.itemId
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.clear
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return itemStorage.isEmpty ? tableView.bounds.height / 2 : tableView.rowHeight
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return itemStorage.isEmpty ? nil : "My Tracked Items"
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return !itemStorage.isEmpty||tableView.cellForRow(at: indexPath)?.reuseIdentifier != UITableViewCell.ReuseIdentifier.NoItemsCell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if let identifier = tableView.cellForRow(at: indexPath)?.accessibilityIdentifier , editingStyle == .delete {
			if let item = itemStorage.deleteItem(identifier) {
				if !itemStorage.isEmpty {
					tableView.deleteRows(at: [indexPath], with: .fade)
				} else {
					tableView.isEditing = false
				}
				itemTracker.performOperation(ItemTracker.Operation.stopMonitoring([item]))
			}
		}
	}
	
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell , segue.identifier == Segue.ShowItemDetails.rawValue && cell.accessibilityIdentifier != nil {
			if let destination = segue.destination as? ItemDetailsViewController {
				destination.item = itemStorage.getItem(cell.accessibilityIdentifier!)!
			}
		}
    }
}
