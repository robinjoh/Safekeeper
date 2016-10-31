//
//  NavbarViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-04.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class NavbarViewController: UINavigationController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//		let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//		effectView.frame = self.navigationBar.bounds
//		effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//		self.navigationBar.addSubview(effectView)
//		self.navigationBar.sendSubview(toBack: effectView)
	}
}
