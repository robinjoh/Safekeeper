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
	override var image: UIImage? {
		didSet{
			super.image = image
			self.layer.cornerRadius = bounds.size.width / 2
			self.clipsToBounds = true
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.layer.cornerRadius = bounds.size.width / 2
		clipsToBounds = true
	}
}
