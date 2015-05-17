//
//  StilizedSegmentedControl.swift
//  virus-spread
//
//  Created by Илья Михальцов on 16.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

@IBDesignable
class StilizedSegmentedControl: UISegmentedControl {

    private func customize() {
        self.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 18.0)!
            ], forState: .Normal)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = self.tintColor.CGColor
    }

    func flashError() {
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue()) { () -> Void in
            self.layer.borderWidth = 1.0
            let oldColor = self.layer.borderColor
            let animation = CAKeyframeAnimation(keyPath: "borderColor")
            animation.values = [oldColor, AppColors.textField.errorColor.CGColor, AppColors.textField.errorColor.CGColor, oldColor]
            animation.removedOnCompletion = true
            animation.duration = 2.1
            animation.calculationMode = kCAAnimationCubic
            animation.keyTimes = [0.0, 0.07, 0.52, 1.0]
            self.layer.addAnimation(animation, forKey: "border color")
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.customize()
    }

    override init(items: [AnyObject]) {
        super.init(items: items)

        self.customize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customize()
    }


}
