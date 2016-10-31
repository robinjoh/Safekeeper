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
	
	public static var btnColor: UIColor {
		return UIColor(red: 140 / 255, green: 67 / 255, blue: 66 / 255, alpha: 1)
	}
	
	public static var mainColor: UIColor {
		return UIColor(red: 28 / 255, green: 28 / 255, blue: 28 / 255, alpha: 1)
	}

	public static var mainTextColor: UIColor {
		return UIColor(red: 93 / 255.0, green: 162 / 255.0, blue: 249 / 255.0, alpha: 1)
	}
	
	public static var navbarColor: UIColor {
		return UIColor(red: 28 / 255, green: 28 / 255, blue: 28 / 255, alpha: 1)
	}

	public static var tableHeaderColor: UIColor {
		return UIColor(red: 129 / 255, green: 95 / 255, blue: 92 / 255, alpha: 1)
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
	func setGradientBackground(_ colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint, bounds: CGRect) {
			let lay = CAGradientLayer()
			lay.frame = bounds
			lay.colors = colors
			lay.locations = locations
			lay.startPoint = startPoint
			lay.endPoint = endPoint
			self.layer.insertSublayer(layer, at: 0)
		}
}

extension UITableViewCell {
	struct ReuseIdentifier {
		static let NameCell = "nameCell"
		static let PickBeaconCell = "beaconCell"
		static let SelectImageCell = "addImageCell"
		static let NoItemsCell = "noItemsCell"
		static let ItemCell = "itemCell"
	}
}

extension UINavigationBar {

}

extension UIImage {
	struct Name {
		static let Wallet = "Wallet Filled"
		static let Radar = "radar"
		//lägg till fler
	}
}

extension UIView {
	static var StandardRounding: CGFloat {
		return 7
	}
}


