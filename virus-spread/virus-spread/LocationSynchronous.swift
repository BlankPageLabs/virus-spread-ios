//
//  LocationSynchronous.swift
//  virus-spread
//
//  Created by Илья Михальцов on 28.3.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

import Foundation
import CoreLocation

@objc
public class LocationHelper {
    @objc
    static func locationSynchronous(manager: LocationManager) -> CLLocationCoordinate2D {
        let dummy = NSObject()
        let condition = NSCondition()
        var location = manager.location
        var hasLocation = false
        switch (location) {
        case let .GpsBasedLocation(coordinate, _):
            return coordinate
        default:
            condition.lock()
            observe(manager.locationChangeObservable, observer: dummy) { o,i in
                condition.lock()
                hasLocation = true
                condition.signal()
                condition.unlock()
            }
            while !hasLocation {
                condition.wait()
            }
            condition.unlock()
            switch (location) {
            case let .GpsBasedLocation(coordinate, _):
                return coordinate
            default:
                NSLog("Cannot get location")
                abort()
            }
        }
    }
}
