//
//  PDFViewController.swift
//  CommunityOfNerds
//
//  Created by iFlame on 7/9/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit
import PDFKit
import FirebaseAuth
class PDFViewController: UIViewController {

    @IBOutlet weak var myPDFView: PDFView!
    var chatName: String?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chatName
        if let path = Bundle.main.path(forResource: chatName, ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                myPDFView.displayMode = .singlePageContinuous
                myPDFView.autoScales = true
                myPDFView.displayDirection = .vertical
                myPDFView.document = pdfDocument
            }
        }
        
        let chatButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleChatButton))
        navigationItem.rightBarButtonItem = chatButton
        
        Constants.refs.databaseRoot.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let data = snapshot.value as? [String:String] else {
                print("no value")
                return
            }
            print(data)
            self.userName = data["firstname"]! + data["lastname"]!
            
        })
    }
    
    @objc func handleChatButton()  {
        print("Chat")
        let controller = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        controller.chatName = chatName
        controller.userName = userName
        navigationController?.pushViewController(controller, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem(image: UIImage(named: "iconBack"), style: .plain, target: self, action: #selector(handleBackButtonAction)) 
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func handleBackButtonAction()  {
        navigationController?.popViewController(animated: true)
    }

}
