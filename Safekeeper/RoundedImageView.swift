//
//  RoundedImageView.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-31.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}
	
	override var bounds: CGRect {
		didSet{
			if image != nil{
			layer.cornerRadius = frame.size.width / 2
			self.clipsToBounds = true
			}
		}
	}
}
