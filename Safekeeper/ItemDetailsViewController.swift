//
//  ItemViewController.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-02.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = item.name
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
