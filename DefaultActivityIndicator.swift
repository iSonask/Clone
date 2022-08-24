// take a look at this profile projects very handy for MVVM and overall development
// https://github.com/edc0der

import UIKit

fileprivate let overlayViewTag: Int = 999
fileprivate let activityIndicatorViewTag: Int = 1000

// Public interface
extension UIView {
    func showActivity() {
        setActivityIndicatorView()
    }

    func hideActivity() {
        removeActivityIndicatorView()
    }
}

extension UIViewController {
    private var overlayContainerView: UIView {
        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }

    func showLoader() {
        overlayContainerView.showActivity()
    }

    func hideLoader() {
        overlayContainerView.hideActivity()
    }
}

// Private interface
extension UIView {
    private var activityIndicatorView: UIActivityIndicatorView {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        view.transform = CGAffineTransform(scaleX: 3, y: 3)

        view.tag = activityIndicatorViewTag
        return view
    }

    private var overlayView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        view.tag = overlayViewTag
        return view
    }

    private func setActivityIndicatorView() {
        guard !isDisplayingActivityIndicatorOverlay() else { return }
        let overlayView: UIView = self.overlayView
        let activityIndicatorView: UIActivityIndicatorView = self.activityIndicatorView

        //add subviews
        overlayView.addSubview(activityIndicatorView)
        addSubview(overlayView)

        //add overlay constraints
        overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        //add indicator constraints
        activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true

        //animate indicator
        activityIndicatorView.startAnimating()
    }

    private func removeActivityIndicatorView() {
        guard let overlayView: UIView = getOverlayView(), let activityIndicator: UIActivityIndicatorView = getActivityIndicatorView() else {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0.0
            activityIndicator.stopAnimating()
        }) { _ in
            activityIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }

    private func isDisplayingActivityIndicatorOverlay() -> Bool {
        getActivityIndicatorView() != nil && getOverlayView() != nil
    }

    private func getActivityIndicatorView() -> UIActivityIndicatorView? {
        viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView
    }

    private func getOverlayView() -> UIView? {
        viewWithTag(overlayViewTag)
    }
}
