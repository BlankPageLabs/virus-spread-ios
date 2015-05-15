//
//  StilizedTextField.swift
//  virus-spread
//
//  Created by Илья Михальцов on 14.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

@IBDesignable
class StilizedTextField: UITextField {

    func customize() {
        self.borderStyle = .None
        self.layer.borderWidth = 1.0

        self.syncVisualState()
    }

    func syncVisualState() {
        self.layer.borderColor = AppColors.textField.colorForState(self.state).borderColor.CGColor
        self.backgroundColor = AppColors.textField.colorForState(self.state).backgroundColor
        self.textColor = AppColors.textField.colorForState(self.state).textColor
    }

    override func drawPlaceholderInRect(var rect: CGRect) {
        if let placeholder = self.placeholder {
            let placeholderFont = UIFont(descriptor: self.font.fontDescriptor().fontDescriptorByAddingAttributes([UIFontDescriptorTraitsAttribute: [UIFontSymbolicTrait: Int(UIFontDescriptorSymbolicTraits.TraitItalic.rawValue)]]),
                size: self.font.pointSize)
            rect.inset(dx: 10.0, dy: (self.bounds.height - placeholderFont.lineHeight)/2.0)

            (placeholder as NSString).drawInRect(rect, withAttributes: [
                NSForegroundColorAttributeName: AppColors.textField.colorForState(self.state).placeholderColor,
                NSFontAttributeName: placeholderFont,
                ])
        }
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.syncVisualState()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.customize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.customize()
    }


}
