//
//  Constant.swift
//  kidszone
//
//  Created by Admin on 7/9/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import Firebase

struct Constants
{
    static let userid = UserDefaults.standard.value(forKey: "id") as? String
    static let selectedID = UserDefaults.standard.value(forKey: "selectedID") as? String
    
    struct refs
    {
       
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("messages").child("\(Constants.userid!)_\(Constants.selectedID!)")
    }
}
