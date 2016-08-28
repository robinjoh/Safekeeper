//
//  NavbarViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-04.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class NavbarViewController: UINavigationController {
	var alreadyUsedIdentifiers = Set<String>()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		TallerBar.setNavbarAppearance(self)
		for child in childViewControllers {
			if let addItem = child as? AddItemViewController {
				addItem.alreadyUsedIdentifiers = alreadyUsedIdentifiers
			}
		}
	}
}
