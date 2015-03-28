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

    override init () {
        super.init()

        observe(AppDelegate.instance.backgroundObservable, observer: self) { o, i in o.didEnterBackground() }
        observe(AppDelegate.instance.foregroundObservable, observer: self) { o, i in o.willEnterForeground() }

        self.configureCoreLocation()

        self.startMonitoringIfPermitted()
    }

    private func configureCoreLocation () {
        // Configure manager
        self.locationManager.activityType = .Fitness
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self

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
        self.stopMonitoring()
    }

    func willEnterForeground() {
        self.startMonitoringIfPermitted()
    }

    // CLLocationManagerDelegate

    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.startMonitoringIfPermitted()
    }


    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let lastLocation = locations.last as? CLLocation {
            self.location = .GpsBasedLocation(coordinate: lastLocation.coordinate, accuracy: lastLocation.horizontalAccuracy)
        }
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
    }
    
    
}