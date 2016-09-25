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
	public static func NavbarColor() -> UIColor {
	return UIColor(red: 44.0 / 255, green: 142.0 / 255, blue: 75.0 / 255, alpha: 0.85)
	}

}

extension CALayer {
	func layerWithGradientColors(_ firstColor: CGColor, secondColor: CGColor, bounds: CGRect) -> CAGradientLayer {
		let lay = CAGradientLayer()
		lay.frame = bounds
		lay.colors = [firstColor,secondColor]
		lay.startPoint = CGPoint(x: 0, y: 0.5)
		lay.endPoint = CGPoint(x: 1, y: 1)
		return lay
	}
}

extension UIImage {
	public static func getImageWithColor(_ color: UIColor) -> UIImage {
		let rect = CGRect(x: 0,y: 0,width: 1,height: 1)
		UIGraphicsBeginImageContext(rect.size)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}

extension UIViewController {
	enum Segue: String {
		case ShowItemDetails = "showItemDetails"
		case PickBeacon = "pickBeacon"
		case AddItem = "addItem"
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

extension UIImage {
	struct Name {
		static let Wallet = "Wallet Filled"
		static let Brain = "Brain"
		//lägg till fler
	}
}

//Subclass extensions

class TallerBar: UINavigationBar {
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: self.superview!.frame.width, height: 60)
	}
	
	static func setNavbarAppearance(_ viewController: NavbarViewController) {
		let img = UIImage(named: UIImage.Name.Brain)
		let view = UIView(frame: CGRect(x: img!.size.width / 2, y: 0, width: img!.size.width, height: img!.size.height))
		let imgView = UIImageView(frame: CGRect(x: 0, y: -20, width: img!.size.width, height: img!.size.height))
		imgView.image = img
		view.addSubview(imgView)
		let lbl = UILabel(frame: CGRect(x: -27, y: imgView.bounds.size.height - 20, width: 100, height: 20))
		lbl.textColor = UIColor.white
		lbl.font = UIFont(name: "System Light", size: 13)
		lbl.text = "Safekeeper"
		view.addSubview(lbl)
		viewController.navigationBar.topItem?.titleView = view
	}
}

