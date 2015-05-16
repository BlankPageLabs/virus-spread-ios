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
        self.placeholderFont = createPlaceholderFontWithFont(self.font)

        self.borderStyle = .None
        self.layer.borderWidth = 1.0

        self.syncVisualState()
    }

    func syncVisualState() {
        self.layer.borderColor = AppColors.textField.colorForState(self.state).borderColor.CGColor
        self.backgroundColor = AppColors.textField.colorForState(self.state).backgroundColor
        self.textColor = AppColors.textField.colorForState(self.state).textColor
    }

    var placeholderFont: UIFont!

    override dynamic var font: UIFont! {
        didSet {
            self.placeholderFont = createPlaceholderFontWithFont(font)
            self.setNeedsLayout()
        }
    }

    func createPlaceholderFontWithFont(font: UIFont) -> UIFont {
        return UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic)!,
            size: font.pointSize)
    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(bounds).rectByInsetting(dx: 10.0, dy: (self.bounds.height - self.font.lineHeight)/2.0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(bounds).rectByInsetting(dx: 10.0, dy: (self.bounds.height - self.font.lineHeight)/2.0)
    }

    override func drawPlaceholderInRect(var rect: CGRect) {
        if let placeholder = self.placeholder {
            (placeholder as NSString).drawInRect(rect, withAttributes: [
                NSForegroundColorAttributeName: AppColors.textField.colorForState(self.state).placeholderColor,
                NSFontAttributeName: self.placeholderFont,
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
