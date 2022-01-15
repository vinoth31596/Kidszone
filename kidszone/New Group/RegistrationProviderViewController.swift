//
//  RegistrationProviderViewController.swift
//  kidszone
//
//  Created by iMac on 22/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistrationProviderViewController: UIViewController {
    
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
        localField.licenseAvailability1 = "0"
        localField.licenseno1 = "0"
        toolbar()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (true)
    }
    
    @IBAction func licenseSwitchTapped(_ sender: Any) {
        
        if liceneseSwitchOutlet.isEnabled{
            localField.licenseAvailability1 = "1"
            if liceneseSwitchOutlet.isOn == true{
                licenceFieldOutlet.isHidden = false
                print(localField.licenseAvailability1!)
            }else{
                localField.licenseAvailability1 = "0"
                licenceFieldOutlet.isHidden = true
                print(localField.licenseAvailability1!)
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
                
                localField.parentcompany1 = parentCompany
                localField.company1 = companyName
                localField.description1 = description
                localField.address1 = address
                localField.city1 = city
                localField.state1 = state
                localField.zipcode1 = zipcode
                localField.website1 = website
                localField.licenseno1 = license
                
                let params : [String : Any] = ["first_name": localField.firstname1!,"username": localField.username1!,"email": localField.email1!,"password": localField.password1!,"mobile_no": localField.mobile1!,"last_name": localField.lastname1!,"is_licence": localField.licenseAvailability1!,"usertype_id": "2" ,"city": localField.city1!,"address": localField.address1!, "state": localField.state1!,"zipcode" : localField.zipcode1!,"website": localField.website1!,"description": localField.description1!,"licence_no": localField.licenseno1!,"parent_company": localField.parentcompany1!]
                
                KidZoneServiceHandler.share.callRegisterService(params: params) { (success, error) in
                    
                    SVProgressHUD.show()
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            if let dataDictionary = success!["data"] as? [String: Any], let userId = dataDictionary["id"], let userDictionary = dataDictionary["user_details"] as? [String: Any], let usertype_id = dataDictionary["usertype_id"],let email = userDictionary["email"], let password = userDictionary["password"], let mobile_no = dataDictionary["mobile_no"] ,let city = userDictionary["city"],let website = userDictionary["website"],let description = userDictionary["description"],let licenseAvailable = dataDictionary["is_licence"],let licensenumber = dataDictionary["licence_no"], let state = userDictionary["state"], let address = userDictionary["address"],let lastname = userDictionary["last_name"],let username = userDictionary["username"],let userProfile = userDictionary["user_profie_url"],let first_name = userDictionary["first_name"], let zipcode = dataDictionary["zipcode"]{
                                
                                UserDefaults.standard.set(email, forKey: "emailId")
                                UserDefaults.standard.set(first_name, forKey: "first_name")
                                UserDefaults.standard.set(lastname, forKey: "last_name")
                                UserDefaults.standard.set(address, forKey: "address")
                                UserDefaults.standard.set(mobile_no, forKey: "mobile_no")
                                UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                UserDefaults.standard.set(state, forKey: "state")
                                UserDefaults.standard.set(userId, forKey: "id")
                                UserDefaults.standard.set(username, forKey: "username")
                                UserDefaults.standard.set(usertype_id, forKey: "user_type_id")
                                //UserDefaults.standard.set(address2, forKey: "address2")
                                UserDefaults.standard.set(city, forKey: "city")
                                UserDefaults.standard.set(userProfile, forKey: "user_profie_url")
                                UserDefaults.standard.set(companyName, forKey: "company_name")
                                UserDefaults.standard.set(website, forKey: "website")
                                UserDefaults.standard.set(parentCompany, forKey: "parent_company_name")
                                UserDefaults.standard.set(description, forKey: "description")
                                
                            }
                            SVProgressHUD.dismiss()
                            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpSliderVC") as? SignUpSliderVC
                            self.navigationController?.pushViewController(storyBoard!, animated: true)
                            //self.performSegue(withIdentifier: "gotohome", sender: self)
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
}

