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
			if image != nil {
				self.layer.opacity = 1.0
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.layer.cornerRadius = bounds.size.width / 2
		clipsToBounds = true
		self.layer.borderColor = UIColor.imageBorderColor.cgColor
		self.layer.borderWidth = 2
		
	}
}
