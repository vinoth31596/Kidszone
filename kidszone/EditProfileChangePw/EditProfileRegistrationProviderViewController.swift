
//
//  RegistrationProviderViewController.swift
//  kidszone
//
//  Created by iMac on 22/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditProfileRegistrationProviderViewController: UIViewController {
    var hideMenuDelegate: HideSideMenu?
    var reachability:Reachability?
    
    @IBOutlet weak var parentCmpyNameOutlet: RSFloatInputView!
    @IBOutlet weak var companyNameOutlet: RSFloatInputView!
    @IBOutlet weak var descriptionOutlet: RSFloatInputView!
    @IBOutlet weak var addressOutlet: RSFloatInputView!
    @IBOutlet weak var cityOutlet: RSFloatInputView!
    @IBOutlet weak var stateOutlet: RSFloatInputView!
    @IBOutlet weak var zipcodeOutlet: RSFloatInputView!
    @IBOutlet weak var websiteAddressOutlet: RSFloatInputView!
    @IBOutlet weak var liceneseSwitchOutlet: UISwitch!
    @IBOutlet weak var licenceFieldOutlet: RSFloatInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        licenceFieldOutlet.isHidden = true
        liceneseSwitchOutlet.isOn = false
        localFieldEditProvider.licenseAvailabilityEdit1 = "0"
        localFieldEditProvider.licensenoEdit1 = "0"
        toolbar()
        defaultTextView()
        
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
    
    @IBAction func licenseSwitchTapped(_ sender: Any) {
        
        if liceneseSwitchOutlet.isEnabled{
            localFieldEditProvider.licenseAvailabilityEdit1 = "1"
            if liceneseSwitchOutlet.isOn == true{
                licenceFieldOutlet.isHidden = false
                print(localFieldEditProvider.licenseAvailabilityEdit1!)
            }else{
                localFieldEditProvider.licenseAvailabilityEdit1 = "0"
                licenceFieldOutlet.isHidden = true
                print(localFieldEditProvider.licenseAvailabilityEdit1!)
            }
        }else {
            
        }
    }
    
    @IBAction func registreBtnPressed(_ sender: UIButton) {
        
        let parentCompany = parentCmpyNameOutlet.textField.text
        let companyName = companyNameOutlet.textField.text
        let description = descriptionOutlet.textField.text
        let address = addressOutlet.textField.text
        let city = cityOutlet.textField.text
        let state = stateOutlet.textField.text
        let zipcode = zipcodeOutlet.textField.text
        let website = websiteAddressOutlet.textField.text
        let license = licenceFieldOutlet.textField.text
        
        let provideZipcode = zipcodeOutlet.textField.text
        let isValidate = validate(number: provideZipcode!)
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            print("Internet available")
            
            if (parentCompany?.isEmpty)!{
                
                showerror(alertmessage: "Parent Company name is Missing")
            }else if (companyName?.isEmpty)!{
                
                showerror(alertmessage: "Compnay name is Missing")
            }else if (description?.isEmpty)! {
                
                showerror(alertmessage: "Description is Missing")
            }else if (address?.isEmpty)!{
                
                showerror(alertmessage: "Address is Missing")
            }else if (city?.isEmpty)!{
                
                showerror(alertmessage: "City name is Missing")
            }else if (state?.isEmpty)!{
                
                showerror(alertmessage: "State name is Missing")
            }else if (zipcode?.isEmpty)!{
                
                showerror(alertmessage: "Zipcode is Missing")
            }else if (website?.isEmpty)!{
                
                showerror(alertmessage: "Website Address is Missing")
            }
            else if liceneseSwitchOutlet.isOn == true && (license?.isEmpty)!{
                
                showerror(alertmessage: "Enter license Number")
            } else if isValidate{
                
                localFieldEditProvider.parentcompnayEdit1 = parentCompany
                localFieldEditProvider.companyEdit1 = companyName
                localFieldEditProvider.descriptionEdit1 = description
                localFieldEditProvider.addressEdit1 = address
                localFieldEditProvider.cityEdit1 = city
                localFieldEditProvider.stateEdit1 = state
                localFieldEditProvider.zipcodeEdit1 = zipcode
                localFieldEditProvider.websiteEdit1 = website
                localFieldEditProvider.licensenoEdit1 = license
                
                let userNameDefaults = UserDefaults.standard.string(forKey: "username")
                let userIDDefaults = UserDefaults.standard.string(forKey: "id")
                
                let params : [String : Any] = ["username": userNameDefaults!,"id":userIDDefaults!,"first_name": localFieldEditProvider.firstnameEdit1!,"email": localFieldEditProvider.emailEdit1!,"mobile_no": localFieldEditProvider.mobileEdit1!,"last_name": localFieldEditProvider.lastnameEdit1!,"is_licence": localFieldEditProvider.licenseAvailabilityEdit1!,"usertype_id": "2" ,"city": localFieldEditProvider.cityEdit1!,"address": localFieldEditProvider.addressEdit1!, "state": localFieldEditProvider.stateEdit1!,"zipcode" : localFieldEditProvider.zipcodeEdit1!,"website": localFieldEditProvider.websiteEdit1!,"description": localFieldEditProvider.descriptionEdit1!,"licence_no": localFieldEditProvider.licensenoEdit1!]
                
                KidZoneServiceHandler.share.callUpdateUserDetails(params: params) { (success, error) in
                    
                    SVProgressHUD.show()
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            if let dataDictionary = success!["data"] as? [String: Any], let userId = dataDictionary["id"], let userDictionary = dataDictionary["user_details"] as? [String: Any], let usertype_id = dataDictionary["usertype_id"],let email = userDictionary["email"], let password = userDictionary["password"], let mobile_no = dataDictionary["mobile_no"] ,let city = userDictionary["city"],let website = userDictionary["website"],let description = userDictionary["description"],let licenseAvailable = dataDictionary["is_licence"],let licensenumber = dataDictionary["licence_no"], let state = userDictionary["state"], let address = userDictionary["address"], let zipcode = dataDictionary["zipcode"]{
                                
                            }
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "gotomain", sender: self)
                        }
                    }
                }
            }else{
                
                showerror(alertmessage: "Zipcode must be 10 characters")
            }
        }else {
            print("Internet Not Available")
            
            showerror(alertmessage: "No Internet Connection")
        }
    }
    func validate(number: String) -> Bool {
        if number.characters.count == 6{
            return true
        }
        else{
            return false
        }
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
    
    func toolbar(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        parentCmpyNameOutlet.textField.inputAccessoryView = toolbar
        companyNameOutlet.textField.inputAccessoryView = toolbar
        descriptionOutlet.textField.inputAccessoryView = toolbar
        addressOutlet.textField.inputAccessoryView = toolbar
        cityOutlet.textField.inputAccessoryView = toolbar
        stateOutlet.textField.inputAccessoryView = toolbar
        zipcodeOutlet.textField.inputAccessoryView = toolbar
        websiteAddressOutlet.textField.inputAccessoryView = toolbar
        licenceFieldOutlet.textField.inputAccessoryView = toolbar
        zipcodeOutlet.textField.keyboardType = .numberPad
        
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
        
        let parentCompany = UserDefaults.standard.string(forKey: "parent_company_name")
        let companyName = UserDefaults.standard.string(forKey: "company_name")
        let description = UserDefaults.standard.string(forKey: "description")
        let address = UserDefaults.standard.string(forKey: "address")
        let city = UserDefaults.standard.string(forKey: "city")
        let state = UserDefaults.standard.string(forKey: "state")
        let zipcode = UserDefaults.standard.string(forKey: "zipcode")
        let website = UserDefaults.standard.string(forKey: "website")
        
        parentCmpyNameOutlet.textField.text = parentCompany
        companyNameOutlet.textField.text = companyName
        descriptionOutlet.textField.text = description
        addressOutlet.textField.text = address
        cityOutlet.textField.text = city
        stateOutlet.textField.text = state
        zipcodeOutlet.textField.text = zipcode
        websiteAddressOutlet.textField.text = website
        
        parentCmpyNameOutlet.focus()
        companyNameOutlet.focus()
        descriptionOutlet.focus()
        addressOutlet.focus()
        cityOutlet.focus()
        stateOutlet.focus()
        zipcodeOutlet.focus()
        websiteAddressOutlet.focus()
        
    }
}

