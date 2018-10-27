//
//  DashBoardViewController.swift
//  CommunityOfNerds
//
//  Created by iFlame on 7/3/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var dashboardCollection: UICollectionView!
    
    
    var books = ["Android","C#","AngularJS","CLang","CPP","Graphics","HTML","PHP","iOS","Java","JavaScript","Oracle","Perl","Python","Ruby","Sql","Vbnet"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        title = "Community of Nerds"
        
        let logOutButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleLogOutAction))
        navigationItem.leftBarButtonItem = logOutButton
    }

    @objc func handleLogOutAction()  {
        
        UserDefaults.standard.removeObject(forKey: "jsq_id")
        UserDefaults.standard.removeObject(forKey: "jsq_name")
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        appdelegate.window?.rootViewController = UINavigationController(rootViewController: controller)
        appdelegate.window?.makeKeyAndVisible()
    }
   

}



extension DashBoardViewController: UICollectionViewDelegate{
    
}
extension DashBoardViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
        cell.languageImageView.image = UIImage(named: books[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        controller.chatName = books[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension DashBoardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 10, height: (collectionView.frame.width / 3) - 10)
    }
}
