//
//  Errors.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-21.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation


enum ItemError: ErrorType {
	case InvalidItemID(msg: String)
}

enum FileSystemError: ErrorType {
	case FilePathNotFound(msg: String, path: String)
}