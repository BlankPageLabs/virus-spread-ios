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

    @IBInspectable
    var roundedCorners: Bool = false {
        didSet {
            self.layer.cornerRadius = roundedCorners ? 4.0 : 0.0
        }
    }

    @IBInspectable
    var hasBorders: Bool = true {
        didSet {
            self.layer.borderWidth = hasBorders ? 1.0 : 0.0
        }
    }

    func flashError() {
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue()) { () -> Void in
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

    private func customize() {
        self.placeholderFont = createPlaceholderFontWithFont(self.font)

        self.borderStyle = .None
        self.layer.borderWidth = 1.0

        self.syncVisualState()
    }

    private func syncVisualState() {
        self.layer.borderColor = AppColors.textField.colorForState(self.state).borderColor.CGColor
        self.backgroundColor = AppColors.textField.colorForState(self.state).backgroundColor
        self.textColor = AppColors.textField.colorForState(self.state).textColor
    }

    private var placeholderFont: UIFont!

    override dynamic var font: UIFont! {
        didSet {
            self.placeholderFont = createPlaceholderFontWithFont(font)
            self.setNeedsLayout()
        }
    }

    private func createPlaceholderFontWithFont(font: UIFont) -> UIFont {
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

    override func becomeFirstResponder() -> Bool {
        let r = super.becomeFirstResponder()
        self.highlighted = false
        if r {
            self.selected = true
        }
        return r
    }

    override func resignFirstResponder() -> Bool {
        let r = super.resignFirstResponder()
        if r {
            self.selected = false
        }
        return r
    }

    override dynamic var selected: Bool {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.syncVisualState()
            })
        }
    }

    override dynamic var highlighted: Bool {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.syncVisualState()
            })
        }
    }

    override dynamic var enabled: Bool {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.syncVisualState()
            })
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
#if false
        // Option 1 — deselect control
        // This seems logical and visually correct
        let touch = touches.first as! UITouch
        if !self.bounds.contains(touch.locationInView(self)) {
            self.highlighted = false
        }
#else
        // Option 2 — activate control
        // This is the default behaviour of all system buttons and controls (except, well, Text Fields. wow)
        if self.highlighted {
            self.becomeFirstResponder()
        }
#endif

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
