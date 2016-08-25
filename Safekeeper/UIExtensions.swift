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
	return UIColor(red: 58.0 / 255, green: 188.0 / 255, blue: 97.0 / 255, alpha: 0.85)
	}

}

extension CALayer {
	func layerWithGradientColors(firstColor: CGColor, secondColor: CGColor, bounds: CGRect) -> CAGradientLayer {
		let lay = CAGradientLayer()
		lay.frame = bounds
		lay.colors = [firstColor,secondColor]
		lay.startPoint = CGPoint(x: 0, y: 0.5)
		lay.endPoint = CGPoint(x: 1, y: 1)
		return lay
	}
}

extension UIImage {
	public static func getImageWithColor(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0,y: 0,width: 1,height: 1)
		UIGraphicsBeginImageContext(rect.size)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}

extension UIViewController {
	enum Segue: String {
		case ShowItemDetails = "showItemDetails"
		case PickBeacon = "pickBeacon"
	}
}

extension UITableViewCell {
	struct ReuseIdentifier {
		static let NameCellIdentifier = "nameCell"
		static let PickBeaconCellIdentifier = "beaconCell"
		static let SelectImageCellIdentifier = "addImageCell"
	}
}

//Subclass extensions

class TallerBar: UINavigationBar {
	override func sizeThatFits(size: CGSize) -> CGSize {
		return CGSizeMake(self.superview!.frame.width, 60)
	}
	
	static func setNavbarAppearance(viewController: NavbarViewController) {
		let img = UIImage(named:"Brain")
		let view = UIView(frame: CGRect(x: 0, y: 0, width: img!.size.width, height: img!.size.height))
		let imgView = UIImageView(frame: CGRect(x: 0, y: -20, width: img!.size.width, height: img!.size.height))
		imgView.image = img
		view.addSubview(imgView)
		let lbl = UILabel(frame: CGRect(x: -27, y: imgView.bounds.minY + 10, width: 100, height: 20))
		lbl.textColor = UIColor.whiteColor()
		lbl.font = UIFont(name: "System Light", size: 13)
		lbl.text = "Safekeeper"
		view.addSubview(lbl)
		viewController.navigationBar.topItem?.titleView = view
	}
}

