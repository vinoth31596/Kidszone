//
//  ViewController.swift
//  ViewsAdd
//
//  Created by Admin on 6/19/18.
//  Copyright © 2018 xvalue. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditRegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate{
    var reachability:Reachability?
    
    @IBOutlet weak var tabl: UITableView!
    
    
    
    @IBAction func registerPressedBtn(_ sender: UIButton) {
        
        let params : [String : Any] = ["username": UserDefaults.standard.string(forKey: "username")!,"first_name": localFieldUserEdit.firstnameEdit!,"email": localFieldUserEdit.emailEdit!,"id": localFieldUserEdit.userIDEdit!,"mobile_no": localFieldUserEdit.mobileEdit!,"last_name": localFieldUserEdit.lastnameEdit!,"is_licence": "1","usertype_id": "1" ,"address": localFieldUserEdit.addressEdit!, "state": localFieldUserEdit.stateEdit!,"zipcode" : localFieldUserEdit.zipcodeEdit!]
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            //self.view.showHUD(title: "Loading...", dim: true)
            SVProgressHUD.show()
            KidZoneServiceHandler.share.callUpdateUserDetails(params: params) { (success, error) in
                guard let statusCode = success!["status_code"] as? String else { return }
                DispatchQueue.main.async {
                    if Int(statusCode) == 200 {
                        if let dataDictionary = success!["data"] as? [String: Any], let userId = dataDictionary["id"], let userDictionary = dataDictionary["user_details"] as? [String: Any], let usertype_id = dataDictionary["usertype_id"],let email = userDictionary["email"], let password = userDictionary["password"], let mobile_no = dataDictionary["mobile_no"] , let state = userDictionary["state"], let address = userDictionary["address"], let zipcode = dataDictionary["zipcode"]{
                            
                        }
                        //self.view.hideHUD()
                        SVProgressHUD.dismiss()
                        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpSliderVC") as? SignUpSliderVC
                        self.navigationController?.pushViewController(storyBoard!, animated: true)
                    }
                }
            }
        }
        else {
            showerror(alertmessage: "No Internet connection.")
        }
    }
    
    
    
    var scheduleArr = NSMutableArray()
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleArr = [""]
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        localFieldUserEdit.userIDEdit = UserDefaults.standard.value(forKey: "id") as? String
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
        
        self.performSegue(withIdentifier: "gotomain", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit", for: indexPath) as? EditCustomCell
        //cell?.genderDisplay.text = "Kids Detail\(scheduleArr[indexPath.row] as? String)"
        cell?.views.dropShadow()
        cell?.imageCL.circleImage()
        cell?.myTabelController = self
        
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
    //alert function
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    
    
}
