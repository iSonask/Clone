//
//  Text.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit

extension String {
    
    var isValidEmail: Bool {
        
        let emailRegex = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let regexTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let result = regexTest.evaluate(with: self)
        return result
        
    }
    
}

extension UITextField {
    
    func trim() {
        
        if let text = text {
            self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    var isEmpty: Bool {
        
        if let text = text, text.characters.count > 0 {
            return false
        }else{
            return true
        }
        
    }
    
    var hasValidEmail: Bool {
        
        if let text = text{
            return text.isValidEmail
        }else{
            return false
        }
        
    }
    
}

extension UITextView {
    
    func trim() {
        
        if let text = text {
            self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    var isEmpty: Bool {
        
        if let text = text, text.characters.count > 0 {
            return false
        }else{
            return true
        }
        
    }
    
    var hasValidEmail: Bool {
        
        if let text = text{
            return text.isValidEmail
        }else{
            return false
        }
        
    }
    
}
