//
//  SignIn.swift
//  ChargeCar
//
//  Created by Luke Hinton on 30/06/2021.
//

import SwiftUI
import SVProgressHUD

class Login: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    @IBAction func `return`(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
