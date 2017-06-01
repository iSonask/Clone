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

