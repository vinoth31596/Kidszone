//
//  signupViewController.swift
//  kidszone
//
//  Created by iMac on 15/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

var localFieldUser = LocalVariables()
class SignupViewController: UIViewController , UITextFieldDelegate{
    
    var reachability:Reachability?
    
    @IBOutlet weak var userNameTextFieldOutlet: RSFloatInputView!
    @IBOutlet weak var firstNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var lastNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var emailTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var passwordTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var conPasswordTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var mobileNumberTextFieldOutlet: RSFloatInputView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextFieldOutlet.textField.delegate = self
        lastNameTextFieldOutlet.textField.delegate = self
        emailTextFieldOutlet.textField.delegate = self
        passwordTextFieldOutlet.textField.delegate = self
        conPasswordTextFieldOutlet.textField.delegate = self
        mobileNumberTextFieldOutlet.textField.delegate = self
        userNameTextFieldOutlet.textField.delegate = self
        
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            print("Internet available")
            
            
            let firstname = firstNameTextFieldOutlet.textField.text
            let lastname = lastNameTextFieldOutlet.textField.text
            let Email = emailTextFieldOutlet.textField.text
            let password = passwordTextFieldOutlet.textField.text
            let passwordConfirm = conPasswordTextFieldOutlet.textField.text
            let Mobile = mobileNumberTextFieldOutlet.textField.text
            let userName = userNameTextFieldOutlet.textField.text
            
            let provideMobileNumber = mobileNumberTextFieldOutlet.textField.text
            
            let isValidate = validate(number: provideMobileNumber!)
            
            let providedEmailAddress = emailTextFieldOutlet.textField.text
            
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
            
            if (userName?.isEmpty)!{
                
                showerror(alertmessage: "User Name is Required")
                
            }
            else if (firstname?.isEmpty)!{
                
                showerror(alertmessage: "First Name is Required")
            }else if (lastname?.isEmpty)!{
                
                showerror(alertmessage: "Last Name is Required")
            }else if (Email?.isEmpty)!{
                
                showerror(alertmessage: "Email is Required")
                
            }else if (password?.isEmpty)!{
                
                showerror(alertmessage: "Password is Required")
            }else if (passwordConfirm?.isEmpty)!{
                
                showerror(alertmessage: "Confirmation Password is Required")
            }else if (Mobile?.isEmpty)!{
                
                showerror(alertmessage: "Mobile Number is Required")
            }
                
            else{
                
                if (password != passwordConfirm){
                    
                    showerror(alertmessage: "Password Mismatch")
                }
                else{
                    //password validation
                    
                    // let providedPassword = passwordTextFieldOutlet.textField.text
                    
                    // let isPasswordValid = isValidPassword(testStr: providedPassword!)
                    
                    // if isPasswordValid && isEmailAddressValid {
                    if isEmailAddressValid && isValidate{
                        
                        SVProgressHUD.show()
                        
                        localFieldUser.firstname = firstname
                        localFieldUser.lastname = lastname
                        localFieldUser.email = Email
                        localFieldUser.password = password
                        localFieldUser.mobile = Mobile
                        localFieldUser.username = userName
                        
                        self.performSegue(withIdentifier: "gotoUserRegistartion", sender: self)
                        SVProgressHUD.dismiss()
                    }
                    else{
                        //                        if isPasswordValid
                        //                        {
                        //                            print("Password regex is valid")
                        //                        } else {
                        //                            print("Password regex is not valid")
                        //                            showerror(alertmessage: "Password Must have atleast one lowercase,uppercase,digit,min 8 & max 10 Characters")
                        //                        }
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
            }
            
        }else
        {
            print("Internet Not available")
            
            showerror(alertmessage: "No network connection")
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
    
    // mobile number validator
    func validate(number: String) -> Bool {
        if number.characters.count == 10{
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextFieldOutlet.textField || textField == conPasswordTextFieldOutlet.textField || textField == passwordTextFieldOutlet.textField {
            
            animateViewMoving(up: true, moveValue: 200)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileNumberTextFieldOutlet.textField || textField == conPasswordTextFieldOutlet.textField || textField == passwordTextFieldOutlet.textField{
            
            animateViewMoving(up: true, moveValue: -200)
            
        }
        if textField == userNameTextFieldOutlet.textField{
            let username = userNameTextFieldOutlet.textField.text
            UIPasteboard.general.string = userNameTextFieldOutlet.textField.text
            let myString = UIPasteboard.general.string
            if (username?.isNotEmpty)! && isValidEmailAddress(emailAddressString: username!){
                emailTextFieldOutlet.textField.insertText(myString!)
                emailTextFieldOutlet.focus()
            }
            else if (username?.isNotEmpty)! && validate(number: username!){
                mobileNumberTextFieldOutlet.textField.insertText(myString!)
                mobileNumberTextFieldOutlet.focus()
            }else{
                
                showerror(alertmessage: "User Name must be a Mobile No/Email")
            }
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
    
    //    //password validation function
    //    func isValidPassword(testStr:String?) -> Bool {
    //        guard testStr != nil else { return false }
    //
    //        // at least one uppercase,
    //        // at least one digit
    //        // at least one lowercase
    //        // 8 characters total
    //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,10}")
    //        return passwordTest.evaluate(with: testStr)
    //    }
    
    
    func toolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        emailTextFieldOutlet.textField.inputAccessoryView = toolbar
        passwordTextFieldOutlet.textField.inputAccessoryView = toolbar
        conPasswordTextFieldOutlet.textField.inputAccessoryView = toolbar
        firstNameTextFieldOutlet.textField.inputAccessoryView = toolbar
        mobileNumberTextFieldOutlet.textField.inputAccessoryView = toolbar
        lastNameTextFieldOutlet.textField.inputAccessoryView = toolbar
        userNameTextFieldOutlet.textField.inputAccessoryView = toolbar
        emailTextFieldOutlet.textField.keyboardType = .emailAddress
        mobileNumberTextFieldOutlet.textField.keyboardType = .numberPad
    }
    @objc func doneClicked(){
        view.endEditing(true)
    }
    fileprivate func callSignUpService() {
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
