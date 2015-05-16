//
//  StilizedButton.swift
//  virus-spread
//
//  Created by Илья Михальцов on 15.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

@IBDesignable
class StilizedButton: UIButton {

    func customize() {
        self.setTitleColor(AppColors.button.normal.textColor, forState: .Normal)
        self.setTitleColor(AppColors.button.normalHighlighted.textColor, forState: .Normal | .Highlighted)
        self.setTitleColor(AppColors.button.disabled.textColor, forState: .Disabled)

        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0

        self.syncVisualState()
    }

    override dynamic var highlighted: Bool {
        didSet {
            self.syncVisualState()
        }
    }

    func syncVisualState() {
        self.layer.borderColor = AppColors.button.colorForState(self.state).borderColor.CGColor
        self.backgroundColor = AppColors.button.colorForState(self.state).backgroundColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.customize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customize()
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
    }
}
