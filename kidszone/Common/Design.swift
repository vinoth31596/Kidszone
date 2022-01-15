//
//  Design.swift
//  kidszone
//
//  Created by Admin on 7/9/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

@IBDesignable
open class KGHighLightedButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
}
