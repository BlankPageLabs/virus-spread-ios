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
    public var deviceInfo: DeviceInfo! {
        didSet {
            if deviceInfo != nil {
                self.infectionManager = InfectionManager()
            } else {
                self.infectionManager = nil
            }
        }
    }
    public var bluetoothManager: BluetoothManager!
    public var infectionManager: InfectionManager!
    var errorController: ErrorController = ErrorController()

    public let defaultDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        return formatter
    }()

    var locationManager: LocationManager!

    public var window: UIWindow?
    public var rootViewController: ViewController?

    public var infected: Bool { return self.infectionManager.infected }

    let backgroundObservable = Observable(AppDelegate)
    let foregroundObservable = Observable(AppDelegate)

    func presentError(title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        a.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))

        let vc = self.topViewController()
        if !(vc is UIAlertController) {
            self.topViewController().presentViewController(a, animated: true, completion: nil)
        } else {
            // Don't stack errors
        }
    }

    func topViewController() -> UIViewController {
        var vc: UIViewController = self.rootViewController!
        while let newVc = vc.presentedViewController {
            vc = newVc
        }
        return vc
    }

    @objc
    public func debugMessage_int(message: String) {
        debugMessage(message)
    }

    @objc
    @noreturn func fatalErrorWithUi_int(@autoclosure message: () -> String) {
        fatalErrorWithUi(message)
    }

    @objc
    func defaultError_int(message: String) {
        defaultError(message)
    }

    public func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.bluetoothManager = BluetoothManager()

        // TODO: activate through UI
        self.locationManager = LocationManager()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.rootViewController = UIStoryboard(name: "Main",
            bundle: NSBundle(forClass: AppDelegate.self)).instantiateInitialViewController() as? ViewController
        self.window?.rootViewController = self.rootViewController
        self.window?.makeKeyAndVisible()

        let defaults = NSUserDefaults.standardUserDefaults()
        if let deviceInfoDictionary = defaults.objectForKey("deviceInfo")
                as? Dictionary<NSObject, AnyObject> {
            self.deviceInfo = DeviceInfo(dictionary: deviceInfoDictionary)
        } else {
            self.rootViewController?.performSegueWithIdentifier("registrationProgress", sender: self)
        }

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

    public class var applicationDocumentsDirectory: NSURL {
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
