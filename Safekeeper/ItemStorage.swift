//
//  ItemStorage.swift
//  Safekeeper
//
//  Created by Robin on 2016-11-01.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

class ItemStorage {
	private var _items = [String:Item]()
	var items: [Item] {
		return Array(_items.values)
	}
	var keys: [String] {
		return Array(_items.keys)
	}
	var isEmpty: Bool {
		return _items.isEmpty
	}
	var count: Int {
		return _items.count
	}
	
	private struct Storage {
		static let StorageDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
		static let ArchiveURL = StorageDirectory.appendingPathComponent(Item.StorageCatalogName)
	}
	
	func saveItems() throws {
		guard NSKeyedArchiver.archiveRootObject(items, toFile: Storage.ArchiveURL.path) else {
			//visa en alert om att det inte gick att spara.
			throw FileSystemError.saveFailure(msg: "An error occurred when trying to save items.")
		}
	}
	
	func loadItems() throws {
		guard (Storage.ArchiveURL as NSURL).checkResourceIsReachableAndReturnError(nil) else {
			throw FileSystemError.filePathNotFound(msg: "Could not load items from path", path: Storage.ArchiveURL.path)
		}
		_items = NSKeyedUnarchiver.unarchiveObject(withFile: Storage.ArchiveURL.path) as! [String:Item]
	}
	
	@discardableResult func saveItem(_ item: Item) -> Bool {
	 do {
		_items[item.itemId] = item
		try saveItems()
		return true
	} catch let error as FileSystemError {
		print(error.description)
	} catch {
		print("An unknown error occurred. \(error.localizedDescription)")
	}
		return false
	}
	
	func addItem(_ item: Item) {
		_items.updateValue(item, forKey: item.itemId)
		saveItem(item)
	}
	
	func deleteItem(_ itemIdentifier: String) -> Item? {
		if let removed = _items.removeValue(forKey: itemIdentifier) {
			try? saveItems()
			return removed
		}
		return nil
	}
	
	func getItem(_ itemId: String) -> Item? {
		return _items[itemId]
	}
	
	func contains(_ item: Item) -> Bool {
		return _items.index(forKey: item.itemId) != nil
	}
}
