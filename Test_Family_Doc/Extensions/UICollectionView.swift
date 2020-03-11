//
//  UICollectionView.swift
//  Test_Family_Doc
//
//  Created by  user on 11.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import UIKit

extension UICollectionView {

    var centerPoint : CGPoint {

        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }

    var centerCellIndexPath: IndexPath? {

        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}
