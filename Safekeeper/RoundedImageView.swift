//
//  RoundedImageView.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-31.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedImageView: UIImageView {
	@IBInspectable var setRounded = true {
		didSet {
			if setRounded {
				self.layer.cornerRadius = bounds.size.width / 2
				self.clipsToBounds = true
			} else {
				self.layer.cornerRadius = 0
			}
		}
	}

}
