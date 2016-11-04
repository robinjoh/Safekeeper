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
	@IBInspectable public var setRound = true {
		didSet {
			if setRound {
				layer.cornerRadius = frame.size.width / 2
				self.clipsToBounds = true

			} else {
				layer.cornerRadius = 0
			}
		}
	}
}
