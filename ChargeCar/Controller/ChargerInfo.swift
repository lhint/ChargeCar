//
//  ChargerInfo.swift
//  ChargeCar
//
//  Created by Luke Hinton on 20/06/2021.
//

import UIKit
import SVProgressHUD

class ChargerInfo: UIViewController {
    
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var connector1: UILabel!
    @IBOutlet weak var kw1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var connector2: UILabel!
    @IBOutlet weak var kw2: UILabel!
    @IBOutlet weak var device2Title: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectorLabel: UILabel!
    @IBOutlet weak var kwhLabel: UILabel!
    
    public var name = ""
    public var s1 = 0.0
    public var c1 = 0.0
    public var k1 = 0.0
    public var s2 = 0.0
    public var c2 = 0.0
    public var k2 = 0.0
    
    override func viewDidLoad() {
            
        
        self.title = name
        SVProgressHUD.dismiss()
        showCharger2(k2: k2)
        self.status1.text = checkKey(value: s1)
        self.connector1.text = checkKey(value: c1)
        self.kw1.text = kwCheck(kw: k1)
        self.status2.text = checkKey(value: s2)
        self.connector2.text = checkKey(value: c2)
        self.kw2.text = kwCheck(kw: k2)
        
    }
    
    func showCharger2(k2: Double) {
        if k2 == 1.0 {
            self.device2Title.isHidden = true
            self.statusLabel.isHidden = true
            self.connectorLabel.isHidden = true
            self.kwhLabel.isHidden = true
        }
    }
    
    func checkKey(value: Double) -> String {
        var answer = ""
        if value == 25 {
            answer = "Type 2"
        } else if value == 50 {
            answer = "Operational"
        } else if value == 2 {
            answer = "CHAdeMO"
        } else if value == 1036 {
            answer = "Type2(Tethered)"
        } else if value == 0 {
            answer = "Restricted"
        } else if value == 75 {
            answer = "Partly Operational"
        } else if value == 100 {
            answer = "Not Operational"
        } else if value == 27 {
            answer = "Tesla Supercharger"
        }
        return answer
    }
    
    func kwCheck(kw: Double) -> String {
        
        var answer = ""
        
        if kw > 1.0 {
             let convert = Int(kw)
            answer = String(convert)
        } else if kw == 1.0
        {
            answer = ""
        }
        return answer
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Info", message: "Data maybe incomplete in showing actual number of chargers avilable.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true)
    }
}
