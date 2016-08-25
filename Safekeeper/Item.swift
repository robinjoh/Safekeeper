//
//  Item.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation
import UIKit

public func ==(left: Item, right: Item) -> Bool {
	return left.itemId == right.itemId && left.name == right.name
}


public class Item: NSObject, NSCoding {
	struct CodingKeys {
		static let idKey = "id"
		static let nameKey = "name"
		static let locationKey = "location"
		static let lastDetectedKey = "lastDetected"
		static let nearableKey = "nearable"
		static let imageKey = "image"
	}
	
    private(set) var name: String
    private(set) var itemId: String
	private var _location: Location
	private var _lastDetected: NSDate
	private var _nearable: ESTNearable!
	private(set) var image: UIImage?
	var location: Location {
		get {
			return _location
		}
		set {
			_location = newValue
			switch _location {
			case .Far(_): _lastDetected = NSDate()
			case .Immediate(_): _lastDetected = NSDate()
			case .Near(_): lastDetected = NSDate()
			case .Unknown(_): return
			}
		}
	}
	var lastDetected: NSDate {
		get {
			return _lastDetected
		}
		set {
			if newValue.laterDate(_lastDetected) == newValue {
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
    
	init?(id: String, name: String, nearable: ESTNearable?, image: UIImage?, lastDetected: NSDate?){
		guard id.characters.count == 16 && !name.isEmpty else {
			return nil
		}
		self._location = Location()
        self.name = name
		self._nearable = nearable
		self.itemId = id
		self._lastDetected = lastDetected ?? NSDate()
		self.image = image
    }
	
	required convenience public init?(coder decoder: NSCoder){
		guard let id = decoder.decodeObjectForKey(CodingKeys.idKey) as? String, let name = decoder.decodeObjectForKey(CodingKeys.nameKey) as? String, let nearable = decoder.decodeObjectForKey(CodingKeys.nearableKey) as? ESTNearable, let lastDetected = decoder.decodeObjectForKey(CodingKeys.lastDetectedKey) as? NSDate else {
			return nil
		}
		let image = decoder.decodeObjectForKey(CodingKeys.imageKey) as? UIImage
		self.init(id: id, name: name, nearable: nearable, image: image, lastDetected: lastDetected)
	}
	
	public func encodeWithCoder(coder: NSCoder) {
		coder.encodeObject(self.name, forKey: CodingKeys.nameKey)
		coder.encodeObject(self.itemId, forKey: CodingKeys.idKey)
		coder.encodeObject(self.lastDetected, forKey: CodingKeys.lastDetectedKey)
		coder.encodeObject(self._nearable, forKey: CodingKeys.nearableKey)
		coder.encodeObject(self.image, forKey: CodingKeys.imageKey)
	}
	
	
	//MARK: Location enum declaration
	enum Location {
		case Immediate(description: String)
		case Near(description: String)
		case Far(description: String)
		case Unknown(description: String)
		
		var description: String {
			switch self {
			case let .Immediate(description):return description
			case let .Near(description):return description
			case let .Unknown(description):return description
			case let .Far(description): return description
			}
		}
		
		init(){
			self = .Unknown(description: "Location unknown")
		}
		
		init(_ zone: ESTNearableZone, withDescription descr: String?) {
			switch zone.rawValue {
			case 0: self = .Unknown(description: descr ?? "Location unknown")
			case 1: self = .Immediate(description: descr ?? "Immediate")
			case 2: self = .Near(description: descr ?? "Near")
			case 3: self = .Far(description: descr ?? "Far away")
			default: self = .Unknown(description: descr ?? "Unknown")
			}
		}
	}
	
	
}