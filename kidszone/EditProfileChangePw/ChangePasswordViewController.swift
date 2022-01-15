//
//  ChangePasswordViewController.swift
//  kidszone
//
//  Created by iMac on 04/07/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordViewController: UIViewController {
var reachability = Reachability()
    
    @IBOutlet weak var newPasswordTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var confirmNewPasswordTextFieldOutlet: RSFloatInputView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePwBtnPressed(_ sender: Any) {
        
        
        let newPassword = newPasswordTextFieldOutlet.textField.text
        let conPassword = confirmNewPasswordTextFieldOutlet.textField.text
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            
            
            if (newPassword?.isEmpty)! || (conPassword?.isEmpty)!{
                showerror(alertmessage: "All Fields are Required")
            }else if (newPassword != conPassword) {
                showerror(alertmessage: "Password Field's Mismatch")
            }else{
                SVProgressHUD.show()
                let params : [String : Any] = ["username": authCodeLocal.forgotPwEmail! , "new_password": newPassword!]
                
                KidZoneServiceHandler.share.callChangePassword(params: params) { (success, error) in
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            
                            SVProgressHUD.dismiss()
                            self.showerrorLogin(alertmessage: "Password Changed Successfully")
                        }
                    }
                }
                SVProgressHUD.dismiss()
            }
            
            
        }else{
            SVProgressHUD.dismiss()
           showerror(alertmessage: "No Network Connection")
        }
        
    }
    
    func showerrorLogin(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "gotologinafterpawchange", sender: self)
            NSLog("Logout Pressed")
        }
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    //alert function
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    
        return
    }
    
   
}
