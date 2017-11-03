//
//  BaseController.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import UIKit

class BaseController: UIViewController {
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    func menuButtonDidTouchDown(_ sender: Any) {
//        slideMenuController()?.toggleLeft()
    }
    
    func backButtonDidTouchDown(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Override
extension BaseController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    func configureNavigationBar() {
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red: 108, green: 98, blue: 94)
        navigationBar?.tintColor = .white
        navigationBar?.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.systemFont(ofSize: 15)
        ]
        
        if navigationController?.viewControllers.first == self {
            let menuButton = UIBarButtonItem(image: UIImage(named: "IconMenu"), style: .plain, target: self, action: #selector(menuButtonDidTouchDown(_:)))
            navigationItem.leftBarButtonItem = menuButton
        }else{
            let backButton = UIBarButtonItem(image: UIImage(named: "IconBackArrow"), style: .plain, target: self, action: #selector(backButtonDidTouchDown(_:)))
            navigationItem.leftBarButtonItem = backButton
        }
        
    }
}
var activity = UIActivityIndicatorView()

// MARK: - MBProgressHUD + UIViewController
extension UIViewController{
    
    
     func showActivityIndicator() {
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        activity.transform = transform
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.color = .black
        view.addSubview(activity)
        activity.startAnimating()
    }
    
     func hideActivity(){
        activity.stopAnimating()
    }
}


// MARK: - UIAlertController
extension UIAlertController {
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
}











open class ContainerController: UIViewController {
    /// currentViewController
    open private(set) var currentViewController: UIViewController?
    
    //MARK: Initializers
    required public init(viewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        currentViewController = viewController
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: UIViewController
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return currentViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    
    override open var prefersStatusBarHidden : Bool {
        return currentViewController?.prefersStatusBarHidden ?? false
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentViewController = currentViewController {
            addChildViewController(currentViewController)
            view.addSubview(currentViewController.view)
            currentViewController.didMove(toParentViewController: self)
        }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let currentViewController = currentViewController {
            currentViewController.view.frame = view.bounds
        }
    }
    
    open func show(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let oldViewController = currentViewController
        oldViewController?.willMove(toParentViewController: nil)
        addChildViewController(viewController)
        self.currentViewController = nil // Prevent frame changing in viewWillLayoutSubviews
        
        // Add new view controller's view
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.transform = viewController.view.transform.concatenating(CGAffineTransform(translationX: 0, y: view.frame.size.height))
        
        // The transition
        UIView.animate(withDuration: animated ? 0.6 : 0.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.curveLinear, animations: {
            // Update status bar
            self.setNeedsStatusBarAppearanceUpdate()
            
            if let oldViewController = oldViewController {
                oldViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            viewController.view.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            oldViewController?.removeFromParentViewController()
            viewController.didMove(toParentViewController: self)
            completion?()
            self.currentViewController = viewController
        })
    }
}

/// MARK: UIViewController - return current container view controller
public extension UIViewController {
    weak var containerViewController : ContainerController? {
        get {
            var viewController : UIViewController?
            viewController = self
            
            while viewController != nil {
                if let containerViewController = viewController?.parent as? ContainerController {
                    return containerViewController
                }
                else {
                    viewController = viewController?.parent
                }
            }
            
            return nil
        }
    }
}

//USAGE - containerViewController.show





extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}











//FOR GOOGLE SIGN IN AND FACEBOOK SIGNIN

//AppDelegate     
//GIDSignInDelegate
func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        if (GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: sourceApplication, annotation: annotation))
        {
            return true
        }
        else if (SDKApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation))
        {
            return true
        }
        return false
    }

public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            print(email!,userId!,idToken!,fullName!,givenName!,familyName!,user.profile.imageURL(withDimension: 500))
            
            let root = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signupV = mainStoryboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            signupV.stremail = email!
            signupV.strFirstname = fullName!
            
            root.pushViewController(signupV, animated: true)


        } else {
            print("\(error.localizedDescription)")
        }
    }
//LOGIN
GIDSignIn.sharedInstance().uiDelegate = self//View didload

//on googlebutton click
GIDSignIn.sharedInstance().signIn()
//onfacebook login click
let loginManager = LoginManager()
        print("LOGIN MANAGER: \(loginManager)")
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            print("LOGIN RESULT! \(loginResult)")
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                self.getFBUserData()
            }
        }


fileprivate func  getFBUserData(){
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start({ (connection, result) -> Void in
                print(result)
                switch result {
                case .failed(let error):
                    // Handle the result's error
                    print(error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        // Do something with your responseDictionary
                        print(responseDictionary)
                        print("email ============ ",responseDictionary["email"] as! String)
                        print(responseDictionary["picture"] as Any )
                        
                        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vcontroller = main.instantiateViewController(withIdentifier: Constant.signup) as! SignupVC
                        vcontroller.strFirstname = (responseDictionary["name"] as? String)!
                        vcontroller.stremail = (responseDictionary["email"] as? String)!
                        self.navigationController?.pushViewController(viewController: vcontroller, completion: {})
                        
                    }
                }
                
            })
        }
    }

//google signin delegate

extension LoginVC: GIDSignInUIDelegate{
    
    internal func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    internal func sign(_ signIn: GIDSignIn!,
                       present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    internal func sign(_ signIn: GIDSignIn!,
                       dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//for signout
 GIDSignIn.sharedInstance().signOut()
 let login = LoginManager()//fb
 login.logOut()
