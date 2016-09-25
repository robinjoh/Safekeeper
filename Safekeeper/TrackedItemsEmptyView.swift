//
//  TrackedItemsEmptyView.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-29.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class TrackedItemsEmptyView: UIView {
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 50.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
