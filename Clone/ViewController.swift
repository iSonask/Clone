//
//  ViewController.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import UIKit

class ViewController: BaseController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var first: UITextField!
    @IBOutlet var second: UITextField!
    var keyboard = Keyboard()
    var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        keyboard.delegate = self
        keyboard.addInputView(first)
        keyboard.addInputView(second)
        
        let monthYearPickerView = MonthYearPickerView()
        monthYearPickerView.onDateSelected = { month,year  in
            
            let dateFormatter = Utility.dateFormatter
            let dateString = String(format: "%02d/%zd", month,year)
            dateFormatter.dateFormat = "MM/yyyy"
            let date = dateFormatter.date(from: dateString) ?? Date()
            self.first.text = dateFormatter.string(from: date)
            self.second.text = dateFormatter.string(from: date)
//            OperationQueue.main.addOperation({
//                
//                dateFormatter.dateFormat = "MMMM"
//                self.first.text = dateFormatter.string(from: date)
//                
//                dateFormatter.dateFormat = "yyyy"
//                self.second.text = dateFormatter.string(from: date)
//                
//            })
            
        }

        
        first.inputView = monthYearPickerView
        second.inputView = monthYearPickerView
        
        
        
        
    }
    
    func rechability()  {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    func activityOnAnyimageview()  {
        let activityIndicatorView = img.activityIndicatorView
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = UIColor(white: 0.7, alpha: 1)
        img.activityIndicatorView.stopAnimating()
    }
    /// Validate login form
    ///
    /// - Returns: Bool
   /* fileprivate func validateLoginForm() -> Bool {
        
        var inputView: Any?
        var message: String?
        
        txtEmail.trim()
        
        if selectedUniviersity == nil {
            
            inputView = txtUniversity
            message = String(format: localizedString("VALIDATION_RULE_NOT_SELECTED"), localizedString("UNIVERSITY"))
            
        }else if txtEmail.isEmpty {
            
            inputView = txtEmail
            message = String(format: localizedString("VALIDATION_RULE_NOT_EMPTY"), localizedString("EMAIL"))
            
        }else if !txtEmail.hasValidEmail {
            
            inputView = txtEmail
            message = String(format: localizedString("VALIDATION_RULE_NOT_VALID_VALUE"), localizedString("EMAIL") )
            
        }else if txtPassword.isEmpty {
            
            inputView = txtPassword
            message = String(format: localizedString("VALIDATION_RULE_NOT_EMPTY"), localizedString("PASSWORD"))
            
        }else{
            
            inputView = nil
            message = nil
        }
        
        if let message = message {
            
            let alert = UIAlertController(title: localizedString("ERROR"), message: message, preferredStyle: .alert)
            alert.view.tintColor = .primary
            alert.addAction(UIAlertAction(title:localizedString("OK"), style: .cancel, handler: { (action) in
                
                if let textField = inputView as! UITextField? {
                    textField.becomeFirstResponder()
                }
                
            }))
            
            present(alert, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
        
    }
    */
    /// Do login
    fileprivate func doLogin(){
        
//        guard validateLoginForm() else {
//            return
//        }
        
        view.endEditing(true)
        
//        if let progressHud = progressHud {
//            progressHud.label.text = localizedString("HUD_LOGIN")
//            progressHud.show(animated: true)
//        }
            self.showActivityIndicator()
        
        let parameters: APIParameters = [
            "user_email" : ""
        ]
        
        API.post(.login, parameters: parameters, additionalHeaders: nil, onSuccess: { (status, message, data) in
            
            if status == .success, let user = User(JSON: data){
                print(user)
//                var courses: [UserCourse] = []
//                if let coursesJSON = data["my_course"] as? [ [String : String] ] {
//                    for courseJSON in coursesJSON{
//                        if let course = UserCourse(JSON: courseJSON){
//                            courses.append(course)
//                        }
//                    }
//                }
//                
//                self.courses.removeAll()
//                self.courses.append(contentsOf: courses)

            }else{
                
                OperationQueue.main.addOperation({
                    self.hideActivity()
                    
                    let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
                    alert.view.tintColor = UIColor(white: 0.6, alpha: 0.6)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                })
                
            }
            
            //            print("data :\(data)");
        }) { (error) in
            //            print("error \(error)");
            
            OperationQueue.main.addOperation({
                self.hideActivity()
                let alert = UIAlertController(title: "ERROR", message: "ERROR_PROCCESS_REQUEST", preferredStyle: .alert)
                alert.view.tintColor = UIColor(white: 0.6, alpha: 0.6)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                }))
                alert.addAction(UIAlertAction(title: "RETRY", style: .default, handler: { (action) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            })
            
        }
        
    }
    
}
extension ViewController: KeyboardDelegate {
    
    func keyboard(_ keyboard: Keyboard, willShow notification: KeyboardNotification) {
        
        if let scrollView = scrollView {
            let contentInset = UIEdgeInsetsMake(0.0, 0.0, notification.frameEnd.height, 0.0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect = view.frame
            aRect.size.height -= notification.frameEnd.height
            
            if let inputView = keyboard.activeField {
                
                let frame = inputView.convert(inputView.frame, from: scrollView)
                if !aRect.contains(frame) {
                    scrollView.scrollRectToVisible(frame, animated: true)
                }
                
            }
        }
        
    }
    
    func keyboard(_ keyboard: Keyboard, willHide notification: KeyboardNotification) {
        if let scrollView = scrollView {
            let contentInset = UIEdgeInsets.zero
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    func keyboard(_ keyboard: Keyboard, didHide notification: KeyboardNotification) {
        if let scrollView = scrollView {
            let contentInset = UIEdgeInsets.zero
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
}
