//
//  Item.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

public class Item {
    private(set) var name: String
    private(set) var itemId: String
	private(set) var nearable: ESTNearable
    
    init?(id: String, name: String, nearable: ESTNearable){
        self.name = name
		self.nearable = nearable
		guard id.characters.count == 16 else {
			return nil
		}
		itemId = id
    }

}