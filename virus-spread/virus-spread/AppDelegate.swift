//
//  AppDelegate.swift
//  virus-spread
//
//  Created by Илья Михальцов on 28.3.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import Foundation
import CoreData

public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var deviceInfo: DeviceInfo!
    public var bluetoothManager: BluetoothManager!
    public var infectionManager: InfectionManager!

    lazy let locaionManager = LocationManager()

    public var window: UIWindow?

    public var infected: Bool { return self.infectionManager.infected }

    let backgroundObservable = Observable(AppDelegate)
    let foregroundObservable = Observable(AppDelegate)

    public func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let deviceInfoDictionary = defaults.objectForKey("deviceInfo")
                as? Dictionary<NSObject, AnyObject> {
            self.deviceInfo = DeviceInfo(dictionary: deviceInfoDictionary)
        } else {
            self.deviceInfo = DeviceInfo()
            self.deviceInfo.deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
            self.deviceInfo.age = 18
            self.deviceInfo.gender = "male"
            self.deviceInfo.userName = "test user"

            ApiSession.instance().POST("device/reg",
                parameters: [self.deviceInfo.encodeToDictionary()],
                success: { (task, responseObject) -> Void in
                    defaults.setObject(self.deviceInfo.encodeToDictionary(), forKey: "deviceInfo")
            }, failure: { (task, error) -> Void in

            })
        }

        self.bluetoothManager = BluetoothManager()
        self.infectionManager = InfectionManager()

        return true
    }

    public func applicationWillResignActive(application: UIApplication) {
    }

    public func applicationDidEnterBackground(application: UIApplication) {
        self.backgroundObservable.fire(from: self)
    }

    public func applicationWillEnterForeground(application: UIApplication) {
        self.foregroundObservable.fire(from: self)
    }

    public func applicationDidBecomeActive(application: UIApplication) {
    }

    public func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }

    lazy private var managedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext()
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()

    private static var managedObjectModel = NSManagedObjectModel(
        contentsOfURL: NSBundle.mainBundle().URLForResource("virus_spread", withExtension: "momd")!)!

    private static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("virus_spread.sqlite")

        let failureReason = "There was an error creating or loading the application's saved data."

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        var error: NSError?

        if coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil,
                URL: storeURL,
                options: nil,
                error: &error) == nil {
            var dict = Dictionary<String, AnyObject>()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "VirusSpread", code: 9999, userInfo: dict)
            // error
            NSLog("Unresolved error %@, %@", error!, error!.userInfo!)
            abort()
        }

        return coordinator
    }()

    private class var applicationDocumentsDirectory: NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask).last as! NSURL
    }

    private func saveContext() {
        var error: NSError? = nil
        if self.managedObjectContext.hasChanges && !self.managedObjectContext.save(&error) {
            NSLog("Unresolved error %@, %@", error!, error!.userInfo!)
            abort()
        }
    }

    public class var instance: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

}
