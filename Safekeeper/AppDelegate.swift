//
//  AppDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-01.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBCentralManagerDelegate {

    var window: UIWindow?
	fileprivate var bluetoothManager: CBCentralManager?
	fileprivate var locationManager = ItemTracker.getInstance()
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		self.window?.tintColor = UIColor.white
		UINavigationBar.appearance().barTintColor = UIColor.NavbarColor()
		
		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.classForCoder() as! UIAppearanceContainer.Type]).textColor = UIColor.NavbarColor()
		bluetoothManager = CBCentralManager(delegate: self, queue: nil)
		application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil))
		return true
    }

	func centralManagerDidUpdateState(_ central: CBCentralManager) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		locationManager.performOperation(ItemTracker.Operation.pauseRanging)
    }
	
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		locationManager.performOperation(ItemTracker.Operation.resumeRanging)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

