import Foundation

public final class ItemTracker {
	static private var sharedInstance: ItemTracker!
	weak var delegate: ItemTrackerDelegate? {
		didSet {
			if delegate == nil {
			locationManager.stopRanging()
			locationManager.stopMonitoring()
			}
		}
	}
	private var trackerDelegate: ItemDelegate!
	private let locationManager = ESTNearableManager()
	private (set) var trackedItems = [String:Item]()
	private (set) var isMonitoring = false
	private (set) var isRanging = false
	private var isMonitoringPaused = false
	private var rangingCount = 0
	
	enum Operation {
		case startMonitoring([Item])
		case stopMonitoring([Item])
		case startRanging
		case stopRanging
		case resumeRanging
		case resumeMonitoring
		case pauseMonitoring
		case pauseRanging
		static var infinity: Int {
			return 0
		}
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
	
	private func trackItem(_ item: Item){
		locationManager.startMonitoring(forIdentifier: item.itemId)
		trackedItems[item.itemId] = item
		if !isMonitoring {
			isMonitoring = true
		}
	}
	
	func trackItems(_ items: [Item]){
		for item in items {
			trackItem(item)
		}
	}
	
	private func stopTrackingItem(withId id: String) {
	if let index = trackedItems.index(forKey: id) {
			trackedItems.remove(at: index)
		}
		if isMonitoring && trackedItems.isEmpty {
			isMonitoring = false
		}
	}
	
	private func stopTrackingItems(_ items: [Item]){
		for item in items {
			stopTrackingItem(withId: item.itemId)
		}
	}
	
	private func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		trackedItems.removeAll()
	}
	
	func performOperation(_ operation: Operation){
		switch operation {
		case .startMonitoring(let items):
			if !items.isEmpty{
				trackItems(items)
			}
		case .stopMonitoring(let items):
			if !items.isEmpty{
				stopTrackingItems(items)
			}
		case .startRanging: startRangingNearbyItems()
		case .stopRanging: stopRangingNearbyItems()
		case .resumeRanging: startRangingNearbyItems()
		case .resumeMonitoring:
			if isMonitoringPaused {
				for (id, _) in trackedItems {
					locationManager.startMonitoring(forIdentifier: id)
				}
				isMonitoringPaused = false
				isMonitoring = true
				//startTimer()
			}
		case .pauseRanging:
			if isRanging {
				locationManager.stopRanging()
				isRanging = false
			}
		case .pauseMonitoring:
			if isMonitoring {
				locationManager.stopMonitoring()
				isMonitoringPaused = true
				isMonitoring = false
			}
		}
	}
	
	private func startRangingNearbyItems() {
		locationManager.startRanging(for: ESTNearableType.all)
		isRanging = true
	}
	
	private func stopRangingNearbyItems() {
		locationManager.stopRanging()
		isRanging = false
	}

	
	//MARK: TrackerDelegate
	private class ItemDelegate: NSObject, ESTNearableManagerDelegate {
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
			if !master.trackedItems.isEmpty {
				var items = [Item]()
				for nearable in nearables {
					if master.trackedItems.keys.contains(nearable.identifier){
						items.append(master.trackedItems[nearable.identifier]!)
					}
				}
				master.delegate?.itemTracker?(rangedItems: items)
			}
		}
		
		@objc func nearableManager(_ manager: ESTNearableManager, didEnterIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
					master.delegate?.itemTracker?(didFindMonitoredItem: item)
				}
		}
		
		@objc func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
				master.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}

}
