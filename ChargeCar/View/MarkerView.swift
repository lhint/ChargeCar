//
//  MarkerView.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/03/2021.
//

import MapKit

class MarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            if (newValue as? Charger) != nil {
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .infoLight)
            } else if (newValue as? PrivateChargerMap != nil) {
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .infoLight)
                markerTintColor = UIColor.blue
            } else {
                return
            }
            
        }
    }
}
