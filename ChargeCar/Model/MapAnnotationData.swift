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
    let chargerStatus1: Int
    let chargerStatus2: Int
    let chargerConnector1: Int
    let chargerConnector2: Int
    let chargerKW1: Int
    let chargerKW2: Int
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D,
        chargerStatus1: Int,
        chargerStatus2: Int,
        chargerConnector1: Int,
        chargerConnector2: Int,
        chargerKW1: Int,
        chargerKW2: Int)
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
