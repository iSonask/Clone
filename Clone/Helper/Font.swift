//
//  Font.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit


typealias Font = UIFont

extension Font {
    
    fileprivate static func font(named name: String, size: Float) -> UIFont{
        return UIFont(name: name, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
    }
    
    static func latoBold(size: Float) -> UIFont {
        return font(named: "Lato-Bold", size: size)
    }
    
    static func latoRegular(size: Float) -> UIFont {
        return font(named: "Lato-Regular", size: size)
    }
    
    static func latoLight(size: Float) -> UIFont {
        return font(named: "Lato-Light", size: size)
    }
    
    static func latoLightItalic(size: Float) -> UIFont {
        return font(named: "Lato-LightItalic", size: size)
    }
    
}

