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
        self.usernameField.flashError()
        self.genderField.flashError()
    }

    @IBAction func foldStateChanged(sender: AnyObject) {
        self.scrollView.scrollRectToVisible(self.registerButton.frame.rectByOffsetting(dx: 0.0, dy: 10.0), animated: true)
    }

}
