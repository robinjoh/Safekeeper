//
//  ArrayDataSource.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-08.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

import UIKit

class ArrayDataSource: NSObject, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
