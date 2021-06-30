//
//  register.swift
//  
//
//  Created by Luke Hinton on 29/06/2021.
//

import SwiftUI
import SVProgressHUD

class Register: UIViewController {
    
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
