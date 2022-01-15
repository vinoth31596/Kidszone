
//
//  signupViewController.swift
//  kidszone
//
//  Created by iMac on 15/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

var localFieldEditProvider = LocalVariables()

class EditProfileProviderViewController: UIViewController ,UITextFieldDelegate{
    
    var hideMenuDelegate: HideSideMenu?
    var reachability:Reachability?
    
    @IBOutlet weak var firstNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var lastNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var emailTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var mobileNumberTextFieldOutlet: RSFloatInputView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextFieldOutlet.textField.delegate = self
        lastNameTextFieldOutlet.textField.delegate = self
        emailTextFieldOutlet.textField.delegate = self
        mobileNumberTextFieldOutlet.textField.delegate = self
        
        defaultTextView()
        toolbar()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (true)
    }
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        hideMenuDelegate?.hideMenu(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            print("Internet available")
            
            
            let nameP = firstNameTextFieldOutlet.textField.text
            let lastnameP = lastNameTextFieldOutlet.textField.text
            let EmailP = emailTextFieldOutlet.textField.text
            let MobileP = mobileNumberTextFieldOutlet.textField.text
            
            
            if (nameP?.isEmpty)!{
                
                showerror(alertmessage: "First Name is Required")
            }else if (lastnameP?.isEmpty)!{
                
                showerror(alertmessage: "Last Name is Required")
            }else if (EmailP?.isEmpty)!{
                
                showerror(alertmessage: "Email is Required")
                
            }else if (MobileP?.isEmpty)!{
                
                showerror(alertmessage: "Mobile number is Required")
            }
            else{
                let provideMobileNumber = mobileNumberTextFieldOutlet.textField.text
                
                let isValidate = validate(number: provideMobileNumber!)
                
                let providedEmailAddress = emailTextFieldOutlet.textField.text
                
                let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
                
                if isEmailAddressValid && isValidate{
                    SVProgressHUD.show()
                    
                    localFieldEditProvider.firstnameEdit1 = nameP
                    localFieldEditProvider.lastnameEdit1 = lastnameP
                    localFieldEditProvider.emailEdit1 = EmailP
                    localFieldEditProvider.mobileEdit1 = MobileP
                    print("\(localFieldEditProvider.mobileEdit1)\(localFieldEditProvider.lastnameEdit1)\(localFieldEditProvider.emailEdit1)\(localFieldEditProvider.firstnameEdit1)")
                    self.performSegue(withIdentifier: "gotoprovidereditregistration", sender: self)
                    SVProgressHUD.dismiss()
                }
                else{
                    if isValidate{
                        print("mobile number is valid")
                    }else{
                        
                        showerror(alertmessage: "Mobile Number Must be 10 Characters")
                    }
                    //email validation
                    
                    
                    if isEmailAddressValid
                    {
                        print("Email address is valid")
                    } else {
                        print("Email address is not valid")
                        
                        showerror(alertmessage: "Enter an valid Email ID")
                    }
                }
            }
        } else
        {
            print("Internet Not available")
            
            showerror(alertmessage: "No Internet connection")
        }
        
    }
    
    
    
    //email validation function
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func validate(number: String) -> Bool {
        if number.characters.count == 10{
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextFieldOutlet.textField {
            
            animateViewMoving(up: true, moveValue: 200)
            
        }
        // animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileNumberTextFieldOutlet.textField {
            
            animateViewMoving(up: true, moveValue: -200)
            
        }
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:TimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    @objc func doneClicked(){
        view.endEditing(true)
    }
    
    fileprivate func callSignUpService() {
    }
    
    func toolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        emailTextFieldOutlet.textField.inputAccessoryView = toolbar
        firstNameTextFieldOutlet.textField.inputAccessoryView = toolbar
        mobileNumberTextFieldOutlet.textField.inputAccessoryView = toolbar
        lastNameTextFieldOutlet.textField.inputAccessoryView = toolbar
        emailTextFieldOutlet.textField.keyboardType = .emailAddress
        mobileNumberTextFieldOutlet.textField.keyboardType = .numberPad
    }
    //alert function
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    
    func defaultTextView(){
        let EmailP  = UserDefaults.standard.string(forKey: "emailId")
        let nameP = UserDefaults.standard.string(forKey: "first_name")
        let lastnameP = UserDefaults.standard.string(forKey: "last_name")
        let MobileP = UserDefaults.standard.string(forKey: "mobile_no")
        
        emailTextFieldOutlet.textField.text = EmailP
        firstNameTextFieldOutlet.textField.text = nameP
        lastNameTextFieldOutlet.textField.text = lastnameP
        mobileNumberTextFieldOutlet.textField.text = MobileP
        
        emailTextFieldOutlet.focus()
        firstNameTextFieldOutlet.focus()
        lastNameTextFieldOutlet.focus()
        mobileNumberTextFieldOutlet.focus()
        
    }
    
}
