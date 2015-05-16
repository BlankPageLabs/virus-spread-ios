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
