//
//  BarButtonBadge.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit

fileprivate var keyBadgeString: String = "badgeString"
fileprivate var keyBadgeEdgeInsets: String = "badgeEdgeInsets"
fileprivate var keyBadgeFont: String = "badgeFont"
fileprivate var keyBadgeBackgroundColor: String = "badgeBackgroundColor"
fileprivate var keyBadgeTextColor: String = "badgeTextColor"
fileprivate var keyBadgeLabel: String = "badgeLabel"

extension UIBarButtonItem {
    
    private var badgeLabel: UILabel? {
        if let label = objc_getAssociatedObject(self, &keyBadgeLabel) as! UILabel?{
            return label
        } else {
            return nil
        }
    }
    
    open var badgeString: String? {
        get{
            if let str = objc_getAssociatedObject(self, &keyBadgeString) as! String?{
                return str
            }else{
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &keyBadgeString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadge()
        }
    }
    
    open var badgeEdgeInsets: UIEdgeInsets {
        get{
            if let inset = objc_getAssociatedObject(self, &keyBadgeEdgeInsets) as! UIEdgeInsets?{
                return inset
            }else{
                return UIEdgeInsets.zero
            }
        }
        set{
            objc_setAssociatedObject(self, &keyBadgeEdgeInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadge()
        }
    }
    
    open var badgeFont: UIFont {
        get{
            if let font = objc_getAssociatedObject(self, &keyBadgeFont) as! UIFont?{
                return font
            }else{
                return UIFont.systemFont(ofSize: 15)
            }
        }
        set{
            objc_setAssociatedObject(self, &keyBadgeFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadge()
        }
    }
    
    open var badgeBackgroundColor: UIColor {
        get{
            if let color = objc_getAssociatedObject(self, &keyBadgeBackgroundColor) as! UIColor?{
                return color
            }else{
                return UIColor.red
            }
        }
        set{
            objc_setAssociatedObject(self, &keyBadgeBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadge()
        }
    }
    
    open var badgeTextColor: UIColor {
        get{
            if let color = objc_getAssociatedObject(self, &keyBadgeTextColor) as! UIColor?{
                return color
            }else{
                return UIColor.white
            }
        }
        set{
            objc_setAssociatedObject(self, &keyBadgeTextColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadge()
        }
    }
    
    fileprivate func setupBadge() {
        
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        if badgeLabel == nil {
            let label = UILabel()
            objc_setAssociatedObject(self, &keyBadgeLabel, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if let badgeLabel = badgeLabel{
            
            badgeLabel.clipsToBounds = true
            badgeLabel.text = badgeString
            badgeLabel.font = badgeFont
            badgeLabel.textAlignment = .center
            badgeLabel.sizeToFit()
            let badgeSize = badgeLabel.frame.size
            
            let height = max(18, Double(badgeSize.height) + 3.0)
            let width = max(height, Double(badgeSize.width) + 3.0)
            
            var vertical: Double?, horizontal: Double?
            let badgeInset = self.badgeEdgeInsets
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(view.bounds.size.width) - 15 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 5 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            
            setupBadgeStyle()
            view.addSubview(badgeLabel)
            
            if let text = badgeString {
                badgeLabel.isHidden = text != "" ? false : true
                
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = 1.5
                animation.toValue = 1
                animation.duration = 0.2
                animation.timingFunction = CAMediaTimingFunction(controlPoints: 4, 1.3, 1, 1)
                badgeLabel.layer.add(animation, forKey: "bounceAnimation")
            } else {
                badgeLabel.isHidden = true
            }
        }else{
            
        }
    }
    
    fileprivate func setupBadgeStyle() {
        
        if let badgeLabel = badgeLabel{
            
            badgeLabel.textAlignment = .center
            badgeLabel.backgroundColor = badgeBackgroundColor
            badgeLabel.textColor = badgeTextColor
            badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
            
        }
        
    }
    
}

