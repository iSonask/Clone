//
//  Notification.swift
//  Emeralds Bazar
//
//  Created by Akash on 08/06/17.
//  Copyright © 2017 Emeralds Bazar. All rights reserved.
//

import UIKit
import AudioToolbox

public class LNRNotification: NSObject {
    
    /**
     *  The title of this notification
     */
    public var title: String
    
    /**
     *  The body of this notification
     */
    public var body: String?
    
    /**
     *  The duration of the displayed notification. If it is 0.0 duration will default to the default notification display time
     */
    public var duration: TimeInterval
    
    /**
     *  An optional callback to be triggered whan a notification is tapped in addition to dismissing the notification.
     */
    public var onTap: LNRNotificationOperationCompletionBlock?
    
    /**
     *  An optional callback to be triggered whan a notification times out without being tapped.
     */
    public var onTimeout: LNRNotificationOperationCompletionBlock?
    
    /** Initializer for a LNRNotification. this library.
     *  @param title The title of the notification view
     *  @param body The body of the notification view (optional)
     *  @param duration The duration this notification should be displayed (optional)
     *  @param onTap The block that should be executed when the user taps on the notification
     *  @param onTimeout A block that should be executed when the notification times out. If the notification duration is set to endless (-1) this block will never be called.
     */
    public init(title: String, body: String?, duration: TimeInterval = LNRNotificationDuration.default.rawValue, onTap: LNRNotificationOperationCompletionBlock? = nil, onTimeout: LNRNotificationOperationCompletionBlock? = nil) {
        self.title = title
        self.body = body
        self.duration = duration
        self.onTap = onTap
        self.onTimeout = onTimeout
    }
}






public typealias LNRNotificationOperationCompletionBlock = (Void) -> Void

let kLNRNotificationAnimationDuration = 0.3

/**
 *  Define whether a notification view should be displayed at the top of the screen or the bottom of the screen
 */
public enum LNRNotificationPosition {
    case top //Default position
    case bottom
}

/**
 *  Enum values can be passed to the duration parameter using syntax 'LNRNotificationDuration.Automatic.rawValue()'
 */
public enum LNRNotificationDuration: TimeInterval {
    case `default` = 3.0 // Default is 3 seconds.
    case endless = -1.0 // Notification is displayed until it is dismissed by calling dismissActiveNotification
}

public class LNRNotificationManager: NSObject {
    
    /** Shows a notification
     *  @param title The title of the notification view
     *  @param body The text that is displayed underneath the title
     *  @param onTap The block that should be executed when the user taps on the notification
     */
    public func showNotification(notification: LNRNotification) {
        DispatchQueue.main.async {
            if self.isNotificationActive {
                let _ = self.dismissActiveNotification(completion: { () -> Void in
                    self.showNotification(notification: notification)
                })
            } else {
                let notificationView = LNRNotificationView(notification: notification, icon: self.notificationsIcon, notificationManager: self)
                self.displayNotificationView(notificationView: notificationView)
            }
        }
    }
    
    /** Dismisses the currently displayed notificationView with a completion block called after the notification disappears off screen
     *  @param completion The block that should be executed when the notification finishes dismissing
     *  @return true if notification dismissal was triggered, false if no notification was currently displayed.
     */
    public func dismissActiveNotification(completion: LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if isNotificationActive {
            return self.dismissNotificationView(notificationView: self.activeNotification!, dismissAnimationCompletion: { () -> Void in
                self.activeNotification = nil
                if completion != nil {
                    completion!()
                }
            })
        }
        
        return false
    }
    
    /** Dismisses the notificationView passed as an argument
     *  @param dismissAnimationCompletion The block that should be executed when the notification finishes dismissing
     *  @return true if notification dismissal was triggered, false if notification was not currently displayed.
     */
    public func dismissNotificationView(notificationView: LNRNotificationView, dismissAnimationCompletion:LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if notificationView.isDisplayed {
            var offScreenPoint: CGPoint
            
            if notificationsPosition != LNRNotificationPosition.bottom {
                offScreenPoint = CGPoint(x: notificationView.center.x, y: -(notificationView.frame.height / 2.0))
            } else {
                offScreenPoint = CGPoint(x: notificationView.center.x, y: (UIScreen.main.bounds.size.height + notificationView.frame.height / 2.0))
            }
            
            UIView.animate(withDuration: kLNRNotificationAnimationDuration, animations: { () -> Void in
                notificationView.center = offScreenPoint
            })
            
            // Using a dispatch_after block to perform tasks after animation completion tasks because UIView's animateWithDuration:animations:completion: completion callback gets called immediatly due to the dismissNotificationView:dismissAnimationCompletion: method being called from within a dispatch_after block.
            let delayTime = DispatchTime.now() + Double(Int64(kLNRNotificationAnimationDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                
                notificationView.removeFromSuperview()
                notificationView.isDisplayed = false
                
                if self.activeNotification == notificationView {
                    self.activeNotification = nil
                }
                
                if dismissAnimationCompletion != nil {
                    dismissAnimationCompletion!()
                }
            })
            
            return true
        }
        
        return false
    }
    
    /**
     *  Indicates whether a notification is currently active.
     *
     *  @return true if a notification is being displayed
     */
    public var isNotificationActive: Bool {
        return (self.activeNotification != nil)
    }
    
    /**
     *  The active notification, if there is one. nil if no notification is currently active.
     */
    public var activeNotification: LNRNotificationView?
    
    // MARK: Notification Styling
    
    /**
     *  Use to set the background color of notifications.
     */
    public var notificationsBackgroundColor: UIColor = UIColor.white
    
    /**
     *  Use to set the title text color of notifications
     */
    public var notificationsTitleTextColor: UIColor = UIColor.black
    
    /**
     *  Use to set the body text color of notifications.
     */
    public var notificationsBodyTextColor: UIColor = UIColor.black
    
    /**
     *  Use to set the title font of notifications.
     */
    public var notificationsTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 14.0)
    
    /**
     *  Use to set the body font of notifications.
     */
    public var notificationsBodyFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    
    /**
     *  Use to set the bottom/top seperator color.
     */
    public var notificationsSeperatorColor: UIColor = UIColor.clear
    
    /**
     *  Use to set the icon displayed with notifications.
     */
    public var notificationsIcon: UIImage?
    
    /**
     *  Use to set the position of notifications on screen.
     */
    public var notificationsPosition: LNRNotificationPosition = LNRNotificationPosition.top
    
    /**
     *  Use to set the system sound played when a a notification is displayed.
     */
    public var notificationSound: SystemSoundID?
    
    // MARK: Internal
    
    private func displayNotificationView(notificationView: LNRNotificationView) {
        
        self.activeNotification = notificationView
        
        notificationView.isDisplayed = true
        
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(notificationView)
        
        var toPoint: CGPoint
        
        if notificationsPosition != LNRNotificationPosition.bottom {
            toPoint = CGPoint(x: notificationView.center.x, y: notificationView.frame.height / 2.0)
        } else {
            let y: CGFloat = UIScreen.main.bounds.size.height - (notificationView.frame.height / 2.0)
            toPoint = CGPoint(x: notificationView.center.x, y: y)
        }
        
        if let notificationSound = notificationSound {
            AudioServicesPlayAlertSound(notificationSound)
        }
        
        UIView.animate(withDuration: kLNRNotificationAnimationDuration + 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
            notificationView.center = toPoint
        }, completion: nil)
        
        if notificationView.notification.duration != LNRNotificationDuration.endless.rawValue {
            let notificationDisplayTime = notificationView.notification.duration > 0 ? notificationView.notification.duration : LNRNotificationDuration.default.rawValue
            let delayTime = DispatchTime.now() + Double(Int64(notificationDisplayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                let dismissed = self.dismissNotificationView(notificationView: notificationView, dismissAnimationCompletion: nil)
                if dismissed {
                    if let onTimeout = notificationView.notification.onTimeout {
                        onTimeout()
                    }
                }
            })
        }
        
    }
    
}









public class LNRNotificationQueue: NSObject {
    
    fileprivate let notificationManager: LNRNotificationManager!
    
    /**
     *  Initializes a LNRNotificationQueue
     *
     *  @param notificationManager The LNRNotificationManager that will be used to display queued messages. You should not trigger notifications from this Notification Manager anywhere else in your app.
     */
    public init(notificationManager: LNRNotificationManager) {
        self.notificationManager = notificationManager
    }
    
    /**
     *  Queues a notification to be displayed.
     */
    public func queueNotification(notification: LNRNotification) {
        if notificationManager.isNotificationActive {
            notificationQueue.append(notification)
        } else {
            queueLock.lock()
            notificationQueue.append(notification)
            queueLock.unlock()
            showNextQueuedNotification()
        }
    }
    
    fileprivate func showNextQueuedNotification() {
        queueLock.lock()
        if let nextNotification = notificationQueue.first {
            notificationQueue.removeFirst()
            let optionalProvidedOnTap = nextNotification.onTap
            let optionalProvidedOnTimeout = nextNotification.onTimeout
            nextNotification.onTap = { [unowned self] () -> Void in
                if let providedOnTap = optionalProvidedOnTap {
                    providedOnTap()
                }
                self.showNextQueuedNotification()
            }
            nextNotification.onTimeout = { [unowned self] () -> Void in
                if let providedOnTimeout = optionalProvidedOnTimeout {
                    providedOnTimeout()
                }
                self.showNextQueuedNotification()
            }
            notificationManager.showNotification(notification: nextNotification)
        }
        
        queueLock.unlock()
    }
    
    fileprivate var notificationQueue = [LNRNotification]()
    fileprivate let queueLock = NSLock()
    
}









let kLNRNotificationViewMinimumPadding: CGFloat = 15.0
let kStatusBarHeight: CGFloat = 20.0
let kBodyLabelTopPadding: CGFloat = 5.0

public class LNRNotificationView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: Public
    
    /**
     *  Set to YES by the Notification manager while the notification view is onscreen
     */
    public var isDisplayed: Bool = false
    
    /**
     *  The LNRNotification this LNRNotificationView represents
     */
    public var notification: LNRNotification
    
    /** Inits the notification view. Do not call this from outside this library.
     *
     *  @param notification The LNRNotification object this LRNNotificationView represents
     *  @param dismissingEnabled Should this notification be dismissed when the user taps/swipes it?
     */
    init(notification: LNRNotification, icon: UIImage?, notificationManager: LNRNotificationManager) {
        
        self.notification = notification
        self.notificationManager = notificationManager
        
        let notificationWidth: CGFloat = (UIApplication.shared.keyWindow?.bounds.width)!
        let padding: CGFloat = kLNRNotificationViewMinimumPadding
        
        super.init(frame: CGRect.zero)
        
        // Set background color
        self.backgroundColor = notificationManager.notificationsBackgroundColor
        
        // Set up Title label
        self.titleLabel.text = notification.title
        self.titleLabel.textColor = notificationManager.notificationsTitleTextColor
        self.titleLabel.font = notificationManager.notificationsTitleFont
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.addSubview(self.titleLabel)
        
        if let bodyText = notification.body {
            if bodyText.characters.count > 0 {
                self.bodyLabel.text = bodyText
                self.bodyLabel.textColor = notificationManager.notificationsBodyTextColor
                self.bodyLabel.font = notificationManager.notificationsBodyFont
                self.bodyLabel.backgroundColor = UIColor.clear
                self.bodyLabel.numberOfLines = 0
                self.bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.addSubview(self.bodyLabel)
            }
        }
        
        if let icon = icon {
            self.iconImageView.image = icon
            self.iconImageView.frame = CGRect(x: 0, y: 0, width: icon.size.width, height: icon.size.height)
            self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
            self.iconImageView.clipsToBounds = true
            self.addSubview(self.iconImageView)
        }
        
        self.seperator.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: notificationWidth, height: (1.0)) //Set seperator position at the top of the notification view. If notification position is Top we'll update it when we layout subviews.
        self.seperator.backgroundColor = notificationManager.notificationsSeperatorColor
        self.seperator.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.addSubview(self.seperator)
        
        let notificationHeight:CGFloat = self.notificationViewHeightAfterLayoutOutSubviews(padding, notificationWidth: notificationWidth)
        var topPosition:CGFloat = -notificationHeight;
        
        if notificationManager.notificationsPosition == LNRNotificationPosition.bottom {
            topPosition = UIScreen.main.bounds.size.height
        }
        
        self.frame = CGRect(x: CGFloat(0.0), y: topPosition, width: notificationWidth, height: notificationHeight)
        
        if notificationManager.notificationsPosition == LNRNotificationPosition.top {
            self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        } else {
            self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        }
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LNRNotificationView.handleTap(tapGestureRecognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /**
     * Required initializer 'init(coder:)' must be implemented by subclasses of UIView
     */
    required public init?(coder decoder: NSCoder) {
        assertionFailure("Cannot initialize LNRNotificationView with init:decoder")
        self.notification = LNRNotification(title: "", body: nil, onTap: nil, onTimeout: nil)
        super.init(coder: decoder)
    }
    
    /**
     *  Dismisses this notification if this notification is currently displayed.
     *  @param completion A block called after the completion of the dismiss animation. This block is only called if the notification was displayed on screen at the time dismissWithCompletion: was called.
     *  @return true if notification was displayed at the time dismissWithCompletion: was called, false if notification was not displayed.
     */
    public func dismissWithCompletion(_ completion: LNRNotificationOperationCompletionBlock?) -> Bool {
        return notificationManager.dismissNotificationView(notificationView: self, dismissAnimationCompletion: completion)
    }
    
    //MARK: Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let _ = self.notificationViewHeightAfterLayoutOutSubviews(kLNRNotificationViewMinimumPadding, notificationWidth: (UIApplication.shared.keyWindow?.bounds.width)!)
    }
    
    func notificationViewHeightAfterLayoutOutSubviews(_ padding: CGFloat, notificationWidth: CGFloat) -> CGFloat {
        
        var height: CGFloat = 0.0
        
        var textLabelsXPosition: CGFloat = 2.0 * padding
        let statusBarVisible = !UIApplication.shared.isStatusBarHidden
        let topPadding = self.notificationManager.notificationsPosition == LNRNotificationPosition.top && statusBarVisible ? kStatusBarHeight + padding : padding
        
        if let image = self.iconImageView.image {
            textLabelsXPosition += image.size.width
        }
        
        self.titleLabel.frame = CGRect(x: textLabelsXPosition, y: topPadding, width: notificationWidth - textLabelsXPosition - padding, height: CGFloat(0.0))
        self.titleLabel.sizeToFit()
        
        if self.notification.body != nil && (self.notification.body!).characters.count > 0 {
            self.bodyLabel.frame = CGRect(x: textLabelsXPosition, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kBodyLabelTopPadding, width: notificationWidth - padding - textLabelsXPosition, height: 0.0)
            self.bodyLabel.sizeToFit()
            height = self.bodyLabel.frame.origin.y + self.bodyLabel.frame.size.height
        } else {
            //Only title label set
            height = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height
        }
        
        height += padding
        
        let yPosition = self.notificationManager.notificationsPosition == LNRNotificationPosition.top && statusBarVisible ?
            round((kStatusBarHeight+height) / 2.0) : round((height) / 2.0)
        self.iconImageView.center = CGPoint(x: self.iconImageView.center.x, y: yPosition)
        
        if self.notificationManager.notificationsPosition == LNRNotificationPosition.top {
            var seperatorFrame: CGRect = self.seperator.frame
            seperatorFrame.origin.y = height
            self.seperator.frame = seperatorFrame
        }
        
        height += self.seperator.frame.size.height
        
        self.frame = CGRect(x: CGFloat(0.0), y: self.frame.origin.y, width: self.frame.size.width, height: height)
        
        return height
    }
    
    //MARK: Private
    
    private let titleLabel: UILabel = UILabel()
    private let bodyLabel: UILabel = UILabel()
    private let iconImageView: UIImageView = UIImageView()
    private let seperator: UIView = UIView()
    private var notificationManager: LNRNotificationManager!
    
    //MARK: Tap Recognition
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == UIGestureRecognizerState.ended {
            let _ = dismissWithCompletion(nil)
            if self.notification.onTap != nil {
                self.notification.onTap!()
            }
        }
    }
    
}

