//
//  signupViewController.swift
//  kidszone
//
//  Created by iMac on 15/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD



protocol HideSideMenu {
    func hideMenu(_ isHidden: Bool)
}

var localFieldUserEdit = LocalVariables()

class EditProfileViewController: UIViewController , UITextFieldDelegate {
    
    var hideMenuDelegate: HideSideMenu?
    var reachability:Reachability?
    
    
    var name: String?
    var fullName: String?
    var emailID: String?
    var profileimage: String?
    var googleId: String?
    
    @IBOutlet weak var firstNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var lastNameTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var emailTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var addressTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var stateTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var mobileNumberTextFieldOutlet: RSFloatInputView!
    
    @IBOutlet weak var zipcodeTextFieldOutlet: RSFloatInputView!
    @IBOutlet weak var editImageCL: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppDelegate.isGoogleLogin {
            firstNameTextFieldOutlet.textField.text = fullName
            lastNameTextFieldOutlet.textField.text = name
            emailTextFieldOutlet.textField.text = emailID
            if let imagePresent = profileimage {
                editImageCL.downloadImage(from: imagePresent)
            }
        }
        if AppDelegate.isFBLogin {
            firstNameTextFieldOutlet.textField.text = name
            lastNameTextFieldOutlet.textField.text = fullName
            emailTextFieldOutlet.textField.text = emailID
            //editImageCL.downloadImage(from: profileimage!)
            UserDefaults.standard.set(googleId, forKey: "id")
        }
        firstNameTextFieldOutlet.textField.delegate = self
        lastNameTextFieldOutlet.textField.delegate = self
        emailTextFieldOutlet.textField.delegate = self
        zipcodeTextFieldOutlet.textField.delegate = self
        addressTextFieldOutlet.textField.delegate = self
        stateTextFieldOutlet.textField.delegate = self
        mobileNumberTextFieldOutlet.textField.delegate = self
        
        defaultTextView()
        toolbar()
        
        editImageCL.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        editImageCL.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            //            present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK: - Choose image from camera roll
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
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
    @IBAction func nextPressed(_ sender: Any) {
        
        
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            print("Internet available")
            
            let name = firstNameTextFieldOutlet.textField.text
            let lastname = lastNameTextFieldOutlet.textField.text
            let Email = emailTextFieldOutlet.textField.text
            let Mobile = mobileNumberTextFieldOutlet.textField.text
            let state = stateTextFieldOutlet.textField.text
            let address = addressTextFieldOutlet.textField.text
            let zipcode = zipcodeTextFieldOutlet.textField.text
            
            
            if (name?.isEmpty)!{
                showerror(alertmessage: "First name is Missing")
                
                
            }else if (lastname?.isEmpty)!{
                showerror(alertmessage: "Last name is Missing")
                
            }else if (Email?.isEmpty)!{
                showerror(alertmessage: "Email is Missing")
                
            }else if (Mobile?.isEmpty)! {
                showerror(alertmessage: "Mobile Number is Missing")
                
            }else if (address?.isEmpty)!{
                showerror(alertmessage: "Address is Missing")
                
            }else if (state?.isEmpty)!{
                showerror(alertmessage: "State name is Missing")
                
            }else if (zipcode?.isEmpty)!{
                showerror(alertmessage: "Zipcode is Missing")
                
            }
                
            else{
                
                let mobileValidation = mobileValidate(number: Mobile!)
                let zipcodeValidation = zipcodeValidate(number: zipcode!)
                let isEmailAddressValid = isValidEmailAddress(emailAddressString: Email!)
                
                if isEmailAddressValid && mobileValidation && zipcodeValidation{
                    SVProgressHUD.show()
                    
                    
                    localFieldUserEdit.firstnameEdit = name
                    localFieldUserEdit.lastnameEdit = lastname
                    localFieldUserEdit.emailEdit = Email
                    localFieldUserEdit.mobileEdit = Mobile
                    localFieldUserEdit.addressEdit = address
                    localFieldUserEdit.zipcodeEdit = zipcode
                    localFieldUserEdit.stateEdit = state
                    self.performSegue(withIdentifier: "gotoUserEditRegistartion", sender: self)
                    SVProgressHUD.dismiss()
                }
                else{
                    
                    
                    //email validation
                    
                    
                    if isEmailAddressValid
                    {
                        print("Email address is valid")
                    } else {
                        print("Email address is not valid")
                        
                        
                        showerror(alertmessage: "Enter an valid Email ID")
                    }
                    if mobileValidation{
                        print("Mobile no is valid")
                    }else{
                        
                        showerror(alertmessage: "Mobile number must be 10 characters")
                    }
                    if zipcodeValidation{
                        print("zipcode is valid")
                    }else{
                        
                        showerror(alertmessage: "zipciode must be 6 characters")
                    }
                }
            }
        }
            
        else
        {
            print("Internet Not available")
            
            
            showerror(alertmessage: "No Internet Connection")
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextFieldOutlet.textField  || textField == emailTextFieldOutlet.textField  || textField == stateTextFieldOutlet.textField || textField == zipcodeTextFieldOutlet.textField || textField == addressTextFieldOutlet.textField{
            
            animateViewMoving(up: true, moveValue: 200)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileNumberTextFieldOutlet.textField || textField == emailTextFieldOutlet.textField || textField == stateTextFieldOutlet.textField || textField == zipcodeTextFieldOutlet.textField || textField == addressTextFieldOutlet.textField{
            
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
    
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
}

extension EditProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            //            let indexPath = IndexPath(row: 0, section: 0)
            //            let cell = tabl.cellForRow(at: indexPath) as? CustomCell
            self.editImageCL.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        print("Cancelled")
    }
    func mobileValidate(number: String) -> Bool {
        if number.characters.count == 10{
            return true
        }
        else{
            return false
        }
    }
    func zipcodeValidate(number: String) -> Bool {
        if number.characters.count == 6{
            return true
        }
        else{
            return false
        }
    }
    func defaultTextView(){
        let firstName = UserDefaults.standard.string(forKey: "first_name")
        let lastName = UserDefaults.standard.string(forKey: "last_name")
        let email = UserDefaults.standard.string(forKey: "emailId")
        let mobileNumber = UserDefaults.standard.string(forKey: "mobile_no")
        let address = UserDefaults.standard.string(forKey: "address")
        let state = UserDefaults.standard.string(forKey: "state")
        let zipcode = UserDefaults.standard.string(forKey: "zipcode")
        
        firstNameTextFieldOutlet.textField.text = firstName
        lastNameTextFieldOutlet.textField.text = lastName
        emailTextFieldOutlet.textField.text = email
        mobileNumberTextFieldOutlet.textField.text = mobileNumber
        addressTextFieldOutlet.textField.text = address
        stateTextFieldOutlet.textField.text = state
        zipcodeTextFieldOutlet.textField.text = zipcode
        
        //        firstNameTextFieldOutlet.focus()
        //        lastNameTextFieldOutlet.focus()
        //        emailTextFieldOutlet.focus()
        //        mobileNumberTextFieldOutlet.focus()
        //        addressTextFieldOutlet.focus()
        //        stateTextFieldOutlet.focus()
        //        zipcodeTextFieldOutlet.focus()
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
        zipcodeTextFieldOutlet.textField.inputAccessoryView = toolbar
        addressTextFieldOutlet.textField.inputAccessoryView = toolbar
        stateTextFieldOutlet.textField.inputAccessoryView = toolbar
        emailTextFieldOutlet.textField.keyboardType = .emailAddress
        mobileNumberTextFieldOutlet.textField.keyboardType = .numberPad
        zipcodeTextFieldOutlet.textField.keyboardType = .numberPad
        
    }
    
}
