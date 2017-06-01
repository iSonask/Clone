//
//  Keyboard.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import UIKit


/// Wrapper for the Notification userInfo values associated with a keyboard notification.
///
/// It provides properties that retrieve userInfo dictionary values with these keys:
///
/// - UIKeyboardFrameBeginUserInfoKey
/// - UIKeyboardFrameEndUserInfoKey
/// - UIKeyboardAnimationDurationUserInfoKey
/// - UIKeyboardAnimationCurveUserInfoKey
public class KeyboardNotification: NSObject {
    
    let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    /// Start frame of the keyboard in screen coordinates
    public var frameBegin: CGRect {
        
        if let rect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            return rect
        }
        
        return .zero
    }
    
    /// End frame of the keyboard in screen coordinates
    public var frameEnd: CGRect {
        
        if let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            return rect
        }
        
        return .zero
        
    }
    
    /// Keyboard animation duration
    public var animationDuration: Double {
        
        if let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        {
            return duration
        }
        
        return 0.25
        
    }
    
    /// Keyboard animation curve
    ///
    /// Note that the value returned by this method may not correspond to a
    /// UIViewAnimationCurve enum value.  For example, in iOS 7 and iOS 8,
    /// this returns the value 7.
    public var animationCurve: Int {
        if let number = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            return number.intValue
        }
        return UIViewAnimationCurve.easeInOut.rawValue
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// :param: view UIView to whose coordinate system the frame will be converted
    /// :returns: frame rectangle in view's coordinate system
    public func frameBeginForView(view: UIView) -> CGRect {
        return view.convert(frameBegin, from: view.window)
    }
    
    /// End frame of the keyboard in coordinates of specified view
    ///
    /// :param: view UIView to whose coordinate system the frame will be converted
    /// :returns: frame rectangle in view's coordinate system
    public func frameEndForView(view: UIView) -> CGRect {
        return view.convert(frameEnd, from: view.window)
    }
    
}

@objc public protocol KeyboardDelegate: NSObjectProtocol{
    
    @objc optional func keyboard(_ keyboard: Keyboard, willShow notification: KeyboardNotification)
    
    @objc optional func keyboard(_ keyboard: Keyboard, willHide notification: KeyboardNotification)
    
    @objc optional func keyboard(_ keyboard: Keyboard, didHide notification: KeyboardNotification)
    
    @objc optional func keyboard(_ keyboard: Keyboard, willChangeFrame notification: KeyboardNotification)
    
}

public class Keyboard: NSObject {
    
    public var delegate: KeyboardDelegate?
    
    public var activeField: UIView?{
        get{
            return self.currentField
        }
    }
    
    private var inputViews: [UIView] = []
    var currentField: UIView?{
        didSet{ configureButtons() }
    }
    
    public var currentFieldIndex: Int?{
        get{
            
            if let currentField = self.currentField{
                return inputViews.index(of: currentField)
            }
            
            return NSNotFound
        }
    }
    
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        toolbar.barStyle = .default
        return toolbar
    }()
    
    private let previousButton: UIBarButtonItem = {
        let previousButton = UIBarButtonItem(title: "Prev", style: .plain, target: nil, action: nil)
        previousButton.tintColor = .black
        return previousButton
    }()
    
    private let nextButton: UIBarButtonItem = {
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
        nextButton.tintColor = .black
        return nextButton
    }()
    
    private let doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        doneButton.tintColor = .black
        return doneButton
    }()
    
    // MARK: - Initilization
    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        
        previousButton.target = self
        previousButton.action = #selector(previousButtonTapped)
        
        nextButton.target = self
        nextButton.action = #selector(nextButtonTapped)
        
        doneButton.target = self
        doneButton.action = #selector(doneButtonTapped)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [previousButton,nextButton,spaceItem,doneButton]
        
        // Add notification observer
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        center.addObserver(self, selector: #selector(inputViewDidStartEditing(_:)), name: .UITextFieldTextDidBeginEditing, object: nil)
        center.addObserver(self, selector: #selector(inputViewDidStartEditing(_:)), name: .UITextViewTextDidBeginEditing, object: nil)
        
    }
    
    deinit {
        
        // Remove notification observer
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // MARK: - Notification Observer
    
    func orientationChanged(_ notification: Notification){
        
        //        let device = UIDevice.current
        //        let isLandscape = UIDeviceOrientationIsLandscape(device.orientation)
        let width = UIScreen.main.bounds.size.width
        //isLandscape ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
        
        //        print("device.orientation :: \(isLandscape ? "Landscape" : "Potrait") bounds :: \(UIScreen.main.bounds) \n andwidth :: \(width)")
        
        var frame: CGRect = toolbar.frame
        frame.size.width = width
        toolbar.frame = frame
        
    }
    
    func keyboardWillShow(_ notification: Notification){
        let keyboardNotification = KeyboardNotification(notification: notification)
        delegate?.keyboard?(self, willShow: keyboardNotification)
    }
    
    func keyboardWillHide(_ notification: Notification){
        let keyboardNotification = KeyboardNotification(notification: notification)
        delegate?.keyboard?(self, willHide: keyboardNotification)
    }
    
    func keyboardDidHide(_ notification: Notification){
        let keyboardNotification = KeyboardNotification(notification: notification)
        delegate?.keyboard?(self, didHide: keyboardNotification)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification){
        let keyboardNotification = KeyboardNotification(notification: notification)
        delegate?.keyboard?(self, willChangeFrame: keyboardNotification)
    }
    
    func inputViewDidStartEditing(_ notification: Notification){
        
        if let object = notification.object as? UIView, inputViews.contains(object){
            
            //        }//let index = inputViews.index(of: object), index != NSNotFound{
            currentField = object
            //            let index = inputViews.index(of: object)
            //            print("index ::\(index)")
        }else{
            
        }
        
    }
    
    // MARK: - Actions
    
    func previousButtonTapped() {
        moveToPreviousInputField()
    }
    
    func nextButtonTapped() {
        moveToNextInputField()
    }
    
    func doneButtonTapped() {
        doneEditing()
    }
    
    // MARK: - Private Methods
    
    private func makeActiveInputField(inputField: UIView?){
        
        if let textField = inputField as? UITextField {
            textField.becomeFirstResponder()
            currentField = textField
        }else if let textView = inputField as? UITextView {
            textView.becomeFirstResponder()
            currentField = textView
        }else{
            
        }
        
    }
    
    private func configureButtons(){
        
        if let index = currentFieldIndex,index != NSNotFound {
            
            if previousInputField(fromIndex: index) != nil{
                previousButton.isEnabled = true
            }else{
                previousButton.isEnabled = false
            }
            
            if nextInputField(fromIndex: index) != nil{
                nextButton.isEnabled = true
            }else{
                nextButton.isEnabled = false
            }
            
        }else{
            previousButton.isEnabled = false
            nextButton.isEnabled = false
        }
        
    }
    
    private func previousInputField(fromIndex index: Int) -> UIView?{
        
        guard index > 0 || index == NSNotFound else {
            return nil
        }
        
        for i in (0..<index).reversed() {
            
            if let textField = inputViews[i] as? UITextField, textField.isEnabled{
                return textField
            }else if let textView = inputViews[i] as? UITextView, textView.isEditable{
                return textView
            }else{
                
            }
            
        }
        
        return nil
    }
    
    private func nextInputField(fromIndex index: Int) -> UIView?{
        
        guard index < inputViews.count - 1 || index == NSNotFound else {
            return nil
        }
        
        for i in (index+1)..<inputViews.count {
            
            if let textField = inputViews[i] as? UITextField, textField.isEnabled{
                return textField;
            }else if let textView = inputViews[i] as? UITextView, textView.isEditable{
                return textView;
            }else{
                
            }
            
        }
        
        return nil
    }
    
    // MARK: - Public Methods
    
    public func addInputView(_ inputView: UIView?) {
        
        if let textField = inputView as? UITextField {
            
            textField.inputAccessoryView = toolbar
            inputViews.append(textField)
            
        }else if let textView = inputView as? UITextView {
            
            textView.inputAccessoryView = toolbar
            inputViews.append(textView)
            
        }else{
            
        }
        
    }
    
    public func removeInputView(_ inputView: UIView?) {
        if let view = inputView, let index = inputViews.index(of: view), index != NSNotFound  {
            inputViews.remove(at: index)
        }
    }
    
    public func moveToPreviousInputField(){
        
        if let index = currentFieldIndex, let inputField = previousInputField(fromIndex: index){
            makeActiveInputField(inputField: inputField)
        }
        
    }
    
    public func moveToNextInputField(){
        
        if let index = currentFieldIndex, let inputField = nextInputField(fromIndex: index){
            makeActiveInputField(inputField: inputField)
        }
        
    }
    
    public func doneEditing(){
        
        if let currentField = currentField, currentField.responds(to: #selector(UIResponder.resignFirstResponder)){
            currentField.perform(#selector(UIResponder.resignFirstResponder))
        }
        
    }
    
}
