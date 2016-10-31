//
//  ShadowedUIView.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-10.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class ShadowedUIView: UIView {
	
	private struct ShadowAttributes {
		static let offset = CGSize(width: 0, height: 0.5)
		static let opacity: Float = 0.8
	}
	
	override var bounds: CGRect {
		didSet{
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOffset = ShadowAttributes.offset
			self.layer.shadowOpacity = ShadowAttributes.opacity
			self.layer.borderWidth = 1
			self.layer.borderColor = UIColor.mainColor.cgColor
			self.layer.cornerRadius = UIView.StandardRounding
		}
	}
}
