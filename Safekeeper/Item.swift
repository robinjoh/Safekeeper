//
//  Item.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

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
	}
	
    private(set) var name: String
    private(set) var itemId: String
	private var _location: Location
	private var _lastDetected: NSDate
	private var _nearable: ESTNearable!
	var location: Location {
		get {
			return _location
		}
		set {
			_location = newValue
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
    
	init?(id: String, name: String, nearable: ESTNearable?, lastDetected: NSDate?){
		guard id.characters.count == 16 && !name.isEmpty else {
			return nil
		}
		self._location = Location()
        self.name = name
		self._nearable = nearable
		self.itemId = id
		self._lastDetected = lastDetected ?? NSDate()
    }
	
	required convenience public init?(coder decoder: NSCoder){
		guard let id = decoder.decodeObjectForKey(CodingKeys.idKey) as? String, let name = decoder.decodeObjectForKey(CodingKeys.nameKey) as? String, let nearable = decoder.decodeObjectForKey(CodingKeys.nearableKey) as? ESTNearable, let lastDetected = decoder.decodeObjectForKey(CodingKeys.lastDetectedKey) as? NSDate else {
			return nil
		}
		self.init(id: id, name: name, nearable: nearable, lastDetected: lastDetected)
	}
	
	public func encodeWithCoder(coder: NSCoder) {
		coder.encodeObject(self.name, forKey: CodingKeys.nameKey)
		coder.encodeObject(self.itemId, forKey: CodingKeys.idKey)
		coder.encodeObject(self.lastDetected, forKey: CodingKeys.lastDetectedKey)
		coder.encodeObject(self._nearable, forKey: CodingKeys.nearableKey)
	}
	
	
	//MARK: Location enum declaration
	enum Location {
		case Immediate(String)
		case Near(String)
		case Far(String)
		case Unknown(String)
		
		var value: String {
			switch self {
			case .Immediate(let val): return val
			case .Near(let val): return val
			case .Far(let val):return val
			case .Unknown(let val): return val
			}
		}
		
		init(){
			self = .Unknown("Location unknown")
		}
		
		init(_ zone: ESTNearableZone) {
			switch zone.rawValue {
			case 0: self = .Unknown("Location unknown")
			case 1: self = .Immediate("Immediate")
			case 2: self = .Near("Near")
			case 3: self = .Far("Far away")
			default: self = .Unknown("Location unknown")
			}
		}
	}
	
	
}