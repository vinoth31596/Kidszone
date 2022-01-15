//
//  ViewController.swift
//  ViewsAdd
//
//  Created by Admin on 6/19/18.
//  Copyright © 2018 xvalue. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate{
    var reachability:Reachability?
    
    @IBOutlet weak var tabl: UITableView!
    @IBOutlet weak var addressOutlet: RSFloatInputView!
    @IBOutlet weak var stateOutlet: RSFloatInputView!
    @IBOutlet weak var zipcodeOutlet: RSFloatInputView!
    @IBOutlet weak var imageCL: UIImageView!
    
    @IBAction func registerPressedBtn(_ sender: UIButton) {
        
        
        let stateText = stateOutlet.textField.text
        let addressText = addressOutlet.textField.text
        let zipcodeText = zipcodeOutlet.textField.text
        
        let provideZipcode = zipcodeOutlet.textField.text
        
        let isValidate = validate(number: provideZipcode!)
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            
            if (stateText?.isEmpty)!{
                
                showerror(alertmessage: "State Name is Missing")
            }else if (addressText?.isEmpty)!{
                
                showerror(alertmessage: "Address is Missing")
            }else if (zipcodeText?.isEmpty)!{
                
                showerror(alertmessage: "Zipcode is Missing")
            }else if isValidate{
                
                SVProgressHUD.show()
                
                localFieldUser.address = stateText
                localFieldUser.zipcode = zipcodeText
                localFieldUser.state = stateText
                
                let params : [String : Any] = ["username":localFieldUser.username!,"first_name": localFieldUser.firstname!,"email": localFieldUser.email!,"password": localFieldUser.password!,"mobile_no": localFieldUser.mobile!,"last_name": localFieldUser.lastname!,"is_licence": "1","usertype_id": "1" ,"address": localFieldUser.address!, "state": stateOutlet.textField,"zipcode" : localFieldUser.zipcode!]
                
                KidZoneServiceHandler.share.callRegisterService(params: params) { (success, error) in
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            if let dataDictionary = success!["data"] as? [String: Any], let userId = dataDictionary["id"], let userDictionary = dataDictionary["user_details"] as? [String: Any], let username = dataDictionary["username"],let usertype_id = dataDictionary["usertype_id"],let email = userDictionary["email"], let password = userDictionary["password"], let mobile_no = dataDictionary["mobile_no"] , let state = userDictionary["state"], let address = userDictionary["address"], let zipcode = dataDictionary["zipcode"],let first_name = userDictionary["first_name"],let lastname = userDictionary["last_name"]{
                                
                                UserDefaults.standard.set(email, forKey: "emailId")
                                UserDefaults.standard.set(first_name, forKey: "first_name")
                                UserDefaults.standard.set(lastname, forKey: "last_name")
                                UserDefaults.standard.set(address, forKey: "address")
                                UserDefaults.standard.set(mobile_no, forKey: "mobile_no")
                                UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                UserDefaults.standard.set(state, forKey: "state")
                                UserDefaults.standard.set(userId, forKey: "id")
                                UserDefaults.standard.set(username, forKey: "username")
                                
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
            
            
            showerror(alertmessage: "No internet connection")
        }
    }
    
    
    
    var scheduleArr = NSMutableArray()
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleArr = [""]
        
        addressOutlet.textField.delegate = self
        stateOutlet.textField.delegate = self
        zipcodeOutlet.textField.delegate = self
        zipcodeOutlet.textField.keyboardType = .numberPad
        
        toolbar()
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
    
    @IBAction func Addcell(_ sender: UIButton) {
        
        scheduleArr.add("\(scheduleArr.count + 1)")
        let insertIndepath = NSIndexPath(row: scheduleArr.count - 1, section: 0)
        tabl.insertRows(at: [insertIndepath as IndexPath], with: .automatic)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell
        //cell?.genderDisplay.text = "Kids Detail\(scheduleArr[indexPath.row] as? String)"
        cell?.views.dropShadow()
        cell?.imageCL.circleImage()
        cell?.myTablController = self
        
        return cell!
    }
    
    func deleteCell1(cell: UITableViewCell) {
        if let deletionIndexPath = tabl.indexPath(for: cell) {
            scheduleArr.removeObject(at: deletionIndexPath.row)
            tabl.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    func deleteCell(_ sender: UIButton) {
        
        if let cell = sender.superview?.superview as? UITableViewCell {
            let indexpath = tabl.indexPath(for: cell)
            scheduleArr.removeObject(at: (indexpath?.row)!)
            tabl.beginUpdates()
            tabl.deleteRows(at: [indexpath!], with: .automatic)
            tabl.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("indexPath:\(indexPath.row)")
    }
    
    func chooseImageOnClick() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension RegistrationViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            //            let indexPath = IndexPath(row: 0, section: 0)
            //            let cell = tabl.cellForRow(at: indexPath) as? CustomCell
            //            cell?.imageCL.image = editedImage
            imageCL.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func toolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        addressOutlet.textField.inputAccessoryView = toolbar
        stateOutlet.textField.inputAccessoryView = toolbar
        zipcodeOutlet.textField.inputAccessoryView = toolbar
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
