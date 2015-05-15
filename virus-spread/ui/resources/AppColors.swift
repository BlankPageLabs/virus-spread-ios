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

class AppColors {
    struct TextField {
        struct Colors {
            let borderColor: UIColor
            let backgroundColor: UIColor
            let textColor: UIColor
            let placeholderColor: UIColor = grayColor
        }

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

    struct Screen {
        let backgroundColor = skyBlueColor
    }
    static let screen = Screen()
}

extension AppColors.TextField {
    func colorForState(state: UIControlState) -> Colors {
        switch (state) {
        case UIControlState.Normal:
            return normal
        case UIControlState.Normal | UIControlState.Highlighted:
            return normalHighlighted
        case UIControlState.Selected:
            return active
        case UIControlState.Selected | UIControlState.Highlighted:
            return activeHighlighted
        case UIControlState.Disabled:
            fallthrough
        case UIControlState.Disabled | UIControlState.Highlighted:
            return disabled
        default:
            return normal
        }
    }
}

