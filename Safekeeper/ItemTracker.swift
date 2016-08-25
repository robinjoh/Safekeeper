import Foundation

public class ItemTracker {
	static private var sharedInstance: ItemTracker!
	weak var delegate: ItemTrackerDelegate?
	private var trackerDelegate: ItemDelegate!
	private let locationManager = ESTNearableManager()
	private (set) var trackedItems = [String:Item]()
	private weak var timer: NSTimer!
	private var isMonitoring = false
	private var isRanging = false
	private var isMonitoringPaused = false
	
	enum Activity {
		case Monitoring
		case Ranging
	}
	
	private init() {
		trackerDelegate = ItemDelegate()
		trackerDelegate.master = self
		locationManager.delegate = trackerDelegate
	}
	
	static func getInstance() -> ItemTracker {
		if let instance = sharedInstance {
			return instance
		} else {
			sharedInstance = ItemTracker()
			return sharedInstance!
		}
	}
	
	private func startTimer(){
		timer = NSTimer.scheduledTimerWithTimeInterval(NSTimer.NEARABLE_RANGING_LIMIT, target: self, selector: #selector(ItemTracker.findLostItems), userInfo: nil, repeats: true)
	}
	
	func trackItem(item: Item){
		locationManager.startRangingForIdentifier(item.itemId)
		trackedItems[item.itemId] = item
		if !isMonitoring {
			isMonitoring = true
		}
	}
	
	func stopTrackingItem(withId id: String) {
	if let index = trackedItems.indexForKey(id) {
			trackedItems.removeAtIndex(index)
		}
		if isMonitoring && trackedItems.isEmpty {
			startTimer()
			isMonitoring = false
		}
	}
	
	func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		trackedItems.removeAll()
		timer?.invalidate()
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
		startTimer()
		isRanging = true
	}
	
	func stopRangingNearbyItems() {
		locationManager.stopRanging()
		timer?.invalidate()
		isRanging = false
	}
	
	func pause(activity: Activity){
		switch activity {
		case .Ranging:
			if isRanging {
				locationManager.stopRanging()
				timer?.invalidate()
				isRanging = false
			}
		case .Monitoring:
			if isMonitoring {
				locationManager.stopMonitoring()
				timer?.invalidate()
				isMonitoringPaused = true
				isMonitoring = false
			}
		}
	}
	
	func resume(activity: Activity){
		switch activity {
		case .Monitoring:
			if isMonitoringPaused {
			for (id, _) in trackedItems {
				locationManager.startMonitoringForIdentifier(id)
			}
			isMonitoringPaused = false
			isMonitoring = true
			startTimer()
			}
		case .Ranging:
			locationManager.startRangingForType(ESTNearableType.All)
		}
	}
	
	//MARK: TrackerDelegate
	private class ItemDelegate: NSObject, ESTNearableManagerDelegate {
		weak var master: ItemTracker!
		
		@objc func nearableManager(manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
			if let item = master.trackedItems[nearable.identifier] {
				item.location = Item.Location(nearable.zone(), withDescription: nil)
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