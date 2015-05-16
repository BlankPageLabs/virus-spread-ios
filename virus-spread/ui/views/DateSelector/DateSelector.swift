//
//  DateSelector.swift
//  virus-spread
//
//  Created by Илья Михальцов on 16.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

@IBDesignable
class DateSelector: UIControl, UITextFieldDelegate {
    var date: NSDate?

    private let textFieldView = StilizedTextField()
    private let datePickerView = UIDatePicker()

    private var inactiveDatePickerConstraints: [AnyObject] = []
    private var activeDatePickerConstraints: [AnyObject] = []

    private func dateSelectorInit() {
        self.datePickerView.datePickerMode = .Date
        // FIXME: disabled text not updated on scrolling, and the color is not suitable
//        self.datePickerView.maximumDate = NSDate()
        self.datePickerView.addTarget(self, action: Selector("dateSelectorValueChanged:"), forControlEvents: .ValueChanged)

        self.textFieldView.delegate = self
        self.textFieldView.clearButtonMode = .Always

        // Get rid of pesky autoresizing
        self.textFieldView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.datePickerView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.datePickerView.hidden = true

        self.textFieldView.hasBorders = false
        self.clipsToBounds = true

        // FIXME
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0

        self.addSubview(textFieldView)
        self.addSubview(datePickerView)
    }

    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        return formatter
    }()

    @objc
    private func dateSelectorValueChanged(sender: UIDatePicker) {
        self.textFieldView.text = dateFormatter.stringFromDate(self.datePickerView.date)
        self.date = self.datePickerView.date
    }

    private func recolorDatePicker(picker: UIDatePicker) {
        // Yeah, I know. That is a veeeerry fracking big hack
        self.datePickerView.setValue(UIColor.whiteColor(), forKey: "textColor")

        // For the declaration, see at the bottom of this file. Yep, I said, BIG FRACKING hack
        (self.datePickerView as AnyObject).setHighlightsToday(false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.recolorDatePicker(self.datePickerView)
    }

    @IBInspectable
    var placeholder: String? {
        get {
            return self.textFieldView.placeholder
        }
        set {
            self.textFieldView.placeholder = newValue
        }
    }

    private func setDatePickerActive(active: Bool) {
        if active {
            NSLayoutConstraint.deactivateConstraints(self.inactiveDatePickerConstraints)
            NSLayoutConstraint.activateConstraints(self.activeDatePickerConstraints)
        } else {
            NSLayoutConstraint.deactivateConstraints(self.activeDatePickerConstraints)
            NSLayoutConstraint.activateConstraints(self.inactiveDatePickerConstraints)
        }
    }

    override var selected: Bool {
        didSet {
            if oldValue == self.selected {
                return
            }
            self.datePickerView.alpha = self.selected ? 0.0 : 1.0
            self.datePickerView.hidden = false
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.textFieldView.selected = self.selected
                self.datePickerView.alpha = self.selected ? 1.0 : 0.0
                self.setDatePickerActive(self.selected)
                self.superview!.layoutIfNeeded()
            }, completion: { completed in
                self.datePickerView.hidden = !self.selected
                self.datePickerView.alpha = 1.0
            })
        }
    }

    override var highlighted: Bool {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.textFieldView.highlighted = self.highlighted
            })
        }
    }

    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let r = super.beginTrackingWithTouch(touch, withEvent: event)
        self.highlighted = true
        return r
    }

    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let r = super.continueTrackingWithTouch(touch, withEvent: event)
        return r
    }

    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        if self.enabled {
            if self.highlighted {
                self.becomeFirstResponder()
            }
        }
        self.highlighted = false
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.selected = true
        return true
    }

    override func resignFirstResponder() -> Bool {
        self.selected = false
        return true
    }

    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.highlighted = false
    }


    override func updateConstraints() {
        super.updateConstraints()

        self.activeDatePickerConstraints = [
        ]
        self.inactiveDatePickerConstraints = [
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal,
                toItem: self.textFieldView, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.datePickerView, attribute: .Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0),
        ]
        self.setDatePickerActive(self.selected)
        self.addConstraints([
            NSLayoutConstraint(item: self.textFieldView, attribute: .Leading, relatedBy: .Equal,
                toItem: self.datePickerView, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.textFieldView, attribute: .Trailing, relatedBy: .Equal,
                toItem: self.datePickerView, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal,
                toItem: self.datePickerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.textFieldView, attribute: .Bottom, relatedBy: .Equal,
                toItem: self.datePickerView, attribute: .Top, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: self.textFieldView, attribute: .Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 43.0),
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal,
                toItem: self.textFieldView, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: self.textFieldView, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: self.textFieldView, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            ])
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dateSelectorInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dateSelectorInit()
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            // Prevent taps from interfering with the control

            // Filter out only gestureRecognizers up the chain, not down
            if let view = gestureRecognizer.view {
                var superviews: [UIView] = [self.superview!]
                while let other = superviews.last?.superview {
                    superviews += [other]
                }
                return contains(superviews, view) ? false : true
            } else {
                return true
            }
        } else {
            return true
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.becomeFirstResponder()
        return false
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.date = nil
        return true
    }
}

@objc
private protocol TextColor {
    func setHighlightsToday(obj: Bool)
}
