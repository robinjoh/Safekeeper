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
	}
}
