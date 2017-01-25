//
//  ItemTests.swift
//  Safekeeper
//
//  Created by Robin on 2017-01-21.
//  Copyright © 2017 Robin. All rights reserved.
//

import XCTest
@testable import Safekeeper


class ItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func setNearableWithoutIdentifier_Nil() {
		let item = Item(id: "ASD", name: "Test", nearable: nil, image: UIImage())
		item?.nearable = ESTNearable()
		XCTAssertNil(item?.nearable)
	}
	
}
