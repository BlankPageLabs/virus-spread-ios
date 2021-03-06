//
//  AppColors.swift
//  virus-spread
//
//  Created by Илья Михальцов on 15.5.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import UIKit

private let whiteColor = UIColor.whiteColor()
private let skyBlueColor = UIColor(red: 51.0/255.0, green: 155.0/255.0, blue: 213.0/255.0, alpha: 1.0)
private let blueColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
private let lightedBlueColor = UIColor(red: 92.0/255.0, green: 175.0/255.0, blue: 221.0/255.0, alpha: 1.0)
private let grayColor = UIColor(red: 150.0/255.0, green: 192.0/255.0, blue: 214.0/255.0, alpha: 1.0)
private let redColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
private let clearColor = UIColor.clearColor()

protocol ColoredControlStates {
    typealias ColorType
    var normal: ColorType { get }
    var normalHighlighted: ColorType { get }
    var active: ColorType { get }
    var activeHighlighted: ColorType { get }
    var disabled: ColorType { get }
    var disabledHighlighted: ColorType { get }
    var disabledActive: ColorType { get }
    var disabledActiveHighlighted: ColorType { get }
}

class AppColors {
    struct TextField {
        struct Colors {
            let borderColor: UIColor
            let backgroundColor: UIColor
            let textColor: UIColor
            let placeholderColor: UIColor = grayColor
        }

        let errorColor = redColor

        let normal = Colors(
            borderColor: whiteColor,
            backgroundColor: skyBlueColor,
            textColor: whiteColor
        )

        let normalHighlighted = Colors(
            borderColor: whiteColor,
            backgroundColor: lightedBlueColor,
            textColor: whiteColor
        )

        let active = Colors(
            borderColor: whiteColor,
            backgroundColor: whiteColor,
            textColor: blueColor
        )

        let activeHighlighted = Colors(
            borderColor: whiteColor,
            backgroundColor: grayColor,
            textColor: blueColor
        )

        let disabled = Colors(
            borderColor: grayColor,
            backgroundColor: skyBlueColor,
            textColor: whiteColor
        )
    }
    static let textField = TextField()

    struct Button {
        struct Colors {
            let borderColor: UIColor
            let backgroundColor: UIColor
            let textColor: UIColor
        }

        let normal = Colors(
            borderColor: whiteColor,
            backgroundColor: skyBlueColor,
            textColor: whiteColor
        )

        let normalHighlighted = Colors(
            borderColor: whiteColor,
            backgroundColor: whiteColor,
            textColor: skyBlueColor
        )

        let disabled = Colors(
            borderColor: grayColor,
            backgroundColor: skyBlueColor,
            textColor: grayColor
        )
    }
    static let button = Button()

    struct Screen {
        let backgroundColor = skyBlueColor
    }
    static let screen = Screen()
}


// MARK: -- Helper functions --

private func controlColor<ColorType, Colors: ColoredControlStates where Colors.ColorType == ColorType> (colors: Colors, forState state: UIControlState) -> ColorType {
    switch (state) {
    case UIControlState.Normal:
        return colors.normal
    case UIControlState.Highlighted:
        return colors.normalHighlighted
    case UIControlState.Selected:
        return colors.active
    case .Selected | .Highlighted:
        return colors.activeHighlighted
    case UIControlState.Disabled:
        return colors.disabled
    case .Disabled | .Highlighted:
        return colors.disabledHighlighted
    case .Disabled | .Selected:
        return colors.disabledActive
    case .Disabled | .Selected | .Highlighted:
        return colors.disabledActiveHighlighted
    default:
        assertionFailure("Unsupported combination used")
        return colors.normal
    }
}

extension AppColors.TextField: ColoredControlStates {
    typealias ColorType = Colors
    var disabledHighlighted: Colors { return disabled }
    var disabledActive: Colors { return active }
    var disabledActiveHighlighted: Colors { return active }
}

extension AppColors.TextField {
    func colorForState(state: UIControlState) -> Colors {
        return controlColor(self, forState: state)
    }
}

extension AppColors.Button: ColoredControlStates {
    typealias ColorType = Colors
    var active: Colors { return normal }
    var activeHighlighted: Colors { return normalHighlighted }
    var disabledHighlighted: Colors { return disabled }
    var disabledActive: Colors { return disabled }
    var disabledActiveHighlighted: Colors { return disabled }
}

extension AppColors.Button {
    func colorForState(state: UIControlState) -> Colors {
        return controlColor(self, forState: state)
    }
}

