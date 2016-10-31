//
//  RadarView.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-28.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

@IBDesignable
class RadarView: UIView {
	
    override func draw(_ rect: CGRect) {
        // Drawing code
		let path = UIBezierPath(ovalIn: self.bounds)
		UIColor.mainTextColor.setFill()
		path.fill()
		
    }
	

}
