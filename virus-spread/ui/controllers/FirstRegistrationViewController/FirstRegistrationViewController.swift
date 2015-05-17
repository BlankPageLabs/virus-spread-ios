//
//  FirstRegistrationViewController.swift
//  virus-spread
//
//  Created by Илья Михальцов on 16.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

class FirstRegistrationViewController: UIViewController {

    @IBOutlet private var usernameField: StilizedTextField!
    @IBOutlet private var genderField: StilizedSegmentedControl!
    @IBOutlet private var birthdateField: DateSelector!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var registerButton: StilizedButton!
    var observationObjects: [AnyObject] = []

    private var deviceInfo: DeviceInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        let kbdUpdateLambda =  { (notification: NSNotification!) -> Void in
            self.updateScrollViewInsets(
                (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            )
            self.scrollView.scrollRectToVisible(self.registerButton.frame.rectByOffsetting(dx: 0.0, dy: 10.0), animated: true)
        }
        observationObjects.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil,
            queue: NSOperationQueue.mainQueue(), usingBlock: kbdUpdateLambda))
        observationObjects.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil,
            queue: NSOperationQueue.mainQueue(), usingBlock: kbdUpdateLambda))
        observationObjects.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil,
            queue: NSOperationQueue.mainQueue(), usingBlock: kbdUpdateLambda))

        self.birthdateField.addTarget(self, action: Selector("foldStateChanged:"), forControlEvents: .FoldStateChanged)
    }

    deinit {
        for o in observationObjects {
            NSNotificationCenter.defaultCenter().removeObserver(o)
        }
    }

    private func updateScrollViewInsets(kbdFrame: CGRect) {
        let inScrollFrame = self.view.convertRect(kbdFrame, fromView: nil)
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: scrollView.frame.maxY - inScrollFrame.minY, right: 0)
    }

    @IBAction func freeSpaceTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func registerAction(sender: AnyObject) {
        switch((self.usernameField.text, self.genderField.selectedSegmentIndex, self.birthdateField.date)) {
        case let (username, _, _) where username.isEmpty:
            self.usernameField.flashError()
        case (_, -1, _):
            self.genderField.flashError()
        case let (_, _, .Some(date)) where date.compare(NSDate()) != .OrderedAscending:
            self.birthdateField.flashError()
        case let (.Some(username), genderIdx, birthdate_opt):
            let devInfo = DeviceInfo()
            devInfo.deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
            devInfo.userName = username
            devInfo.gender = genderIdx == 0 ? "male" : "female"
            // XXX: Fix in API
            if let birthdate = birthdate_opt {
                devInfo.age = UInt(NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: birthdate, toDate: NSDate(), options: nil).year)
            } else {
                devInfo.age = 0
            }
            self.deviceInfo = devInfo
            AppDelegate.instance.deviceInfo = devInfo
            self.performSegueWithIdentifier("progress", sender: self)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                AppDelegate.instance.registrationManager.requestUserRegistrationWithSuccess({ () -> Void in
                    self.presentedViewController?.performSegueWithIdentifier("return", sender: self)
//                    self.performSegueWithIdentifier("registerComplete", sender: self)
                }, failure: { () -> Void in
                    self.presentedViewController!.performSegueWithIdentifier("return", sender: self)
                })
            })
        default:
            assertionFailure("This can't be, but the compiler says it can. Hm.")
        }
    }

    @IBAction func foldStateChanged(sender: AnyObject) {
        self.scrollView.scrollRectToVisible(self.registerButton.frame.rectByOffsetting(dx: 0.0, dy: 10.0), animated: true)
    }


    @IBAction func unwindOneStep(segue: UIStoryboardSegue) {
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let info = self.deviceInfo {
            return true
        } else {
            return false
        }
    }
}
