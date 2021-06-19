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
    
    init(
       title: String?,
       locationName: String?,
       coordinate: CLLocationCoordinate2D
     ) {
       self.title = title
       self.locationName = locationName
       self.coordinate = coordinate

       super.init()
     }

     var subtitle: String? {
       return locationName
     }
}
