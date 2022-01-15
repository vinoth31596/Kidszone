//
//  KidZoneServiceHandler.swift
//  kidszone
//
//  Created by Admin on 6/21/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import Foundation

class KidZoneServiceHandler {
    
    static let share = KidZoneServiceHandler()
    private init(){}
    
    
    //MARK: - Enum
    fileprivate enum serviceHadler { // http://13.126.125.165/kidzone/users1/get_provider_id
        enum url {
            static let baseUrl = "http://13.126.125.165"
            // static let baseUrl = ""
            static let kidzoneUrl = ("\(serviceHadler.url.baseUrl)/kidzone")
            static let kidzoneUserUrl = ("\(serviceHadler.url.kidzoneUrl)/users1")
            static let kidzonelk_serviceUrl = ("\(serviceHadler.url.kidzoneUrl)/lk_services")
            static let kidzoneServicesUrl = ("\(serviceHadler.url.kidzoneUrl)/services")
            static let kidzoneBranch = ("\(serviceHadler.url.kidzoneUrl)/branch")
            static let kidzoneSearch = ("\(serviceHadler.url.kidzoneUrl)/search")
            
            static let registerUrl = ("\(serviceHadler.url.kidzoneUserUrl)/user_sign_up")
            static let loginUrl = ("\(serviceHadler.url.kidzoneUserUrl)/login")
            static let forgotPasswordUrl = ("\(serviceHadler.url.kidzoneUserUrl)/forgot_password")
            static let changePasswordUrl = ("\(serviceHadler.url.kidzoneUserUrl)/change_password")
            static let update_User_DetailsUrl = ("\(serviceHadler.url.kidzoneUserUrl)/update_user_details")
            static let add_lk_serviceUrl = ("\(serviceHadler.url.kidzonelk_serviceUrl)/add_lk_service")
            static let update_lk_serviceUrl = ("\(serviceHadler.url.kidzonelk_serviceUrl)/update_lk_services")
            static let get_lk_service_detailsUrl = ("\(serviceHadler.url.kidzonelk_serviceUrl)/get_lk_services_details_by_id")
            static let get_all_lk_serviceUrl = ("\(serviceHadler.url.kidzonelk_serviceUrl)/get_all_lk_services")
            static let add_services_userod = ("\(serviceHadler.url.kidzoneServicesUrl)/add_services_userid")
            static let get_user_details = ("\(serviceHadler.url.kidzoneUserUrl)/get_user_details_by_id")
            static let get_branch_by_zipcode = ("\(serviceHadler.url.kidzoneBranch)/get_branch_by_zipcode")
            static let get_search = ("\(serviceHadler.url.kidzoneSearch)/get_search")
            static let get_keys = ("\(serviceHadler.url.kidzonelk_serviceUrl)/get_all_lk_services")
            static let get_provider_details = ("\(kidzoneUserUrl)/get_provider_id")
            
        }
        enum method {
            static let get = "GET"
            static let post = "POST"
            static let put = "PUT"
            static let delete = "DELETE"
        }
    }
    
    typealias completionHandler = (_ success: AnyObject?, _ failure: Error?) -> Void
    
    //MARK: - Common Service Handler
    
    fileprivate func callService(forUrlRequest serviceUrlRequest: URLRequest, _ completionHandler: @escaping completionHandler) {
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let serviceTask = urlSession.dataTask(with: serviceUrlRequest, completionHandler: { data, response, error in
            if error == nil {
                do {
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(strData as Any)
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        completionHandler(json as AnyObject, error)
                        return
                    }
                }
                catch let error {
                    completionHandler("" as AnyObject, error)
                    return
                }
            }
            completionHandler("" as AnyObject, nil)
        })
        serviceTask.resume()
    }
    
    fileprivate func getBodyRequest(forDictionary inputDictionary: [String: Any]) -> Data {
        var finalString: String?
        for (key, value) in inputDictionary {
            if let str = value as? String {
                print(str)
                if finalString == nil {
                    finalString = "\(key)=\(str)"
                } else {
                    finalString = finalString! + "&\(key)=\(str)"
                }
            }
        }
        return (finalString ?? "").data(using: .utf8)!
    }
    
    func callRegisterService(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        
        let serviceUrl = serviceHadler.url.registerUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callLoginService(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.loginUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callUpdateUserDetails(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.update_User_DetailsUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callGetAllLKServices(completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_all_lk_serviceUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callGetUserDetails(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_user_details
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        callService(forUrlRequest: urlRequest, completion)
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
    }
    //http://13.126.125.165/kidzone/users1/forgot_password
    func callForgotPassword(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.forgotPasswordUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    func callChangePassword(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.changePasswordUrl
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callGetBranchData(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_branch_by_zipcode
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callGetSearchData(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_search
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
    
    func callGetKeys(completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_keys
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        callService(forUrlRequest: urlRequest, completion)
    }

    func callGetProviderDetails(params inputDictionary: [String: Any], completion:@escaping completionHandler) {
        let serviceUrl = serviceHadler.url.get_provider_details
        var urlRequest = URLRequest(url: Foundation.URL(string: serviceUrl)!)
        urlRequest.httpMethod = serviceHadler.method.post
        urlRequest.httpBody = getBodyRequest(forDictionary: inputDictionary)
        callService(forUrlRequest: urlRequest, completion)
    }
}
