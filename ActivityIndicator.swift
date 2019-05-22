import UIKit

import NVActivityIndicatorView


class ViewController: UIViewController {
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 60),
                                                        type: NVActivityIndicatorType.ballPulse)
    let window = (UIApplication.shared.delegate as? AppDelegate)?.window
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func show(_ sender: Any) {
        activityIndicatorView.color = .black
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        OperationQueue.main.addOperation {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    @IBAction func hide(_ sender: Any) {
        OperationQueue.main.addOperation {
            self.activityIndicatorView.stopAnimating()
        }
    }
}

