//
//  ProgressHelper.swift
//  Smarty
//
//  Created by administrator on 03/05/2018.
//  Copyright © 2018 Bertrand Russell Sakthees. All rights reserved.
//

import UIKit

class ProgressHelper: NSObject {

}
extension UIView {
    
    func showHUDWindow(title:String, dim:Bool)
    {
        self.endEditing(true)
        let hud = MBProgressHUD.showAdded(to: self.window, animated: true)
        hud?.labelText = title
        hud?.dimBackground = dim
        
    }
    
    func hideHUDWindow()
    {
        MBProgressHUD.hide(for: self.window, animated: true)
    }
    
    
    func showHUD(title:String, dim:Bool)
    {
        self.endEditing(true)
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.detailsLabelText = title
        hud?.dimBackground = dim
        
    }
    
    func hideHUD()
    {
        MBProgressHUD.hide(for: self, animated: true)
    }
}
