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

        let active = Colors(
            borderColor: whiteColor,
            backgroundColor: whiteColor,
            textColor: blueColor
        )
    }
    static let textField = TextField()

    struct Screen {
        let backgroundColor = skyBlueColor
    }
    static let screen = Screen()
}
