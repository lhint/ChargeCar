//
//  Host.swift
//  ChargeCar
//
//  Created by Luke Hinton on 12/07/2021.
//

import UIKit
import SVProgressHUD
import Firebase
import MapKit

class Host: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var chargerName: UITextField!
    @IBOutlet weak var chargerLatitude: UITextField!
    @IBOutlet weak var chargerLongitude: UITextField!
    @IBOutlet weak var addChargerButton: UIButton!
    @IBOutlet weak var connector: UITextField!
    @IBOutlet weak var powerKWH: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var free: UISwitch!
    
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    let home = HomeViewController()
    var coordinateLat = 0.0
    var coordinateLong = 0.0
    var chargerValueName = ""
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let titles = ["Type2", "CCS", "CHAdeMO"]
    
    //Data to load on startup
    override func viewDidLoad() {
        SVProgressHUD.dismiss()
        //Constantly scans for changes to enforce validation
        chargerName.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        chargerLatitude.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        chargerLongitude.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        connector.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        powerKWH.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        price.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        
        //Set placeholder values
        self.chargerName.placeholder = Global.shared.returnedChargerName
        self.chargerLatitude.placeholder = String(Global.shared.returnedChargerLat)
        self.chargerLongitude.placeholder = String(Global.shared.returnedChargerLong)
        print("private charger connector: \(Global.shared.userConnector)")
        self.connector.placeholder = String(Global.shared.userConnector)
        self.powerKWH.placeholder = String(Global.shared.userKWH)
        
        print("FREE: \(Global.shared.userFree)")
        if Global.shared.userFree.contains("true") {
            free.isOn = true
        } else {
            free.isOn = false
        }
        
        //Hides keyboard if screen is touched
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        //Default values
        addChargerButton.isUserInteractionEnabled = false
        addChargerButton.backgroundColor = UIColor.gray
        
        //Connection to picker view
        self.connector.inputView = self.pickerView
        self.connector.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        
        //Set toggle on display from value
        if Global.shared.userFree.contains("true") {
            free.isOn = true
            price.isEnabled = false
            price.backgroundColor = .gray
        } else {
            free.isOn = false
            price.isEnabled = true
            price.backgroundColor = .white
        }
        
    }
    
    //Finds current location
    @IBAction func useMyLocation(_ sender: Any) {
        self.chargerLatitude.text = Global.shared.currentLat
        self.chargerLongitude.text = Global.shared.currentLong
    }
    
    //Textfield validation
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
        
        Global.shared.privateChargerName = chargerName.text!
        let chargerLat = chargerLatitude.text ?? ""
        let chargerLong = chargerLongitude.text ?? ""
        self.chargerValueName = chargerName.text!
        self.coordinateLong = Double(chargerLong) ?? 0.0
        self.coordinateLat = Double(chargerLat) ?? 0.0
        Global.shared.privateChargerConnector = connector.text!
        Global.shared.privateChargerKWH = powerKWH.text!
        Global.shared.privateChargerPrice = price.text!
        
        //Save data to database
        self.ref.child("\(Global.shared.userUid)").updateChildValues(["chargername": chargerValueName,"chargerlat": "\(chargerLat)","chargerlong": "\(chargerLong)","chargerconnector": "\(Global.shared.privateChargerConnector)", "chargerpowerkwh": "\(Global.shared.privateChargerKWH)", "price": "\(Global.shared.privateChargerPrice)"])
        
        //UI alert to user
        let alert = UIAlertController(title: "Charger Added!", message: "You can set times for this to be schedualed in your account page by selecting your name from the menu.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "home2", sender: nil)
                
            }))
        present(alert, animated: true)
    }
    
    //Sets free value from database value
    @IBAction func free(_ sender: Any) {
        if free.isOn == true {
            Global.shared.userFree = "true"
            price.isEnabled = false
            price.backgroundColor = .gray
        } else {
            Global.shared.userFree = "false"
            price.isEnabled = true
            price.backgroundColor = .white
        }
        
        //updates the database if the toggle value is changed
        self.ref.child("\(Global.shared.userUid)").updateChildValues(["free": "\(Global.shared.userFree)"])
    }
    
}

//Picker view extension delegates
extension Host: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.titles.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.connector.text = self.titles[row]
    }
}

extension Host: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.connector.text = self.titles[row]
        self.connector.resignFirstResponder()
    }

    func didTapCancel() {
        self.connector.text = nil
        self.connector.resignFirstResponder()
    }
}


