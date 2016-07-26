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
	return UIColor(red: 97.0 / 255, green: 179.0 / 255, blue: 218.0 / 255, alpha: 0.85)
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