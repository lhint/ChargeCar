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
                let pinImage = UIImage(named: "PublicAnnotation")
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                image = resizedImage
            } else if (newValue as? PrivateChargerMap != nil) {
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .infoLight)
                let pinImage = UIImage(named: "HomeAnnotation")
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                image = resizedImage
            } else {
                return
            }
            
        }
    }
}
