//
//  ViewController.swift
//  CommunityOfNerds
//
//  Created by iFlame on 6/30/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignIn: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UsernameTextField.layer.cornerRadius = 5.0
        UsernameTextField.layer.masksToBounds = true
        PasswordTextField.layer.cornerRadius = 5.0
        PasswordTextField.layer.masksToBounds = true
        SignIn.layer.cornerRadius = 5.0
        SignIn.layer.masksToBounds = true
        SignUp.layer.cornerRadius = 5.0
        SignUp.layer.masksToBounds = true
        
        UsernameTextField.text = "captain@america.com"
        PasswordTextField.text = "123456"
        
        let pastelView = InstagramGradiant(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPoint = .bottomLeft
        pastelView.endPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors(colors: [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                      UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                      UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                      UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    @IBAction func SignIn(_ sender: Any) {
        if !UsernameTextField.text!.isEmail(){
            alert(message: "Please Enter Valid Email")
        } else if PasswordTextField.text!.isEmpty{
            alert(message: "Please enter password")
        } else{
            print("valid")
            showActivityIndicator()
            Auth.auth().signIn(withEmail: UsernameTextField.text!, password: PasswordTextField.text!) { (user, error) in
                
                guard (user?.user) != nil else {
                    print("something went wrong")
                    self.alert(message: error!.localizedDescription)
                    return
                }
                Constants.refs.databaseRoot.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    self.hideActivity()
                    guard let data = snapshot.value as? [String:String] else {
                        print("no value")
                        return
                    }
                    print(data)
                    let userName = data["firstname"]! + data["lastname"]!
                    let defaults = UserDefaults.standard
                    defaults.set(userName, forKey: "jsq_name")
                    defaults.set(Auth.auth().currentUser!.uid, forKey: "jsq_id")
                    defaults.synchronize()
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController")
                    self.navigationController?.pushViewController(controller!, animated: true)
                })

            }
        }
    }
    
    func alert(message: String)  {
        let alert = UIAlertController(title: "Error", message:message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(controller!, animated: true)
    }
    
}


extension String {
    func isEmail() -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}


public class InstagramGradiant: UIView {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    public enum Point {
        case left
        case top
        case right
        case bottom
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case custom(position: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .left: return CGPoint(x: 0.0, y: 0.5)
            case .top: return CGPoint(x: 0.5, y: 0.0)
            case .right: return CGPoint(x: 1.0, y: 0.5)
            case .bottom: return CGPoint(x: 0.5, y: 1.0)
            case .topLeft: return CGPoint(x: 0.0, y: 0.0)
            case .topRight: return CGPoint(x: 1.0, y: 0.0)
            case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
            case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
            case .custom(let point):
                return point
            }
        }
    }
    
    // Custom Direction
    open var startPoint: Point = .topRight
    open var endPoint: Point = .bottomLeft
    
    // Custom Duration
    open var animationDuration: TimeInterval = 5.0
    
    fileprivate let gradient = CAGradientLayer()
    private var currentGradient: Int = 0
    private var colors: [UIColor] = [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                     UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                     UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                     UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                     UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                     UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                     UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    public func startAnimation() {
        gradient.removeAllAnimations()
        setup()
        animateGradient()
    }
    
    fileprivate func setup() {
        gradient.frame = bounds
        gradient.colors = currentGradientSet()
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.drawsAsynchronously = true
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func currentGradientSet() -> [CGColor] {
        guard colors.count > 0 else { return [] }
        return [colors[currentGradient % colors.count].cgColor,
                colors[(currentGradient + 1) % colors.count].cgColor]
    }
    
    public func setColors(colors: [UIColor]) {
        guard colors.count > 0 else { return }
        self.colors = colors
    }
    
    public func addColor(color: UIColor) {
        self.colors.append(color)
    }
    
    func animateGradient() {
        currentGradient += 1
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.toValue = currentGradientSet()
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        gradient.add(animation, forKey: Animation.key)
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
}

extension InstagramGradiant: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = currentGradientSet()
            animateGradient()
        }
    }
}
