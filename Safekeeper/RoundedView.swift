//
//  RoundedImageView.swift
//  Safekeeper
//
//  Created by Robin on 2016-09-27.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
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
				layer.cornerRadius = frame.size.width / 2
				self.clipsToBounds = true
		}
	}
}
