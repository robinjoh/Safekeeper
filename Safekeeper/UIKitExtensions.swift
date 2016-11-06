//
//  UIExtensions.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-10.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	
	public static var tableSectionHeaderBackgroundColor: UIColor {
		return UIColor(red: 28 / 255, green: 29 / 255, blue: 40 / 255, alpha: 1)
	}
	
	public static var btnColor: UIColor {
		return UIColor(red: 140 / 255, green: 67 / 255, blue: 66 / 255, alpha: 1)
	}
	
	public static var mainColor: UIColor {
		return UIColor(red: 28 / 255, green: 28 / 255, blue: 40 / 255, alpha: 1)
	}

	public static var mainTextColor: UIColor {
		return UIColor(red: 93 / 255.0, green: 162 / 255.0, blue: 249 / 255.0, alpha: 1)
	}
	
	public static var navbarColor: UIColor {
		return UIColor(red: 33 / 255, green: 65 / 255, blue: 87 / 255, alpha: 1)
	}

	public static var tableHeaderColor: UIColor {
		return UIColor(red: 129 / 255, green: 95 / 255, blue: 92 / 255, alpha: 1)
	}
	public static var tableHeaderTitleColor: UIColor {
		return UIColor(red: 34 / 255, green: 135, blue: 215, alpha: 1)
	}
}
extension UIViewController {
	enum Segue: String {
		case ShowItemDetails = "showItemDetails"
		case PickBeacon = "pickBeacon"
		case AddItem = "addItem"
	}
}

extension UIView {
	static var StandardRounding: CGFloat {
		return 7
	}
	
	func setGradientBackground(_ colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint, bounds: CGRect) {
			let lay = CAGradientLayer()
			lay.frame = bounds
			lay.colors = colors
			lay.locations = locations
			lay.startPoint = startPoint
			lay.endPoint = endPoint
			self.layer.insertSublayer(lay, at: 0)
	}
}

extension UITableViewCell {
	struct ReuseIdentifier {
		static let ItemNameCell = "nameCell"
		static let ItemImageCell = "imageCell"
		static let PickBeaconCell = "pickBeaconCell"
		static let NoItemsCell = "noItemsCell"
		static let ItemCell = "itemCell"
	}
}


extension UIImage {
	struct Name {
		static let Radar = "radar"
	}
}

extension UITableView {
	static var headerHeight: CGFloat {return 45}
	static var footerHeight: CGFloat { return 50}
	
	func indexPath(forBeaconId id: String) -> IndexPath? {
		for cell in self.visibleCells where cell is PickBeaconTableViewCell {
			if cell.accessibilityIdentifier == id {
				return self.indexPath(for: cell as! PickBeaconTableViewCell)
			}
		}
		return nil
	}

	struct TableSection {
			static let numberOfSections = 3
			
			struct NameSection {
				static let sectionNumber = 0
				static let sectionHeaderTitle = "NAME"
			}
			struct ImageSection {
				static let sectionNumber = 1
				static let sectionHeaderTitle = "IMAGE"
			}
			struct BeaconSection{
				static let sectionNumber = 2
				static let sectionHeaderTitle = "PICK BEACON"
				static let sectionFooterText = "Select one of the beacon IDs showing up in the list to connect it to the item you are about to create."
			}
			
			static func sectionHeaderTitle(_ sectionNumber: Int) -> String {
				return sectionNumber == NameSection.sectionNumber ? NameSection.sectionHeaderTitle : sectionNumber == ImageSection.sectionNumber ? ImageSection.sectionHeaderTitle : sectionNumber == BeaconSection.sectionNumber ? BeaconSection.sectionHeaderTitle : ""
			}
	}
}

