import Foundation

public class ItemTracker {
	static private var sharedInstance: ItemTracker!
	weak var delegate: ItemTrackerDelegate?
	private var trackerDelegate: ItemDelegate!
	private let locationManager = ESTNearableManager()
	private (set) var trackedItems = [String:Item]()
	private weak var timer: NSTimer?
	private var isMonitoring = false
	private var isRanging = false
	private var isMonitoringPaused = false
	private var performNumberOfRanges = Operation.Infinity
	private var rangingCount = 0
	
	enum Operation {
		case Monitoring([Item])
		case StopMonitoring([Item])
		case Ranging(numberOfTimes: Int)
		case StopRanging
		case ResumeRanging
		case ResumeMonitoring
		case PauseMonitoring
		case PauseRanging
		static var Infinity: Int {
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
	
	private func startTimer(){
		timer = NSTimer.scheduledTimerWithTimeInterval(NSTimer.NEARABLE_RANGING_LIMIT, target: self, selector: #selector(ItemTracker.findLostItems), userInfo: nil, repeats: true)
	}
	
	private func stopTimer(){
		if timer != nil {
			timer?.invalidate()
		}
	}
	
	private func trackItem(item: Item){
		locationManager.startMonitoringForIdentifier(item.itemId)
		trackedItems[item.itemId] = item
		if !isMonitoring {
			isMonitoring = true
			startTimer()
		}
	}
	
	func trackItems(items: [Item]){
		for item in items {
			trackItem(item)
		}
	}
	
	private func stopTrackingItem(withId id: String) {
	if let index = trackedItems.indexForKey(id) {
			trackedItems.removeAtIndex(index)
		}
		if isMonitoring && trackedItems.isEmpty {
			stopTimer()
			isMonitoring = false
		}
	}
	
	private func stopTrackingItems(items: [Item]){
		for item in items {
			stopTrackingItem(withId: item.itemId)
		}
	}
	
	private func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		trackedItems.removeAll()
		timer?.invalidate()
	}
	
	func performOperation(operation: Operation){
		switch operation {
		case .Monitoring(let items):
			items.count > 1 ? trackItems(items) : trackItem(items[0])
		case .StopMonitoring(let items):
			items.count > 1 ? stopTrackingItems(items) : stopTrackingItem(withId: items[0].itemId)
		case .Ranging(let nrOfTimes):
			startRangingNearbyItems()
			performNumberOfRanges = nrOfTimes
		case .StopRanging: stopRangingNearbyItems()
		case .ResumeRanging: startRangingNearbyItems()
		case .ResumeMonitoring:
			if isMonitoringPaused {
				for (id, _) in trackedItems {
					locationManager.startMonitoringForIdentifier(id)
				}
				isMonitoringPaused = false
				isMonitoring = true
				startTimer()
			}
		case .PauseRanging:
			if isRanging {
				locationManager.stopRanging()
				timer?.invalidate()
				isRanging = false
			}
		case .PauseMonitoring:
			if isMonitoring {
				locationManager.stopMonitoring()
				timer?.invalidate()
				isMonitoringPaused = true
				isMonitoring = false
			}
		}
	}
	
	@objc private func findLostItems(){
		let now = NSDate()
		for (_, item) in trackedItems {
			if now.timeIntervalSinceDate(item.lastDetected) > NSTimer.NEARABLE_RANGING_LIMIT {
				self.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}
	
	private func startRangingNearbyItems() {
		locationManager.startRangingForType(ESTNearableType.All)
		startTimer()
		isRanging = true
	}
	
	private func stopRangingNearbyItems() {
		locationManager.stopRanging()
		timer?.invalidate()
		isRanging = false
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
			if master.performNumberOfRanges != Operation.Infinity && master.rangingCount == master.performNumberOfRanges {
				master.stopRangingNearbyItems()
			} else {
				master.rangingCount += 1
			}
		}
		
		@objc func nearableManager(manager: ESTNearableManager, didEnterIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
					master.delegate?.itemTracker?(didLoseItem: item)
				}
		}
		
		@objc func nearableManager(manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
				if let item = master.trackedItems[identifier] {
				master.delegate?.itemTracker?(didLoseItem: item)
			}
		}
	}

}