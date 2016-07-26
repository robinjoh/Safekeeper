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
		let img = UIImage(named:"Brain")
		let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: img!.size.width, height: img!.size.height))
		imgView.image = img
		navigationBar.topItem?.titleView = imgView
    }
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
    }
	

}
