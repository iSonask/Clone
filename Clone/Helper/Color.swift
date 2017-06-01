//
//  Color.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import UIKit

typealias Color = UIColor

extension UIColor {
    
    /// Init
    ///
    /// - parameter red:     Red value
    /// - parameter green:   Green value
    /// - parameter blue:    Blue value
    /// - parameter opacity: Opacity value
    ///
    /// - returns: UIColor
    convenience init(red: Float, green: Float, blue: Float, opacity: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(opacity >= 0.0 && opacity <= 1.0, "Invalid opacity component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(opacity))
    }
    
    /// Init
    ///
    /// - parameter red:     Red value
    /// - parameter green:   Green value
    /// - parameter blue:    Blue value
    /// - parameter opacity: Opacity value
    ///
    /// - returns: UIColor
    convenience init(red: Float, green: Float, blue: Float) {
        self.init(red : red, green: green, blue: blue, opacity : 1.0)
    }
    
    /// Init
    ///
    /// - parameter hexCode: Color Hexacode
    ///
    /// - returns: UIColor
    convenience init(hexCode: Int) {
        
        let red = Float( (hexCode >> 16) & 0xff )
        let green = Float( (hexCode >> 8) & 0xff )
        let blue = Float( hexCode & 0xff )
        
        self.init(red : red, green: green, blue: blue, opacity : 1.0)
    }
    
    
    /// Init
    ///
    /// - Parameter hexString: Color Hexacode
    convenience init(hexString: String) {
        let hexString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0xff
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask
        
        self.init(red : Float(red), green: Float(green), blue: Float(blue), opacity : 1.0)
    }
    
}

