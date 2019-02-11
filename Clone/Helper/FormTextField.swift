//
//  FormTextField.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit

import UIKit

struct FormTextFieldConfiguration {
    
    public let hightlightColor: UIColor =  UIColor(red: 208.0/255.0, green: 2.0/255.0, blue: 205.0/255.0, alpha: 1.00)
    public let barDefaultColor: UIColor = .darkGray
    public let animationDuration: TimeInterval = 0.2
    public let textFieldHeight: CGFloat = 40.0
    public let textFieldFont: UIFont = UIFont.systemFont(ofSize: 18.0)
    public let minimizedPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 10.0)
}

class FormTextField: UITextField {
    
    private struct Constant {
        static let defaultBottomLineHeight: CGFloat = 1.0
        static let highlightedBottomLineHeight: CGFloat = 1.0
    }
    
    private var _configuration: FormTextFieldConfiguration?
    public var configuration: FormTextFieldConfiguration! {
        set {
            _configuration = newValue
        }
        get {
            return _configuration ?? FormTextFieldConfiguration()
        }
    }
    
    private let bottomLine = UIView()
    private var bottomLineHeightConstraint: NSLayoutConstraint?
    private let minimizedPlaceholderLabel = UILabel()
    

    init(configuration: FormTextFieldConfiguration) {
        
        super.init(frame: .zero)
        
        self.configuration = configuration
        
        setupInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupInterface()
    }
    
    override var intrinsicContentSize: CGSize {
        
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width, height: configuration.textFieldHeight)
    }

    // MARK: - Interface
    
    private func setupInterface() {
        
        delegate = self
        
        font = configuration.textFieldFont
        borderStyle = .none
        
        // bottom line
        
        bottomLine.backgroundColor = configuration.barDefaultColor
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        
        bottomLineHeightConstraint = bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        bottomLineHeightConstraint?.isActive = true
        
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // placeholder
        
        minimizedPlaceholderLabel.font = configuration.minimizedPlaceholderFont
        minimizedPlaceholderLabel.textColor = configuration.hightlightColor
        minimizedPlaceholderLabel.backgroundColor = .clear
        minimizedPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - PlaceholderLabel animations
    
    // MARK: Bottom line
    
    private func highlightBottomLine() {
        
        layoutIfNeeded()
        
        UIView.animate(withDuration: configuration.animationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bottomLine.backgroundColor = strongSelf.configuration.hightlightColor
            strongSelf.bottomLineHeightConstraint?.constant = Constant.defaultBottomLineHeight
            strongSelf.layoutIfNeeded()
        }
    }
    
    private func resetBottomLine() {
        
        UIView.animate(withDuration: configuration.animationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bottomLine.backgroundColor = strongSelf.configuration.barDefaultColor
            strongSelf.bottomLineHeightConstraint?.constant = Constant.defaultBottomLineHeight
        }
    }
    
    // MARK: Minimized placeholder
    
    private func showMinimizedPlaceholderAnimation() {
        
        minimizedPlaceholderLabel.text = placeholder?.uppercased()
        addSubview(minimizedPlaceholderLabel)
        
        let topConstraint = minimizedPlaceholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0)
        topConstraint.isActive = true
        
        minimizedPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        minimizedPlaceholderLabel.alpha = 0.3
        
        layoutIfNeeded()
        
        UIView.animate(withDuration: configuration.animationDuration) { [weak self] in
            self?.minimizedPlaceholderLabel.alpha = 1.0
            topConstraint.constant = -5.0
            self?.layoutIfNeeded()
        }
    }
    
    private func hideMinimizedPlaceholderAnimation() {
        
        UIView.animate(withDuration: configuration.animationDuration, animations: { [weak self] in
            self?.minimizedPlaceholderLabel.alpha = 0.0
        }) { [weak self] isFinished in
            guard true == isFinished else { return }
            self?.minimizedPlaceholderLabel.removeFromSuperview()
        }
    }
}

extension FormTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        
        if currentText.isEmpty {
            showMinimizedPlaceholderAnimation()
        } else if currentText.count == 1 && string.isEmpty {
            hideMinimizedPlaceholderAnimation()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        highlightBottomLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        resetBottomLine()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        hideMinimizedPlaceholderAnimation()
        return true
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














