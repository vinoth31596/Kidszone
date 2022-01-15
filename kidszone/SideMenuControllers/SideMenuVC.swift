//
//  SideMenuVC.swift
//  Side Menu
//
//  Created by Kyle Lee on 8/6/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
var sidemenu = ContainerVC()
var sideMenuOpen = true
var sideMenuConstraint = ContainerVC()
var accountChange = LoginViewController()
class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, HideSideMenu, GIDSignInUIDelegate{
    
    @IBOutlet weak var userIcon: UIImageView!
    
    @IBOutlet weak var userIconProvider: UIImageView!
    @IBOutlet weak var emailFieldLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var greenIconImg  = ["about_1x","home_1x","profile_1x-1","share_app_1x","chat_now_1x-1","rate_app_1x","terms_conditions_1x","faq_1x","logout_1x"]
    var blackIconImg = ["about_3x-1","home_gre_3x","name_3x","share_app_3x","chat_3x","rate_app_3x","terms_conditions_3x","faq_3x","logout_3x"]
    var menuLables = ["About","Home","Edit Profile","Share the app","My Chats","Rate the app","Terms and Conditions","FAQ","Logout"]
    
    let accountSwitch = UserDefaults.standard.integer(forKey: "multiple_account_show")
    
    override func viewDidLoad() {
        
        userIconProvider.isHidden = true
        if accountSwitch==2{
            userIconProvider.isHidden = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            userIconProvider.isUserInteractionEnabled = true
            userIconProvider.addGestureRecognizer(tapGestureRecognizer)
        }else{
            userIconProvider.isHidden = true
        }
        
        let emailId = UserDefaults.standard.string(forKey: "emailId")
        let userName = UserDefaults.standard.string(forKey: "first_name")
        let imageUrl = UserDefaults.standard.value(forKey: "imageURL") as? String
        emailFieldLabel.text = emailId
        userNameLabel.text = userName
        if let image = imageUrl {
            userIcon.downloadImage(from: image)
        }
        self.userIcon.circleImage()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        super.viewDidLoad()
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let switchImage = UserDefaults.standard.integer(forKey: "switch_image")
        if switchImage==20{
            accountChange.loginParent()
        }else if switchImage == 10 {
            accountChange.loginProvider()
        }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenuClose"), object: nil)
    }
    
    func hideMenu(_ isHidden: Bool) {
        
        if isHidden {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? sliderCell
        cell?.slideMenuLab.text = menuLables[indexPath.row]
        let icons = UIImage(named: blackIconImg[indexPath.row])
        cell?.icons.image = icons
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? sliderCell
        cell?.slideMenuLab.textColor = UIColor(red: 0.3686, green: 0.7569, blue: 0.5333, alpha: 1.0)
        let icons = UIImage(named: greenIconImg[indexPath.row])
        if indexPath.row == 8 {
            showerror(alertmessage: "Do you really want to logout?")
        }else if indexPath.row == 0{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            nextViewController.hideMenuDelegate = self
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 1{
            
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenuClose"), object: nil)
            
        }else if indexPath.row == 2{
            
            
            if UserDefaults.standard.integer(forKey: "providerLoginEdit") == 2{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProviderProfileNext") as! EditProfileProviderViewController
                nextViewController.hideMenuDelegate = self
                self.present(nextViewController, animated:true, completion:nil)
                
            }else{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditProfileViewController
                nextViewController.hideMenuDelegate = self
                self.present(nextViewController, animated:true, completion:nil)
            }
            
        }else if indexPath.row == 3{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShareAppViewController") as! ShareAppViewController
            nextViewController.hideMenuDelegate = self
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 4{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyChatViewController") as! MyChatViewController
            nextViewController.hideMenuDelegate = self
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 5{
            
        }else if indexPath.row == 6{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsConditionViewController") as! TermsConditionViewController
            nextViewController.hideMenuDelegate = self
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 7{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            nextViewController.hideMenuDelegate = self
            self.present(nextViewController, animated:true, completion:nil)
        }
        cell?.icons.image = icons
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? sliderCell
        cell?.slideMenuLab.textColor = .black
        let icons = UIImage(named: blackIconImg[indexPath.row])
        cell?.icons.image = icons
    }
    
    func showerror(alertmessage: String){
        let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            AppDelegate.isGoogleLogin = UserDefaults.standard.bool(forKey: "googleLogin")
            if AppDelegate.isGoogleLogin {
                AppDelegate.isGoogleLogout = true
            }else {
                AppDelegate.isFBLogout = true
            }
            
            AppDelegate.isLogged = false
            UserDefaults.standard.set(AppDelegate.isLogged, forKey: "IsLogged")
            //            let username = ""
            //            let password = ""
            //            let providerLogin = 0
            //            UserDefaults.standard.set(providerLogin, forKey: "providerLoginEdit")
            //            UserDefaults.standard.set(username, forKey: "username_textfield")
            //            UserDefaults.standard.set(password, forKey: "password_textfield")
            UserDefaults.standard.removeObject(forKey: "username_textfield")
            UserDefaults.standard.removeObject(forKey: "password_textfield")
            UserDefaults.standard.removeObject(forKey: "providerLoginEdit")
            UserDefaults.standard.removeObject(forKey: "multiple_account_show")
            NotificationCenter.default.post(name: NSNotification.Name("LoginViewController"), object: nil)
            NSLog("Logout Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    
}
