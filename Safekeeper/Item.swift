//
//  Item.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation
import UIKit

public class Item: NSObject, NSCoding {
	public static let StorageCatalogName = "items"
	
	struct CodingKeys {
		static let idKey = "id"
		static let nameKey = "name"
		static let locationKey = "location"
		static let lastDetectedKey = "lastDetected"
		static let nearableKey = "nearable"
		static let imageKey = "image"
	}
	
    fileprivate(set) var name: String
    fileprivate(set) var itemId: String
	fileprivate var _location: Location
	fileprivate var _lastDetected: Date
	fileprivate var _nearable: ESTNearable!
	fileprivate(set) var image: UIImage?
	var location: Location {
		get {
			return _location
		}
		set {
			_location = newValue
			switch _location {
			case .far(_): _lastDetected = Date()
			case .immediate(_): _lastDetected = Date()
			case .near(_): lastDetected = Date()
			case .unknown(_): return
			}
		}
	}
	var lastDetected: Date {
		get {
			return _lastDetected
		}
		set {
			if (newValue as NSDate).laterDate(_lastDetected) == newValue {
				_lastDetected = newValue
			}
		}
	}
	var nearable: ESTNearable! {
		get {
			return _nearable
		}
		set {
			if newValue.identifier.characters.count == 16 && newValue.zone().rawValue >= 0 || newValue.zone().rawValue <= 3 {
				self.nearable = newValue
			}
		}
	}
    
	init?(id: String, name: String, nearable: ESTNearable?, image: UIImage?, lastDetected: Date?){
		guard id.characters.count == 16 && !name.isEmpty else {
			return nil
		}
		self._location = Location()
        self.name = name
		self._nearable = nearable
		self.itemId = id
		self._lastDetected = lastDetected ?? Date()
		self.image = image
    }
	
	required convenience public init?(coder decoder: NSCoder){
		guard let id = decoder.decodeObject(forKey: CodingKeys.idKey) as? String, let name = decoder.decodeObject(forKey: CodingKeys.nameKey) as? String, let nearable = decoder.decodeObject(forKey: CodingKeys.nearableKey) as? ESTNearable, let lastDetected = decoder.decodeObject(forKey: CodingKeys.lastDetectedKey) as? Date else {
			return nil
		}
		let image = decoder.decodeObject(forKey: CodingKeys.imageKey) as? UIImage
		self.init(id: id, name: name, nearable: nearable, image: image, lastDetected: lastDetected)
	}
	
	open func encode(with coder: NSCoder) {
		coder.encode(self.name, forKey: CodingKeys.nameKey)
		coder.encode(self.itemId, forKey: CodingKeys.idKey)
		coder.encode(self.lastDetected, forKey: CodingKeys.lastDetectedKey)
		coder.encode(self._nearable, forKey: CodingKeys.nearableKey)
		coder.encode(self.image, forKey: CodingKeys.imageKey)
	}
	
	override open func isEqual(_ object: Any?) -> Bool {
		if let other = object as? Item {
			return other.itemId == self.itemId && other.name == self.name
		}
		return false
	}
	
	
	//MARK: Location enum declaration
	enum Location {
		case immediate(description: String)
		case near(description: String)
		case far(description: String)
		case unknown(description: String)
		
		var description: String {
			switch self {
			case let .immediate(description):return description
			case let .near(description):return description
			case let .unknown(description):return description
			case let .far(description): return description
			}
		}
		
		init(){
			self = .unknown(description: "Location unknown")
		}
		
		init(_ zone: ESTNearableZone, withDescription descr: String?) {
			switch zone.rawValue {
			case 0: self = .unknown(description: descr ?? "Location unknown")
			case 1: self = .immediate(description: descr ?? "Immediate")
			case 2: self = .near(description: descr ?? "Near")
			case 3: self = .far(description: descr ?? "Far away")
			default: self = .unknown(description: descr ?? "Unknown")
			}
		}
	}
	
	
}
