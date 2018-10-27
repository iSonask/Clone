//
//  SignUpViewController.swift
//  CommunityOfNerds
//
//  Created by iFlame on 7/2/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController,GIDSignInUIDelegate {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        GIDSignIn.sharedInstance().uiDelegate = self//View didload
        

        let pastelView = InstagramGradiant(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPoint = .bottomLeft
        pastelView.endPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors(colors: [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                      UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                      UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                      UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewUserData(_:)), name: Notification.Name("newUserData"), object: nil)

    }

    @objc func handleNewUserData(_ notification: Notification)  {
        guard let data = notification.userInfo as? [String:String] else {
            return
        }
        emailTextField.text = data["email"]
        firstNameTextField.text = data["fullname"]
    }
    
    func setupUI()  {
        firstNameTextField.layer.cornerRadius = 5.0
        firstNameTextField.layer.masksToBounds = true
        
        lastNameTextField.layer.cornerRadius = 5.0
        lastNameTextField.layer.masksToBounds = true
        
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.masksToBounds = true
        
        signupButton.layer.cornerRadius = 5.0
        signupButton.layer.masksToBounds = true
        
    }
    
    
    func alert(message: String)  {
        let alert = UIAlertController(title: "Error", message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func googleButtonAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        print("LOGIN MANAGER: \(loginManager)")
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            print("LOGIN RESULT! \(loginResult)")
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                self.getFBUserData()
            }}
    }
    
    fileprivate func  getFBUserData(){
        if((AccessToken.current) != nil){

            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start({ (connection, result) -> Void in
                print(result)
                switch result {
                case .failed(let error):
                    // Handle the result's error
                    print(error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        // Do something with your responseDictionary
                        print(responseDictionary)
                        print("email ============ ",responseDictionary["email"] as! String)
                        print(responseDictionary["picture"] as Any )
                        self.firstNameTextField.text = responseDictionary["first_name"] as? String
                        self.lastNameTextField.text = responseDictionary["last_name"] as? String
                        self.emailTextField.text = responseDictionary["email"] as? String
                    }
                }

            })
        }
    }
    

    @IBAction func signupButtonAction(_ sender: Any) {
        if firstNameTextField.text!.isEmpty{
            alert(message: "Please Enter First Name")
        } else if lastNameTextField.text!.isEmpty{
            alert(message: "Please Enter Last Name")
        }else if !emailTextField.text!.isEmail(){
            alert(message: "Please Enter Valid Email ")
        }else if passwordTextField.text!.isEmpty{
            alert(message: "Please Enter Password")
        }else if passwordTextField.text!.count <= 5{
            alert(message: "Please Enter Atleast 6 Digit Password ")
        } else{
            showActivityIndicator()
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.alert(message: error.localizedDescription)
                }
                else {
                    print("User signed in!")
                    self.hideActivity()
                    Constants.refs.databaseRoot.updateChildValues(["\(Auth.auth().currentUser!.uid)":["firstname":"\(self.firstNameTextField.text!)","lastname":"\(self.lastNameTextField.text!)","email":"\(self.emailTextField.text!)"]])
                    
                    let alert = UIAlertController(title: "", message:"Thank you fo register please sign in to continue", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                        self.navigationController?.popViewController(animated: true)

                    }))
                    
                    self.present(alert, animated: true)

                    
                    //At this point, the user will be taken to the next screen
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

}
