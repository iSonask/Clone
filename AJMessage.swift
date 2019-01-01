

import UIKit

public struct AJMessageConfig {
    
    public static var shared = AJMessageConfig()
    
    public var titleFont : UIFont = UIFont.boldSystemFont(ofSize: 15)
    public var titleColor : UIColor = .white
    public var messageColor : UIColor = .white
    public var messageFont : UIFont = UIFont.systemFont(ofSize: 14)
    
}




public extension UIDevice {
    
    static var isIphoneX: Bool {
        var modelIdentifier = ""
        if isSimulator {
            modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        } else {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            modelIdentifier = String(cString: machine)
        }
        
        return modelIdentifier == "iPhone10,3" || modelIdentifier == "iPhone10,6"
    }
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}



public class AJMessage: UIView {
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // Drawing code
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8,height: 8))
        mainShape.frame = rect
        mainShape.path = path.cgPath
        mainShape.shadowColor = UIColor.black.cgColor
        mainShape.shadowOffset = CGSize(width: 1, height: 1)
        mainShape.shadowRadius = 15
        mainShape.shadowOpacity = 0.4
    }
    
    public enum Status {
        case error
        case info
        case success
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    public typealias AJcompleteHandler = () -> Void
    
    private var message = UILabel()
    private var title = UILabel()
    private var action : AJcompleteHandler? = nil
    private var mainView = UIView()
    private var mainShape = CAShapeLayer()
    private var duration : Double?
    private var position : Position = .top
    private var iconView : UIImageView!
    private var timer : Timer? = nil
    private(set) var status : Status = .error
    private(set) var config : AJMessageConfig!
    
    init(title : String,message : String,duration: Double?, position: Position , status:Status ,config:AJMessageConfig) {
        let width = UIApplication.shared.keyWindow!.bounds.width - 16;
        
        var saveTop : CGFloat = 24
        if UIDevice.isIphoneX, #available(iOS 11.0, *) {
            saveTop = UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        
        super.init(frame: CGRect(x: 8, y: saveTop , width: width, height: 10))
        self.config = config
        self.title.text = title
        self.message.text = message
        self.status = status
        self.duration = duration
        self.position = position
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        mainView.backgroundColor = UIColor.clear
        mainView.layer.addSublayer(mainShape)
        
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 20, width: 30, height: 30)
        
        title.frame = CGRect(x: 46, y: 16, width: mainView.bounds.width - 16 , height: 1)
        title.numberOfLines = 0
        title.font = config.titleFont
        title.textColor = config.titleColor
        
        message.frame = CGRect(x: title.frame.minX, y: title.frame.maxY, width: mainView.bounds.width - 16 , height: 1)
        message.numberOfLines = 0
        message.font = config.messageFont
        message.textColor = config.messageColor
        
        addSubview(mainView)
        mainView.addSubview(iconView)
        mainView.addSubview(message)
        mainView.addSubview(title)
        
        let bundle = Bundle(for: type(of: self))
        let url = bundle.resourceURL!.appendingPathComponent("AJMessage.bundle")
        let resourceBundle = Bundle(url: url)
        
        switch status {
        case .info:
            mainShape.fillColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(15.0/255.0), alpha: 1).cgColor
            iconView.image = UIImage(named: "info", in: resourceBundle, compatibleWith: nil)
        case .error:
            mainShape.fillColor = UIColor(red: CGFloat(231.0/255.0), green: CGFloat(76.0/255.0), blue: CGFloat(60.0/255.0), alpha: 1).cgColor
            iconView.image = UIImage(named: "error", in: resourceBundle, compatibleWith: nil)
        case .success:
            mainShape.fillColor = UIColor(red: CGFloat(46.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1).cgColor
            iconView.image = UIImage(named: "success", in: resourceBundle, compatibleWith: nil)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideMessages))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.onMoving(pan:)))
        addGestureRecognizer(pan)
        
        if let duration = duration {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideMessages), userInfo: nil, repeats: false)
        }
        
        //remove all current messages
        for vim in UIApplication.shared.keyWindow!.subviews {
            if let msg = vim as? AJMessage {
                msg.hideMessages()
            }
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.alpha = 0.1
        self.transform = CGAffineTransform(scaleX: 3, y: 3)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.transform = .identity
        }) { (B) in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut,.beginFromCurrentState], animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: { (B) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = .identity
                })
            })
        }
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    func updateFrame(){
        let sizeT = title.sizeThatFits(CGSize(width: mainView.bounds.width - 62, height: CGFloat.greatestFiniteMagnitude))
        title.frame.size.height = sizeT.height
        let sizeM = message.sizeThatFits(CGSize(width: mainView.bounds.width - 62, height: CGFloat.greatestFiniteMagnitude))
        message.frame.origin.y = title.frame.maxY + 4
        message.frame.size.height = sizeM.height
        self.frame.size.height = message.frame.maxY + 16
        
        if position == .bottom {
            var saveBottom : CGFloat = 16
            if UIDevice.isIphoneX, #available(iOS 11.0, *) {
                saveBottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            }
            self.frame.origin.y = UIApplication.shared.keyWindow!.bounds.height - saveBottom - self.frame.size.height
        }
    }
    
    @objc func hideMessages(){
        
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve ,.curveEaseInOut,.beginFromCurrentState]
            , animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (B) in
            self.removeFromSuperview()
            self.action?()
        }
        
    }
    
    @objc func onMoving(pan: UIPanGestureRecognizer){
        //        let velo = pan.velocity(in: UIApplication.shared.keyWindow!)
        let point = pan.translation(in: UIApplication.shared.keyWindow!)
        
        if pan.state == .began {
            timer?.invalidate()
        }else if pan.state == .changed {
            let alpha = min(1 - (point.x/150.0),1 - (point.y/150.0))
            
            self.alpha = alpha
            self.transform = CGAffineTransform(translationX: point.x, y: point.y)
            if alpha <= 0 {
                self.removeFromSuperview()
            }
            
        }else if pan.state == .ended {
            self.alpha = 1
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = .identity
            })
            
            if let duration = duration {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideMessages), userInfo: nil, repeats: false)
            }
        }
    }
    
    public func onHide(_ sender : @escaping AJcompleteHandler){
        action = sender
    }
    
    /// show AJMessage Nb:duration = nil to infinite, default is 3
    ///
    /// - Parameters:
    ///   - title: String of title
    ///   - message: String of message
    ///   - duration: Optional duration, default value is 3.0
    ///   - position: Optional Position, default value is .top
    ///   - status: Optional status, default value is .success
    ///   - config: Optional config, default is using AJMessageConfig.shared
    /// - Returns: AJMessage for chaining function like onhide
    @discardableResult public static func show(title : String,message : String,duration: Double? = 3.0 , position: Position = .top,status : Status = .success ,config:AJMessageConfig = AJMessageConfig.shared) -> AJMessage {
        let msg = AJMessage(title: title, message: message, duration: duration, position: position, status: status, config:config)
        return msg
    }
    
    /** hide all AJMessage class */
    public static func hide(){
        for vim in UIApplication.shared.keyWindow!.subviews {
            if let msg = vim as? AJMessage {
                msg.hideMessages()
            }
        }
    }
    
}
