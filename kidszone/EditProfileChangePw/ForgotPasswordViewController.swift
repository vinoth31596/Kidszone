//
//  ForgotPasswordViewController.swift
//  kidszone
//
//  Created by iMac on 15/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

var authCodeLocal = LocalVariables()
class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    var reachability:Reachability?
    
    @IBOutlet weak var forgotPasswordTextField: RSFloatInputView!
    
   
    @IBAction func forgotPwBtnPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        let forgotPassword = forgotPasswordTextField.textField.text
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            if (forgotPassword?.isEmpty)!{
                
                showerror(alertmessage: "Email ID or User Name is Required")
            }else {
                
                authCodeLocal.forgotPwEmail = forgotPassword
                
                let params : [String : Any] = ["email": forgotPasswordTextField.textField.text!]
                
                KidZoneServiceHandler.share.callForgotPassword(params: params) { (success, error) in
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            if let dataDictionary = success!["data"] as? [String: Any]{
                                let authCode = dataDictionary["auth_code"]
                                print(authCode!)
                                
                                authCodeLocal.authCode = authCode as? String
                                self.performSegue(withIdentifier: "gotoauthcodeverify", sender: self)
                            }
                            
                            SVProgressHUD.dismiss()
                            
                            //self.performSegue(withIdentifier: "gotohome", sender: self)
                        }
                    }
                }

            }
            
        }
        else {
            SVProgressHUD.dismiss()
          
            showerror(alertmessage: "No internet connection")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPasswordTextField.textField.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        forgotPasswordTextField.textField.inputAccessoryView = toolbar

        // Do any additional setup after loading the view.
    }
    @objc func doneClicked(){
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
