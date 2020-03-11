//
//  CollectionViewCell.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoImage.layer.masksToBounds = true
        self.logoImage.layer.cornerRadius = 4.0

    }
    
    override func prepareForReuse() {
        logoImage.sd_cancelCurrentImageLoad()
    }
    
    func setImage(stringURL: String) {

        let url = URL(string: stringURL)
        let phImg = UIImage(named: "pills")
        logoImage.sd_setImage(with: url, placeholderImage: phImg)
    }
    
}
