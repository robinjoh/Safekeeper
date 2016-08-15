import Foundation

public class ItemTracker {
	static private var sharedInstance: ItemTracker!
	weak var delegate: ItemTrackerDelegate?
	private var trackerDelegate: ItemDelegate!
	private let locationManager = ESTNearableManager()
	private (set) var trackedItems = [String:Item]()
	private var trackEverything = false
	private var timer: NSTimer!
	
	private init() {
		trackerDelegate = ItemDelegate()
		trackerDelegate.master = self
		locationManager.delegate = trackerDelegate
		timer = NSTimer.scheduledTimerWithTimeInterval(NSTimer.NEARABLE_RANGING_LIMIT, target: self, selector: #selector(ItemTracker.findLostItems), userInfo: nil, repeats: true)
	}
	
	static func getInstance() -> ItemTracker {
		if let instance = sharedInstance {
			return instance
		} else {
			sharedInstance = ItemTracker()
			return sharedInstance!
		}
	}
	
	func trackItem(item: Item){
		locationManager.startRangingForIdentifier(item.itemId)
		trackedItems[item.itemId] = item
	}
	
	func stopTrackingItem(item: Item) {
	if let index = trackedItems.indexForKey(item.itemId) {
			trackedItems.removeAtIndex(index)
		}
	}
	
	func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		trackedItems.removeAll()
		timer.invalidate()
	}
	
	@objc private func findLostItems(){
		let now = NSDate()
		for (_, item) in trackedItems {
			if now.timeIntervalSinceDate(item.lastDetected) > NSTimer.NEARABLE_RANGING_LIMIT {
				self.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}
	
	func startRangingNearbyItems() {
		locationManager.startRangingForType(ESTNearableType.All)
	}
	
	func stopRangingNearbyItems() {
		locationManager.stopRangingForType(ESTNearableType.All)
		if trackedItems.count > 0 {
			for (id, _) in trackedItems {
				locationManager.stopRangingForIdentifier(id)
			}
		}
	}
	
	//MARK: TrackerDelegate
	private class ItemDelegate: NSObject, ESTNearableManagerDelegate {
		weak var master: ItemTracker!
		
		@objc func nearableManager(manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
			if let item = master.trackedItems[nearable.identifier] {
				item.location = Item.Location(nearable.zone())
				master.trackedItems[item.itemId] = item
				master.delegate?.itemTracker?(didRangeItem: item)
			}
		}
		
		@objc func nearableManager(manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], withType type: ESTNearableType) {
			master.delegate?.itemTracker?(rangedNearables: nearables)
		}
		
		@objc func nearableManager(manager: ESTNearableManager, didEnterIdentifierRegion identifier: String) {
			
		}
	}

}