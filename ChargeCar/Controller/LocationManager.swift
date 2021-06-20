//
//  LocationManager.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import Foundation
import CoreLocation

public class GetLocation: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var locationCallback: ((CLLocation?) -> Void)!
    var locationServicesEnabled = false
    var didFailWithError: Error?
    
    public func run(callback: @escaping (CLLocation?) -> Void) {
        locationCallback = callback
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled { manager.startUpdatingLocation() }
        else { locationCallback(nil) }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        locationCallback(locations.last!)
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError = error
        locationCallback(nil)
        manager.stopUpdatingLocation()
    }
    
    deinit {
        manager.stopUpdatingLocation()
    }
}

//Class found at: https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
