//
//  CustomFilterCell.swift
//  kidszone
//
//  Created by Admin on 6/27/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class CustomFilterCell: UICollectionViewCell {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var Ficons: UIImageView!
    @IBOutlet weak var Fname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setCellWidth(UIScreen.main.bounds.width)
        if UIScreen.main.sizeType == .iPhone5 {
            
            widthConstraint.constant = 130
            
        }else if UIScreen.main.sizeType == .iPhone6 {
            
            print("iPhone6")
        }else {
            widthConstraint.constant = 170
        }
    }
    
    func setCellWidth(_ width: CGFloat) {
        widthConstraint?.constant = width
    }
}
