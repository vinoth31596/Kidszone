//
//  Branch.swift
//  kidszone
//
//  Created by iMac on 13/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import Foundation

class Branch: NSObject {
    
    var id: String?
    var user_id: String?
    var service_id: String?
    var name: String?
    var country_code: String?
    var company_name: String?
    var mobile_no: String?
    var descript: String?
    var address: String?
    var address2: String?
    var city: String?
    var state: String?
    var country: String?
    var zipcode: String?
    var latitude: String?
    var longitude: String?
    var photo_url1: String?
    var photo_url2: String?
    var photo_url3: String?
    var photo_url4: String?
    var photo_url5: String?
    var user_profile_url: String?
    var bussiness_hour: String?
    var rating: String?
    var is_approved: String?
    var distance: String?
    var no_reviews: String?
    var main_branch: String?
    var created_datetime: String?
    var modified_datetime: String?
}

class Branch_Details: NSObject {
    
    var id: String?
    var user_id: String?
    var service_id: String?
    var name: String?
    var country_code: String?
    var mobile_no: String?
    var descript: String?
    var address: String?
    var address2: String?
    var city: String?
    var state: String?
    var country: String?
    var zipcode: String?
    var latitude: String?
    var longitude: String?
    var photo_url1: String?
    var photo_url2: String?
    var photo_url3: String?
    var photo_url4: String?
    var photo_url5: String?
    var bussiness_hour: String?
    var rating: String?
    var is_approved: String?
    var distance: String?
    var no_reviews: String?
    var main_branch: String?
    var created_datetime: String?
    var modified_datetime: String?
}

open class ProviderName: NSObject {
    
    var pro_name_id: String?
    var pro_name_company_name: String?
    var pro_name_email: String?
    var pro_name_mobile_no: String?
    var pro_name_first_name: String?
    var pro_name_last_name: String?
    var pro_name_address: String?
    var pro_name_address2: String?
    var pro_name_city: String?
    var pro_name_state: String?
    var pro_name_country: String?
    var pro_name_zipcode: String?
    var pro_name_user_profile_url: String?
    var pro_name_website: String?
    var pro_name_description: String?
}

open class SearchKeys: NSObject {
    
    var search_keys_id: String?
    var search_keys_name: String?
    var search_keys_service_log: String?
    var search_keys_service_green: String?
    var search_keys_service_white: String?
    var search_name_company_name: String?
    
}
