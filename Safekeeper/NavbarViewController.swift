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
		TallerBar.setNavbarAppearance(self)
//		navigationBar.layer.shadowPath = UIBezierPath(rect: navigationBar.bounds).CGPath
//		navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
//		navigationBar.layer.shadowOpacity = 0.5
//		navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
//		navigationBar.layer.masksToBounds = false
	}

}
