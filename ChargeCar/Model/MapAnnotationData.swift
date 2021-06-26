//
//  MapAnnotationData.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/03/2021.
//

import MapKit

class Charger: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let chargerStatus1: Double
    let chargerStatus2: Double
    let chargerConnector1: Double
    let chargerConnector2: Double
    let chargerKW1: Double
    let chargerKW2: Double
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D,
        chargerStatus1: Double,
        chargerStatus2: Double,
        chargerConnector1: Double,
        chargerConnector2: Double,
        chargerKW1: Double,
        chargerKW2: Double)
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.chargerStatus1 = chargerStatus1
        self.chargerStatus2 = chargerStatus2
        self.chargerConnector1 = chargerConnector1
        self.chargerConnector2 = chargerConnector2
        self.chargerKW1 = chargerKW1
        self.chargerKW2 = chargerKW2
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
