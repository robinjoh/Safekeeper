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
	var description: String {
		switch self {
		case .filePathNotFound(msg: let msg, path: let path): return "\(msg):" + "\(path)"
		case .saveFailure(msg: let msg): return msg
		}
	}
	case filePathNotFound(msg: String, path: String)
	case saveFailure(msg: String)
}
