//
//  FirstRegistrationViewController.swift
//  virus-spread
//
//  Created by Илья Михальцов on 16.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

class FirstRegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func freeSpaceTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }

}
