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
		self.navigationItem.title = item.name ?? "Item Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
