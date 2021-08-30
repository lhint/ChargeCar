//
//  MarkerView.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/03/2021.
//

import MapKit

class MarkerView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            if (newValue as? Charger) != nil {
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .infoLight)
                let pinImage = UIImage(named: "publicannotation50")
                image = pinImage
            } else if (newValue as? PrivateChargerMap != nil) {
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .infoLight)
                let pinImage = UIImage(named: "privateannotation50")
                image = pinImage
            } else {
                return
            }
            
        }
    }
}
