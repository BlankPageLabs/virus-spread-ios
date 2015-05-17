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
    private var firstRegistration = true

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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.performSegueWithIdentifier("progress", sender: self)
        AppDelegate.instance.registrationManager.requestUserRetrievalWithSuccess({ () -> Void in
            self.deviceInfo = AppDelegate.instance.deviceInfo
            if let username = self.deviceInfo?.userName {
                self.usernameField.text = username
            }
            switch (self.deviceInfo?.gender) {
            case .Some("male"):
                self.genderField.selectedSegmentIndex = 0
            case .Some("female"):
                self.genderField.selectedSegmentIndex = 1
            default:
                break
            }
            if let birthdate = self.deviceInfo?.birthdate {
                self.birthdateField.date = birthdate
            }
            self.firstRegistration = false
            self.presentedViewController!.performSegueWithIdentifier("return", sender: self)
        }, failure: { () -> Void in
            self.presentedViewController!.performSegueWithIdentifier("return", sender: self)
        })
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
                devInfo.birthdate = birthdate
            } else {
                devInfo.birthdate = nil
            }
            self.deviceInfo = devInfo
            AppDelegate.instance.deviceInfo = devInfo
            self.performSegueWithIdentifier("progress", sender: self)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let success = { () -> Void in
                    self.presentedViewController!.performSegueWithIdentifier("return", sender: self)
                    //                    self.performSegueWithIdentifier("registerComplete", sender: self)
                }
                let failure = { () -> Void in
                    let alert = UIAlertController(title: NSLocalizedString("errorTitle", comment: "Error"),
                        message: NSLocalizedString("serverError", comment: "Unknown server error"),
                        preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
                        self.presentedViewController!.performSegueWithIdentifier("return", sender: self)
                    }))
                    self.presentedViewController!.presentViewController(alert, animated: true, completion: nil)
                }
                if self.firstRegistration {
                    AppDelegate.instance.registrationManager.requestUserRegistrationWithSuccess(success, failure: failure)
                } else {
                    AppDelegate.instance.registrationManager.requestUserUpdateWithSuccess(success, failure: failure)
                }
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
}
