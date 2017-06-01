//
//  FormTextField.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit

@IBDesignable
class FormTextField: UITextField {
    
    fileprivate let placeHolderLabel: UILabel = UILabel()
    
    fileprivate var placeHolderHeight: CGFloat {
        return placeHolderLabel.font!.lineHeight + 5
    }
    
    override var textAlignment: NSTextAlignment {
        didSet{
            placeHolderLabel.textAlignment = textAlignment
        }
    }
    
    override var text: String? {
        didSet{
            layoutPlaceHolderLabel()
        }
    }
    
    @IBInspectable override var placeholder: String? {
        get{
            return placeHolderLabel.text
        }
        set{
            placeHolderLabel.text = newValue
        }
    }
    
    var placeHolderColor: UIColor = .gray {
        didSet{
            placeHolderLabel.textColor = placeHolderColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        
        borderStyle = .none
        tintColor = UIColor.black
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 15)
        
        // Place holder label
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.textAlignment  = textAlignment
        placeHolderLabel.textColor  = placeHolderColor
        addSubview(placeHolderLabel)
        
        var heightConstraint: NSLayoutConstraint?
        
        for constraint in constraints {
            if constraint.firstAttribute == .height {
                heightConstraint = constraint
                heightConstraint?.constant = 50
            }
        }
        
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
            addConstraint(heightConstraint!)
        }
        
        
        //        drawBottomLine()
        layoutPlaceHolderLabel()
        
        // Add observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: .UITextFieldTextDidBeginEditing, object: nil)
        notificationCenter.addObserver(self, selector: #selector(textFieldDidEndEditing), name: .UITextFieldTextDidEndEditing, object: nil)
        
    }
    
    deinit {
        
        // Remove observer
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // MARK: - override methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.y += placeHolderHeight
        rect.size.height -= placeHolderHeight
        rect.origin.x += 8
        rect.size.width -= 8
        
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.y += placeHolderHeight
        rect.size.height -= placeHolderHeight
        rect.origin.x += 8
        rect.size.width -= 8
        
        return rect
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: frame.size.height - 22 - 5, width: 22, height: 22)
        return rect
    }
    
    // MARK: - Notification observer
    
    func textFieldDidBeginEditing() {
        layoutPlaceHolderLabel()
    }
    
    func textFieldDidEndEditing() {
        layoutPlaceHolderLabel()
    }
    
    // MARK: - private methods
    
    fileprivate func layoutPlaceHolderLabel() {
        
        placeHolderLabel.alpha = 0
        
        placeHolderLabel.removeFromSuperview()
        addSubview(placeHolderLabel)
        
        if isEditing || text!.characters.count > 0 {
            
            placeHolderLabel.font = UIFont.systemFont(ofSize: 15)
            
            var leftMargin: CGFloat = 8
            var rightMargin: CGFloat = 8
            
            if let leftView = leftView{
                leftMargin += leftView.frame.size.width
            }
            
            if let rightView = rightView{
                rightMargin += rightView.frame.size.width
            }
            
            let metrics: [String : Any] = [
                "leftMargin" : leftMargin,
                "rightMargin" : rightMargin,
                "lineHeight" : placeHolderHeight,
                ]
            
            let views: [String : Any] = [
                "placeHolderLabel" : placeHolderLabel
            ]
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[placeHolderLabel]-rightMargin-|", options: [], metrics: metrics, views: views))
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==5)-[placeHolderLabel(lineHeight)]-(>=5)-|", options: [], metrics: metrics, views: views))
            layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.placeHolderLabel.alpha = 1
            })
            
        }else {
            
            placeHolderLabel.font = font
            
            var leftMargin: CGFloat = 8
            var rightMargin: CGFloat = 8
            
            if let leftView = leftView{
                leftMargin += leftView.frame.size.width
            }
            
            if let rightView = rightView{
                rightMargin += rightView.frame.size.width
            }
            
            let metrics: [String : Any] = [
                "leftMargin" : leftMargin,
                "rightMargin" : rightMargin,
                "lineHeight" : placeHolderHeight,
                ]
            
            let views: [String : Any] = [
                "placeHolderLabel" : placeHolderLabel
            ]
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[placeHolderLabel]-rightMargin-|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=5)-[placeHolderLabel(lineHeight)]-(==5)-|", options: [], metrics: metrics, views: views))
            
            layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.placeHolderLabel.alpha = 1
            })
            
        }
        
    }
    
}

// MARK: - public methods

extension FormTextField{
    
    func drawWhiteBottomLine(){
        
        var attributes: [String : Any] = [:]
        
        if let leftView = leftView {
            attributes[UIViewBorderAttributeKey.marginLeft] = (leftView.frame.size.width + 5)
        }
        drawBottomBorder(width: 1, color: .white, attributes: attributes)
    }
    
    func drawGrayBottomLine(){
        
        var attributes: [String : Any] = [:]
        textColor = UIColor.black
        placeHolderColor = UIColor.darkGray
        if let leftView = leftView {
            attributes[UIViewBorderAttributeKey.marginLeft] = (leftView.frame.size.width + 5)
        }
        drawBottomBorder(width: 1, color: UIColor.gray, attributes: attributes)
    }
    
    func setRightImage(_ image: UIImage){
        
        let imgView = UIImageView(image: image)
        imgView.contentMode = .center
        
        rightView = imgView
        rightViewMode = .always
        
        drawGrayBottomLine()
        layoutPlaceHolderLabel()
    }
}














