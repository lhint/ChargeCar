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
    //var pinColor: UIColor
    
    init( chargerName: String?,
          coordinate: CLLocationCoordinate2D)
          //pinColor: UIColor)
    {
        self.title = chargerName
        self.coordinate = coordinate
        //self.pinColor = pinColor
    }
}
