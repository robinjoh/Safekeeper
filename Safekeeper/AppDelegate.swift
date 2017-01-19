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
	private var itemStorage = ItemStorage.instance
	private let backgroundTrackingDelegate = BackgroundTracker()
	private var visibleViewController: UIViewController?
	
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
		if locationManager.isRanging {
			locationManager.performOperation(ItemTracker.Operation.stopRanging)
		}
		locationManager.performOperation(ItemTracker.Operation.startMonitoring(itemStorage.items))
		locationManager.delegate = backgroundTrackingDelegate
		backgroundTrackingDelegate.startLostItemsChecking()
		do {
			try itemStorage.saveItems()
		} catch let error as FileSystemError {
			print(error.description)
		} catch {
			print(error.localizedDescription)
		}
	}
	
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		if let addItem = visibleViewController as? AddItemViewController {
		addItem.resetTrackedNearables()
		}
		backgroundTrackingDelegate.stopLostItemsChecking()
		application.applicationIconBadgeNumber = 0
    }
	
	func applicationWillResignActive(_ application: UIApplication) {
		visibleViewController = getVisibleViewController(window?.rootViewController)
	}

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		do {
			if locationManager.isRanging{
			locationManager.performOperation(ItemTracker.Operation.stopRanging)
			}
		 try itemStorage.saveItems()
		}catch let error as FileSystemError {
			print(error.description)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
		var rootVC = rootViewController
		if rootVC == nil {
			rootVC = UIApplication.shared.keyWindow?.rootViewController
		}
		if rootVC?.presentedViewController == nil {
			return rootVC
		}
		if let presented = rootVC?.presentedViewController {
			if presented.isKind(of: UINavigationController.self) {
				let navigationController = presented as! UINavigationController
				return navigationController.viewControllers.last!
			}
			
			if presented.isKind(of: UITabBarController.self) {
				let tabBarController = presented as! UITabBarController
				return tabBarController.selectedViewController!
			}
			
			return getVisibleViewController(presented)
		}
		return nil
	}
}

