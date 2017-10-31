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
