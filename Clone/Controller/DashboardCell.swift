//
//  DashboardCell.swift
//  CommunityOfNerds
//
//  Created by iFlame on 7/3/18.
//  Copyright © 2018 iFlame. All rights reserved.
//

import UIKit

class DashboardCell: UICollectionViewCell {
    
    @IBOutlet weak var languageImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        languageImageView.contentMode = .scaleAspectFit
    }
}
