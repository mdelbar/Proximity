//
//  LocationController.swift
//  Proximity
//
//  Created by Matthias Delbar on 25/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override init() {
        locationManager = CLLocationManager()
    }
    
    func startTrackingLocation() {
        logger.debug("Starting to track location")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 25
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        logger.debug("Location manager status: [\(CLLocationManager.authorizationStatus().toRaw())]")
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    
    // We received updated location info
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        logger.debug("Updated locations: [\(locations)]")
        NSNotificationCenter.defaultCenter().postNotificationName("MyLocationUpdated", object: nil, userInfo: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        logger.error("Location manager failed: [\(error.localizedDescription)]")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        logger.debug("New location!")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        logger.debug("Auth status changed: [\(status.toRaw())]")
        
        switch status {
            case CLAuthorizationStatus.Restricted:
                logger.debug("Restricted Access to location")
            case CLAuthorizationStatus.Denied:
                logger.debug("User denied access to location")
            case CLAuthorizationStatus.NotDetermined:
                logger.debug("Status not determined")
            default:
                logger.debug("Allowed to location Access")
        }
    }
}