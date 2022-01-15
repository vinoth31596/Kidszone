//
//  ViewController.swift
//  kidszone
//
//  Created by iMac on 13/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit

var usernameLogin = LocalVariables()
class LoginViewController: UIViewController, UITextFieldDelegate,GIDSignInUIDelegate, GIDSignInDelegate {
    var hideMenuDelegate: HideSideMenu?
    var dict : [String : AnyObject]!
    let loginManager = LoginManager()
    
    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbLoginBtn: UIButton!
    var reachability:Reachability?
    var userDetails: [UserDetails]? = []
    
    @IBOutlet weak var passwordTextFieldOutlet: RSFloatInputView!
    @IBOutlet weak var emailTextFieldOutlet: RSFloatInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UIScreen.main.sizeType == .iPhone5 {
            
            leftConstraint.constant = 120
            
        }else if UIScreen.main.sizeType == .iPhone6 {
            
            leftConstraint.constant = 140
            googleBottomConstraint.constant = 80
            emailConstraint.constant = 50
            
        }else  {
            leftConstraint.constant = 160
            googleBottomConstraint.constant = 150
            emailConstraint.constant = 50
        }
        toolbar()
        GIDSignIn.sharedInstance().delegate = self
        setupGoogleButton()
        setupFBLogin()
        
    }
    
    fileprivate func setupGoogleButton() {
        
        googleBtn.addTarget(self, action: #selector(handleCustomGoogleBtn), for: .touchUpInside)
    }
    
    fileprivate func setupFBLogin() {
        fbLoginBtn.addTarget(self, action: #selector(FBloginClicked), for: .touchUpInside)
        
    }
    
    @objc func handleCustomGoogleBtn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func FBloginClicked() {
        
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            print(accessToken)
            //getFBUserData()
        }
        
        loginManager.logIn(readPermissions: [.email], viewController: self) { (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData() {
        SVProgressHUD.show()
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email,first_name,last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    AppDelegate.isFBLogin = true
                    UserDefaults.standard.set(AppDelegate.isFBLogin, forKey: "FBLogin")
                    if let FBID = self.dict["id"] as? String,let user_name = self.dict["first_name"] as? String, let firstname = self.dict["first_name"] as? String, let lastname = self.dict["last_name"] as? String {
                        print("FBID:",FBID,firstname, lastname)
                        UserDefaults.standard.set(firstname, forKey: "first_name")
                        if let emailId = self.dict["email"] as? String {
                            
                            self.callSocialRegiste(username: user_name, fname: firstname, lname: lastname, email: emailId, imageSt: "1")
                        }
                    }
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.isLogged = UserDefaults.standard.bool(forKey: "IsLogged")
        if AppDelegate.isLogged  {
            
            self.performSegue(withIdentifier: "gotomain", sender: self)
        }
        if AppDelegate.isGoogleLogout {
            AppDelegate.isGoogleLogout = false
            AppDelegate.isGoogleLogin = false
            UserDefaults.standard.set(AppDelegate.isGoogleLogin, forKey: "googleLogin")
            GIDSignIn.sharedInstance().signOut()
        }
        if AppDelegate.isFBLogout {
            AppDelegate.isFBLogout = false
            AppDelegate.isFBLogin = false
            UserDefaults.standard.set(AppDelegate.isFBLogin, forKey: "FBLogin")
            loginManager.logOut()
        }
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        SVProgressHUD.show()
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            AppDelegate.isGoogleLogin = true
            UserDefaults.standard.set(AppDelegate.isGoogleLogin, forKey: "googleLogin")
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let first_name = user.profile.name
            let user_name = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let image = user.profile.imageURL(withDimension: 400)
            let imagerequest = URLRequest(url: image!)
            let imageStr = imagerequest.url?.absoluteString
            UserDefaults.standard.set(email, forKey: "emailId")
            UserDefaults.standard.set(givenName, forKey: "fullName")
            UserDefaults.standard.set(first_name, forKey: "first_name")
            UserDefaults.standard.set(imageStr, forKey: "imageURL")
            print("\(String(describing: userId)), \(String(describing: idToken)), \(String(describing: first_name)), \(String(describing: givenName)), \(String(describing: familyName)), \(String(describing: email))")
            self.callSocialRegiste(username: user_name!,fname: first_name!, lname: givenName!, email: email!, imageSt: imageStr!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (true)
    }
    
    fileprivate func callSocialRegiste(username: String,fname: String, lname: String, email: String, imageSt: String) {
        
        let params : [String : Any] = ["username": username,"first_name": fname,"email": email,"password": "1234","last_name": lname,"usertype_id": "1","is_social_user": "1","social_media_id": "1"]
        KidZoneServiceHandler.share.callRegisterService(params: params, completion: { (success, error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any]{
                        if let userId = dataDictionary["id"] as? String {
                            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewController") as? EditProfileViewController
                            storyBoard?.name = lname
                            storyBoard?.fullName = fname
                            storyBoard?.fullName = username
                            storyBoard?.emailID = email
                            if imageSt == "1" {
                                
                            }else {
                                storyBoard?.profileimage = imageSt
                            }
                            
                            storyBoard?.googleId = userId
                            UserDefaults.standard.set(userId, forKey: "loginId")
                            SVProgressHUD.dismiss()
                            self.navigationController?.pushViewController(storyBoard!, animated: true)
                        }
                    }
                }
                if Int(statusCode) == 100 {
                    if let dataDictionary = success!["data"] as? [String: Any],let message = dataDictionary["message"] as? String {
                        if message == "username address already registered!" {
                            self.callLogin(username: username, email: email, pwd: "1234", login_flag: "social")
                        }else {
                            self.showerror(alertmessage: message)
                        }
                    }
                }
            }
        })
        
    }
    
    fileprivate func callLogin(username: String, email: String, pwd: String, login_flag: String) {
        
        let loginParams : [String : Any] = ["email": email,"password": pwd,"login_flag": login_flag,"username": username]
        KidZoneServiceHandler.share.callLoginService(params: loginParams) { (success, error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    let userDT = UserDetails()
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let user = dataDictionary["user"] as? [[String: Any]] {
                            for userdetails in user {
                                if let first_name = userdetails["first_name"] as? String,let user_ID = userdetails["id"] as? String, let email = userdetails["email"] as? String,let lastname = userdetails["last_name"] as? String,let zipcode = userdetails["zipcode"] as? String{
                                    userDT.firstname = first_name
                                    userDT.lastname = lastname
                                    userDT.email = email
                                    userDT.zipcode = zipcode
                                    userDT.userID = user_ID
                                    UserDefaults.standard.set(email, forKey: "emailId")
                                    UserDefaults.standard.set(first_name, forKey: "first_name")
                                    UserDefaults.standard.set(lastname, forKey: "last_name")
                                    UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                    UserDefaults.standard.set(user_ID, forKey: "id")
                                    // UserDefaults.standard.set(localFieldUserEdit.userIDEdit, forKey: "id")
                                    
                                }
                                self.userDetails?.append(userDT)
                                
                                if userDT.zipcode == "0" {
                                    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewController") as? EditProfileViewController
                                    storyBoard?.emailID = email
                                    storyBoard?.fullName = userDT.lastname
                                    storyBoard?.name = userDT.firstname
                                    //storyBoard?.profileimage = image
                                    SVProgressHUD.dismiss()
                                    self.navigationController?.pushViewController(storyBoard!, animated: true)
                                }
                            }
                        }
                    }
                    if login_flag == "social" {
                        
                        let containerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:
                            "ContainerVC") as? ContainerVC
                        self.navigationController?.present(containerVC!, animated: true, completion: nil)
                    }else {
                        AppDelegate.isLogged = true
                        UserDefaults.standard.set(AppDelegate.isLogged, forKey: "IsLogged")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "gotomain", sender: self)
                    }
                }
                SVProgressHUD.dismiss()
                
                if Int(statusCode) == 100 {
                    if let dataDictionary = success!["data"] as? [String: Any],let message = dataDictionary["message"] as? String {
                        if message == "No user details to retrieve. Please try again" {
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewController") as? EditProfileViewController
                            let email = UserDefaults.standard.value(forKey: "emailId") as? String
                            let fullname = UserDefaults.standard.value(forKey: "fullName") as? String
                            let first_name = UserDefaults.standard.value(forKey: "first_name") as? String
                            let image = UserDefaults.standard.value(forKey: "imageURL") as? String
                            storyBoard?.emailID = email
                            storyBoard?.fullName = fullname
                            storyBoard?.name = first_name
                            storyBoard?.profileimage = image
                            SVProgressHUD.dismiss()
                            self.navigationController?.pushViewController(storyBoard!, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func getUserDetails() {
        let userDT = UserDetails()
        let id = userDT.userID
        KidZoneServiceHandler.share.callGetUserDetails(params: ["user_id":id!]) { (success, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let user = dataDictionary["user"] as? [[String: Any]] {
                            for userdetails in user {
                                if let first_name = userdetails["first_name"] as? String,let user_ID = userdetails["id"] as? String, let email = userdetails["email"] as? String,let lastname = userdetails["last_name"] as? String, let zipcode = userdetails["zipcode"] as? String {
                                    
                                    if zipcode == "0" {
                                        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewController") as? EditProfileViewController
                                        storyBoard?.emailID = email
                                        storyBoard?.fullName = lastname
                                        storyBoard?.name = first_name
                                        //storyBoard?.profileimage = image
                                        SVProgressHUD.dismiss()
                                        self.navigationController?.pushViewController(storyBoard!, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        
        self.reachability = Reachability.init()
        if ((self.reachability!.connection) != .none){
            let username = emailTextFieldOutlet.textField.text
            let password = passwordTextFieldOutlet.textField.text
            
            UserDefaults.standard.set(username, forKey: "username_textfield")
            UserDefaults.standard.set(password, forKey: "password_textfield")
            
            if((username?.isEmpty)! || (password?.isEmpty)! )
            {
                showerror(alertmessage: "Email or Password is Missing")
                
            }
            else{
                SVProgressHUD.show()
                
                let params : [String : Any] = ["username":username!,"password":password!,"login_flag": "username"]
                KidZoneServiceHandler.share.callLoginService(params: params) { (success, error) in
                    guard let statusCode = success!["status_code"] as? String else { return }
                    DispatchQueue.main.async {
                        if Int(statusCode) == 200 {
                            if let dataDictionary = success!["data"] as? [String: Any] {
                                if let user = dataDictionary["user"] as? [[String: Any]] {
                                    for userdetails in user {
                                        let userDT = UserDetails()
                                        if let first_name = userdetails["first_name"] as? String,let user_ID = userdetails["id"] as? String,let username = userdetails["username"] as? String ,let email = userdetails["email"] as? String,let lastname = userdetails["last_name"] as? String, let mobilenumber = userdetails["mobile_no"] as? String,let state = userdetails["state"] as? String,let zipcode = userdetails["zipcode"] as? String, let address = userdetails["address"] as? String {
                                            
                                            // usernameLogin.usernameFromLogin = username saves in local variable
                                            usernameLogin.usernameFromLogin = username
                                            
                                            userDT.username = username
                                            userDT.firstname = first_name
                                            userDT.lastname = lastname
                                            userDT.email = email
                                            userDT.mobilenumber = mobilenumber
                                            userDT.address = address
                                            userDT.zipcode = zipcode
                                            userDT.state = state
                                            userDT.userID = user_ID
                                            UserDefaults.standard.set(email, forKey: "emailId")
                                            UserDefaults.standard.set(first_name, forKey: "first_name")
                                            UserDefaults.standard.set(lastname, forKey: "last_name")
                                            UserDefaults.standard.set(address, forKey: "address")
                                            UserDefaults.standard.set(mobilenumber, forKey: "mobile_no")
                                            UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                            UserDefaults.standard.set(state, forKey: "state")
                                            UserDefaults.standard.set(user_ID, forKey: "id")
                                            UserDefaults.standard.set(username, forKey: "username")
                                            
                                        }
                                        self.userDetails?.append(userDT)
                                    }
                                }
                                let userDetect = self.userDetails?.count
                                if userDetect == 2{
                                    
                                    let providerLogin = 2
                                    UserDefaults.standard.set(providerLogin, forKey: "multiple_account_show")
                                    
                                    SVProgressHUD.dismiss()
                                    self.accountSwitch(alertmessage: "How do you wish to login?")
                                    
                                    print("user as provider also")
                                }
                            }
                            AppDelegate.isLogged = true
                            UserDefaults.standard.set(AppDelegate.isLogged, forKey: "IsLogged")
                            
                            
                            //self.timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.timerLoad), userInfo: nil, repeats: true)
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "gotomain", sender: self)
                        }else {
                            SVProgressHUD.dismiss()
                            self.showerror(alertmessage: "Enter valid Login details")
                        }
                    }
                }
            }
        }else {
            showerror(alertmessage: "No network connection")
        }
    }
    
    //alert function
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        return
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
        
        emailTextFieldOutlet.textField.inputAccessoryView = toolbar
        passwordTextFieldOutlet.textField.inputAccessoryView = toolbar
        emailTextFieldOutlet.textField.keyboardType = .emailAddress
        
    }
    func accountSwitch(alertmessage: String){
        let myAlert = UIAlertController(title:"Login",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let providerAction = UIAlertAction(title: "Provider", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            SVProgressHUD.show()
            self.loginProvider()
            //self.timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.timerLoad), userInfo: nil, repeats: true)
            
            self.performSegue(withIdentifier: "gotomain", sender: self)
            SVProgressHUD.dismiss()
            
            
            
            NSLog("Login as Provider")
        }
        let parentAction = UIAlertAction(title: "Parent", style: UIAlertActionStyle.default) {
            UIAlertAction in
            SVProgressHUD.show()
            
            self.loginParent()
            //self.timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.timerLoad), userInfo: nil, repeats: true)
            
            self.performSegue(withIdentifier: "gotomain", sender: self)
            SVProgressHUD.dismiss()
            NSLog("Login as Parent")
        }
        myAlert.addAction(providerAction)
        myAlert.addAction(parentAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    
    func loginProvider(){
        
        let params : [String : Any] = ["username":UserDefaults.standard.string(forKey: "username_textfield")!,"password":UserDefaults.standard.string(forKey: "password_textfield")!,"login_flag": "username"]
        
        KidZoneServiceHandler.share.callLoginService(params: params) { (success, error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let user = dataDictionary["user"] as? [[String: Any]] {
                            for userdetails in user {
                                let userDT = UserDetails()
                                if let first_name = userdetails["first_name"] as? String,let user_ID = userdetails["id"] as? String,let username = userdetails["username"] as? String ,let email = userdetails["email"] as? String,let lastname = userdetails["last_name"] as? String, let mobilenumber = userdetails["mobile_no"] as? String,let state = userdetails["state"] as? String,let zipcode = userdetails["zipcode"] as? String, let address = userdetails["address"] as? String,let userTypeID = userdetails["usertype_id"] as? String,let address2 = userdetails["address2"] as? String,let city = userdetails["city"] as? String,let country = userdetails["country"] as? String,let userProfile = userdetails["user_profile_url"] as? String,let companyName = userdetails["company_name"] as? String,let website = userdetails["website"] as? String,let description = userdetails["description"] as? String,let parentCompany = userdetails["parent_company"] as? String,let rating = userdetails["rating"] as? String{
                                    
                                    userDT.username = username
                                    userDT.firstname = first_name
                                    userDT.lastname = lastname
                                    userDT.email = email
                                    userDT.mobilenumber = mobilenumber
                                    userDT.address = address
                                    userDT.zipcode = zipcode
                                    userDT.state = state
                                    userDT.userID = user_ID
                                    
                                    userDT.usertypeID = userTypeID
                                    userDT.address2 = address2
                                    userDT.city = city
                                    userDT.country = country
                                    userDT.userProfileURL = userProfile
                                    userDT.companyName = companyName
                                    userDT.website = website
                                    userDT.descriptionMessage = description
                                    userDT.parentCompanyName = parentCompany
                                    userDT.rating = rating
                                    
                                    UserDefaults.standard.set(email, forKey: "emailId")
                                    UserDefaults.standard.set(first_name, forKey: "first_name")
                                    UserDefaults.standard.set(lastname, forKey: "last_name")
                                    UserDefaults.standard.set(address, forKey: "address")
                                    UserDefaults.standard.set(mobilenumber, forKey: "mobile_no")
                                    UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                    UserDefaults.standard.set(state, forKey: "state")
                                    UserDefaults.standard.set(user_ID, forKey: "id")
                                    UserDefaults.standard.set(username, forKey: "username")
                                    UserDefaults.standard.set(userTypeID, forKey: "user_type_id")
                                    UserDefaults.standard.set(address2, forKey: "address2")
                                    UserDefaults.standard.set(city, forKey: "city")
                                    UserDefaults.standard.set(userProfile, forKey: "user_profie_url")
                                    UserDefaults.standard.set(companyName, forKey: "company_name")
                                    UserDefaults.standard.set(website, forKey: "website")
                                    UserDefaults.standard.set(parentCompany, forKey: "parent_company_name")
                                    UserDefaults.standard.set(description, forKey: "description")
                                    let switchUIImg = 20
                                    UserDefaults.standard.set(switchUIImg, forKey: "switch_image")
                                    let providerLogin = 2
                                    UserDefaults.standard.set(providerLogin, forKey: "providerLoginEdit")
                                    print("log as provider")
                                }
                                self.userDetails?.append(userDT)
                            }
                        }
                    }
                }
            }
        }
    }
    func loginParent(){
        
        let params : [String : Any] = ["username":UserDefaults.standard.string(forKey: "username_textfield")!,"password":UserDefaults.standard.string(forKey: "password_textfield")!,"login_flag": "username"]
        KidZoneServiceHandler.share.callLoginService(params: params) { (success, error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        let userDT = UserDetails()
                        if let user = dataDictionary["user"] as? [[String: Any]] {
                            for userdetails in user {
                                if let first_name = userdetails["first_name"] as? String,let user_ID = userdetails["id"] as? String,let username = userdetails["username"] as? String ,let email = userdetails["email"] as? String,let lastname = userdetails["last_name"] as? String, let mobilenumber = userdetails["mobile_no"] as? String,let state = userdetails["state"] as? String,let zipcode = userdetails["zipcode"] as? String, let address = userdetails["address"] as? String {
                                    
                                    // usernameLogin.usernameFromLogin = username saves in local variable
                                    usernameLogin.usernameFromLogin = username
                                    
                                    userDT.username = username
                                    userDT.firstname = first_name
                                    userDT.lastname = lastname
                                    userDT.email = email
                                    userDT.mobilenumber = mobilenumber
                                    userDT.address = address
                                    userDT.zipcode = zipcode
                                    userDT.state = state
                                    userDT.userID = user_ID
                                    UserDefaults.standard.set(email, forKey: "emailId")
                                    UserDefaults.standard.set(first_name, forKey: "first_name")
                                    UserDefaults.standard.set(lastname, forKey: "last_name")
                                    UserDefaults.standard.set(address, forKey: "address")
                                    UserDefaults.standard.set(mobilenumber, forKey: "mobile_no")
                                    UserDefaults.standard.set(zipcode, forKey: "zipcode")
                                    UserDefaults.standard.set(state, forKey: "state")
                                    UserDefaults.standard.set(user_ID, forKey: "id")
                                    UserDefaults.standard.set(username, forKey: "username")
                                    let switchUIImg = 10
                                    UserDefaults.standard.set(switchUIImg, forKey: "switch_image")
                                    let providerLogin = 0
                                    UserDefaults.standard.set(providerLogin, forKey: "providerLoginEdit")
                                    print("log as parent")
                                }
                                self.userDetails?.append(userDT)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    //    var timer = Timer()
    //    var timercount = 6
    //    @objc func timerLoad(){
    //
    //        print("Retrieving details....\(timercount)")
    //        print(timercount)
    //        timercount = timercount - 1
    //        if(timercount == 0){
    //            timercount = 5
    ////            SVProgressHUD.dismiss()
    //            self.performSegue(withIdentifier: "gotomain", sender: self)
    //            timer.invalidate()
    //        }
    //
    //    }
    
}
