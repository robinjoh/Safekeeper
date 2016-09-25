//
//  Errors.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-21.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation


enum ItemError: Error {
	case invalidItemID(msg: String)
}

enum FileSystemError: Error {
	case filePathNotFound(msg: String, path: String)
}
