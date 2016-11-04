//
//  BeaconView.swift
//  Safekeeper
//
//  Created by Robin on 2016-10-28.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class BeaconView: UIView {
	private var _beaconColor = UIColor.purple
	var beaconColor: UIColor! {
		get {
			return _beaconColor
		}
		set {
			_beaconColor = newValue
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup(){
		beaconColor = UIColor.purple
	}
	
    override func draw(_ rect: CGRect) {
		
    }

}
