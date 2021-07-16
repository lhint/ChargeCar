//
//  PrivateMapAnnotationData.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/07/2021.
//

import MapKit

class PrivateChargerMap: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let chargerConnector1: String
    let chargerKW1: String
   
    
    init( chargerName: String?,
          coordinate: CLLocationCoordinate2D,
          chargerConnector1: String,
          chargerKW1: String)
          
    {
        self.title = chargerName
        self.coordinate = coordinate
        self.chargerConnector1 = chargerConnector1
        self.chargerKW1 = chargerKW1
     
    }
}
