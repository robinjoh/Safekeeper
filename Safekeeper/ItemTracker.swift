import Foundation

open class ItemTracker {
	static fileprivate var sharedInstance: ItemTracker!
	weak var delegate: ItemTrackerDelegate? {
		didSet {
			locationManager.stopRanging()
			locationManager.stopMonitoring()
		}
	}
	fileprivate var trackerDelegate: ItemDelegate!
	fileprivate let locationManager = ESTNearableManager()
	fileprivate (set) var trackedItems = [String:Item]()
	fileprivate weak var timer: Timer?
	fileprivate var isMonitoring = false
	fileprivate (set) var isRanging = false
	fileprivate var isMonitoringPaused = false
	fileprivate var performNumberOfRanges = Operation.Infinity
	fileprivate var rangingCount = 0
	
	enum Operation {
		case monitoring([Item])
		case stopMonitoring([Item])
		case ranging(numberOfTimes: Int)
		case stopRanging
		case resumeRanging
		case resumeMonitoring
		case pauseMonitoring
		case pauseRanging
		static var Infinity: Int {
			return 0
		}
	}
	
	fileprivate init() {
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
	
	fileprivate func startTimer(){
		timer = Timer.scheduledTimer(timeInterval: Timer.NEARABLE_RANGING_LIMIT, target: self, selector: #selector(ItemTracker.findLostItems), userInfo: nil, repeats: true)
	}
	
	fileprivate func stopTimer(){
		if timer != nil {
			timer?.invalidate()
		}
	}
	
	fileprivate func trackItem(_ item: Item){
		locationManager.startMonitoring(forIdentifier: item.itemId)
		trackedItems[item.itemId] = item
		if !isMonitoring {
			isMonitoring = true
			startTimer()
		}
	}
	
	func trackItems(_ items: [Item]){
		for item in items {
			trackItem(item)
		}
	}
	
	fileprivate func stopTrackingItem(withId id: String) {
	if let index = trackedItems.index(forKey: id) {
			trackedItems.remove(at: index)
		}
		if isMonitoring && trackedItems.isEmpty {
			stopTimer()
			isMonitoring = false
		}
	}
	
	fileprivate func stopTrackingItems(_ items: [Item]){
		for item in items {
			stopTrackingItem(withId: item.itemId)
		}
	}
	
	fileprivate func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		trackedItems.removeAll()
		timer?.invalidate()
	}
	
	func performOperation(_ operation: Operation){
		switch operation {
		case .monitoring(let items):
			items.count > 1 ? trackItems(items) : trackItem(items[0])
		case .stopMonitoring(let items):
			items.count > 1 ? stopTrackingItems(items) : stopTrackingItem(withId: items[0].itemId)
		case .ranging(let nrOfTimes):
			startRangingNearbyItems()
			performNumberOfRanges = nrOfTimes
		case .stopRanging: stopRangingNearbyItems()
		case .resumeRanging: startRangingNearbyItems()
		case .resumeMonitoring:
			if isMonitoringPaused {
				for (id, _) in trackedItems {
					locationManager.startMonitoring(forIdentifier: id)
				}
				isMonitoringPaused = false
				isMonitoring = true
				startTimer()
			}
		case .pauseRanging:
			if isRanging {
				locationManager.stopRanging()
				timer?.invalidate()
				isRanging = false
			}
		case .pauseMonitoring:
			if isMonitoring {
				locationManager.stopMonitoring()
				timer?.invalidate()
				isMonitoringPaused = true
				isMonitoring = false
			}
		}
	}
	
	@objc fileprivate func findLostItems(){
		let now = Date()
		for (_, item) in trackedItems {
			if now.timeIntervalSince(item.lastDetected as Date) > Timer.NEARABLE_RANGING_LIMIT {
				self.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}
	
	fileprivate func startRangingNearbyItems() {
		locationManager.startRanging(for: ESTNearableType.all)
		startTimer()
		isRanging = true
	}
	
	fileprivate func stopRangingNearbyItems() {
		locationManager.stopRanging()
		timer?.invalidate()
		isRanging = false
	}
	
	//MARK: TrackerDelegate
	fileprivate class ItemDelegate: NSObject, ESTNearableManagerDelegate {
		weak var master: ItemTracker!
		
		@objc func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
			if let item = master.trackedItems[nearable.identifier] {
				item.location = Item.Location(nearable.zone(), withDescription: nil)
				master.trackedItems[item.itemId] = item
				master.delegate?.itemTracker?(didRangeItem: item)
			}
		}
		
		@objc func nearableManager(_ manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], with type: ESTNearableType) {
			master.delegate?.itemTracker?(rangedNearables: nearables)
			if master.performNumberOfRanges != Operation.Infinity && master.rangingCount == master.performNumberOfRanges {
				master.stopRangingNearbyItems()
			} else {
				master.rangingCount += 1
			}
		}
		
		@objc func nearableManager(_ manager: ESTNearableManager, didEnterIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
					master.delegate?.itemTracker?(didRangeItem: item)
				}
		}
		
		@objc func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
				master.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}

}
