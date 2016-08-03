import Foundation

public class ItemTracker {
	static private var sharedInstance: ItemTracker?
	weak var delegate: ItemTrackerDelegate?
	private var trackerDelegate: ItemDelegate
	private let locationManager = ESTNearableManager()
	private (set) var itemsToTrack = [String]()
	static let NEARABLE_IDS = ["d27d8fc32418bb0c", "52908a26922d1b78", "9dd690633ac0e7f1", "cab715dbde99595b", "bcb42e39477d6c57", "30597ff274159387", "0aacb7671fd6dd88", "051f31577dca8d38", "a09e524a0618b78f", "47eb93db077a7890"]
	
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
	
	func trackItem(withIdentifier id: String){
		locationManager.startRangingForIdentifier(id)
		itemsToTrack.append(id)
	}
	
	func stopTrackingItem(withIdentifier id: String) {
		if let index = itemsToTrack.indexOf(id) {
			itemsToTrack.removeAtIndex(index)
		}
		locationManager.stopMonitoringForIdentifier(id)
	}
	
	func stopAllTracking(){
		locationManager.stopMonitoring()
		locationManager.stopRanging()
		itemsToTrack.removeAll()
	}
	
	func startRangingNearbyItems() {
		for id in ItemTracker.NEARABLE_IDS {
			guard !itemsToTrack.contains(id) else {
				return
			}
			locationManager.startRangingForIdentifier(id)
			itemsToTrack.append(id)
		}
	}
	
	//MARK: TrackerDelegate
	private class ItemDelegate: NSObject, ESTNearableManagerDelegate {
		var master: ItemTracker?
		
		@objc func nearableManager(manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {

		}
		
		@objc func nearableManager(manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {

		}
		
		@objc func nearableManager(manager: ESTNearableManager, didEnterIdentifierRegion identifier: String) {

		}
		
		@objc func nearableManager(manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], withType type: ESTNearableType) {
			
		}
	}
}