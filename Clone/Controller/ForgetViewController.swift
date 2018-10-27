//
//  ForgetViewController.swift
//  CommunityOfNerds
//
//  Created by iFlame on 7/2/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI()  {
        emailTextField.layer.cornerRadius = 20.0
        emailTextField.layer.masksToBounds = true
        
        submitButton.layer.cornerRadius = 20.0
        submitButton.layer.masksToBounds = true

    }
    
    
    @IBAction func submitButttonAction(_ sender: Any) {
        if !emailTextField.text!.isEmail(){
            alert(message: "Please Enter Valid Email")
        } else{
            print("valid")
        }
    }
    func alert(message: String)  {
        let alert = UIAlertController(title: "Error", message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
