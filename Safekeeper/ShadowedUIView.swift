//
//  ShadowedUIView.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-10.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class ShadowedUIView: UIView {
	
	override var bounds: CGRect {
		didSet{
			let path = UIBezierPath(rect: bounds)
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
			self.layer.shadowPath = path.cgPath
			self.layer.masksToBounds = false
			self.layer.shadowOpacity = 0.5
			self.layer.cornerRadius = 7
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
