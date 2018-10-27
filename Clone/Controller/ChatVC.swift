//
//  ChatVC.swift
//  CommunityOfNerds
//
//  Created by Akash Soneji on 25/10/18.
//  Copyright © 2018 Akash. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth

class ChatVC: JSQMessagesViewController {

    var messages = [JSQMessage]()

    var chatName: String?
    var userName: String?
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.darkGray)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

        let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    
                    self?.finishReceivingMessage()
                }
            }
        })

        
        let defaults = UserDefaults.standard
        
        if  let id = defaults.string(forKey: "jsq_id"),
            let name = defaults.string(forKey: "jsq_name"){
            senderId = id
            senderDisplayName = name
            
        }
        title = chatName
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!{
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!{
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!{
        return nil
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!{
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat{
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let ref = Constants.refs.databaseChats.childByAutoId()
        
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        
        ref.setValue(message)
        
        finishSendingMessage()
    }
}
