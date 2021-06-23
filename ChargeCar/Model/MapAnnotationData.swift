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
    let chargerStatus: Int
    let chargerConnector: Int
    let chargerKW: Int
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D,
        chargerStatus: Int,
        chargerConnector: Int,
        chargerKW: Int)
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.chargerStatus = chargerStatus
        self.chargerConnector = chargerConnector
        self.chargerKW = chargerKW
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
