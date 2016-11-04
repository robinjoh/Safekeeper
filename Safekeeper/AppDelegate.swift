//
//  AppDelegate.swift
//  Safekeeper
//
//  Created by Robin on 2016-07-01.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
import CoreBluetooth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBCentralManagerDelegate, ItemTrackerDelegate {

	var window: UIWindow?
	private var bluetoothManager: CBCentralManager?
	private var locationManager = ItemTracker.getInstance()
	private var itemStorage = ItemStorage()
	private let notificationManager = NotificationManager()
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let rootNavigationController = window?.rootViewController as? UINavigationController
		let root = rootNavigationController?.viewControllers.first as? ItemOverviewController
		root?.itemStorage = itemStorage
		do {
			try itemStorage.loadItems()
		}catch let error as FileSystemError {
			print(error.description)
		} catch {
			print(error.localizedDescription)
		}
		
		
		bluetoothManager = CBCentralManager(delegate: self, queue: nil)
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (done: Bool, error: Error?) -> Void in
			guard error == nil else {
				//implementera felhantering om det inte går att registrera notifikation
				return
			}
		})
		return true
    }

	func centralManagerDidUpdateState(_ central: CBCentralManager) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		locationManager.performOperation(ItemTracker.Operation.pauseRanging)
		locationManager.delegate = self
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
		do {
			locationManager.performOperation(ItemTracker.Operation.stopRanging)
			locationManager.performOperation(ItemTracker.Operation.stopMonitoring(itemStorage.items))
		 try itemStorage.saveItems()
		}catch let error as FileSystemError {
			print(error.description)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func itemTracker(didLoseItem item: Item) {
		
	}


}

