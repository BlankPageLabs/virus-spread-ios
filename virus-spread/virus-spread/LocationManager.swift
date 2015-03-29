//
//  LocationManager.swift
//  velo
//
//  Created by Илья Михальцов on 17.10.14.
//  Copyright (c) 2014 CommonSense Projects. All rights reserved.
//

import UIKit
import CoreLocation


enum CurrentLocation {
    case GpsBasedLocation(coordinate: CLLocationCoordinate2D, accuracy: CLLocationAccuracy)
    case LastKnownLocation(coordinate: CLLocationCoordinate2D)
    case None

    var coordinate: CLLocationCoordinate2D? {
        switch(self) {
        case .GpsBasedLocation(let coord, _):
            return coord
        case .LastKnownLocation(let coord):
            return coord
        default:
            return nil
        }
    }
}


public class LocationManager: NSObject, CLLocationManagerDelegate {

    var location: CurrentLocation = .None {
        didSet {
            self.locationChangeObservable.fire(from: self)
        }
    }

    let locationChangeObservable = Observable(LocationManager)

    private let locationManager = CLLocationManager()

    private var inBackground = UIApplication.sharedApplication().applicationState == .Background;

    override init () {
        super.init()

        observe(AppDelegate.instance.backgroundObservable, observer: self) { o, i in o.didEnterBackground() }
        observe(AppDelegate.instance.foregroundObservable, observer: self) { o, i in o.willEnterForeground() }

        self.configureCoreLocation()

        if !inBackground || self.locationManager.location == nil {
            self.startMonitoringIfPermitted()
        }
    }

    private func configureCoreLocation () {
        // Configure manager
        self.locationManager.activityType = .Fitness
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 10 // 10 meters
        self.locationManager.delegate = self
        if let location = self.locationManager.location {
            self.location = .GpsBasedLocation(coordinate: location.coordinate, accuracy: location.horizontalAccuracy)
        }

        // Ask user for permissions, if not yet
        self.locationManager.requestWhenInUseAuthorization()
    }

    private func startMonitoringIfPermitted () {
        if contains([.AuthorizedAlways, .AuthorizedWhenInUse], CLLocationManager.authorizationStatus()) {
            self.startMonitoring()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    private func startMonitoring () {
        self.locationManager.startUpdatingHeading()
        self.locationManager.startUpdatingLocation()
    }

    private func stopMonitoring () {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }

    func didEnterBackground() {
        self.inBackground = true
        if self.locationManager.location != nil {
            self.stopMonitoring()
        }
    }

    func willEnterForeground() {
        self.inBackground = false
        self.startMonitoringIfPermitted()
    }

    // CLLocationManagerDelegate

    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.startMonitoringIfPermitted()
    }


    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let lastLocation = locations.last as? CLLocation {
            self.location = .GpsBasedLocation(coordinate: lastLocation.coordinate, accuracy: lastLocation.horizontalAccuracy)
            if self.inBackground {
                self.stopMonitoring()
            }
        }
    }

    public func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Location failure: %@, %@", error, error.userInfo!)
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
    }
    
    
}
