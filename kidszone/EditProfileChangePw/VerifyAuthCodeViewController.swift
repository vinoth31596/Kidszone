//
//  VerifyAuthCodeViewController.swift
//  kidszone
//
//  Created by iMac on 04/07/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

class VerifyAuthCodeViewController: UIViewController {
    var errorMessage = SignupViewController()
    var reachability:Reachability?
    @IBOutlet weak var verifyAuthCode: RSFloatInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        let verifyCodeFromLocal = authCodeLocal.authCode
        let verificationCode = verifyAuthCode.textField.text
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            
        if (verificationCode?.isEmpty)! || (verificationCode != verifyCodeFromLocal){
            errorMessage.showerror(alertmessage: "Please enter valid Authentication code")
        }else if verifyCodeFromLocal==verificationCode{
            SVProgressHUD.show()
            
            
            print("Success authcode verification")
            SVProgressHUD.dismiss()
            performSegue(withIdentifier: "gotochangepassword", sender: self)
        }
        }else{
            SVProgressHUD.dismiss()
            errorMessage.showerror(alertmessage: "No Internet Connection")
        }
        
    }

}
