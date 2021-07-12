//
//  Host.swift
//  ChargeCar
//
//  Created by Luke Hinton on 12/07/2021.
//

import UIKit
import SVProgressHUD
import Firebase

class Host: UIViewController {
    
    @IBOutlet weak var chargerName: UITextField!
    @IBOutlet weak var chargerLatitude: UITextField!
    @IBOutlet weak var chargerLongitude: UITextField!
    @IBOutlet weak var addChargerButton: UIButton!
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    
    
    override func viewDidLoad() {
        SVProgressHUD.dismiss()
        chargerName.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        chargerLatitude.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        chargerLongitude.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func useMyLocation(_ sender: Any) {
        
    }
    
    @objc func validation() {
        
        if chargerName.text == "" || chargerLatitude.text == "" || chargerLongitude.text == "" {
            addChargerButton.isUserInteractionEnabled = false
            addChargerButton.backgroundColor = UIColor.gray
        } else {
            addChargerButton.isUserInteractionEnabled = true
            addChargerButton.backgroundColor = UIColor.systemGreen
        }
        
    }
    
    //Add Charger Button
    @IBAction func addCharger(_ sender: Any) {
        
        let chargerName = chargerName.text ?? ""
        let chargerLat = chargerLatitude.text ?? ""
        let chargerLong = chargerLongitude.text ?? ""
        
        self.ref.child("\(Global.shared.userUid)").updateChildValues(["chargername": "\(chargerName)","chargerlat": "\(chargerLong)","chargerlong": "\(chargerLat)"])
    }
}


