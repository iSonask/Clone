//
//  Uitility.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import Foundation

class Utility: NSObject {
    
    class var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
    
    class var currencyFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"
        numberFormatter.currencyCode = "$"
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
    
}
