//
//  OpenCL.swift
//  kidszone
//
//  Created by Admin on 6/26/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class CollectFilter: NSObject {
    
    var id: String?
    var services_green: String?
    var name: String?
    var services_white: String?
    var services_log: String?
    
}

class UserDetails: NSObject{
    
    var username: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var password: String?
    var mobilenumber: String?
    var address: String?
    var state: String?
    var zipcode: String?
    var userID: String?
    
    var usertypeID: String?
    var countryCode: String?
    var address2: String?
    var areaName: String?
    var city: String?
    var country: String?
    var userProfileURL: String?
    var companyName: String?
    var website: String?
    var descriptionMessage: String?
    var latitude: String?
    var longitude: String?
    var parentCompanyName: String?
    var companyImage: String?
    var rating: String?
    
}

class alert {
    
    func msg(message: String, title: String = "")
    {
        let alertView = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}

////alert function
//func showerror(alertmessage: String){
//    let myAlert = UIAlertController(title:"Alert",message:alertmessage,preferredStyle:UIAlertControllerStyle.alert)
//    let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default, handler: nil)
//    myAlert.addAction(okAction)
//    self.present(myAlert, animated: true, completion: nil)
//
//    return
//}

