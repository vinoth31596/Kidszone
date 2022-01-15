//
//  MainVC.swift
//  Side Menu
//
//  Created by Kyle Lee on 8/6/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import CoreLocation


class MainVC: UIViewController, CLLocationManagerDelegate, getBranchDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var classesCollectView: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var cityNameLab: UILabel!
    
    let locationManager = CLLocationManager()
    var branch: [Branch]? = []
    var colFilter: [CollectFilter]? = []
    var provider_details = [ProviderName]()
    var provider_Branch_Details: [Branch_Details]? = []
    var zipcode = String()
    var TabName: String?
    var isSelectedTab = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collecFilter = CollectFilter()
        collecFilter.services_log = "all_icon_gre_1x"
        collecFilter.services_green = "all_icon_green_1x"
        collecFilter.name = "All"
        colFilter?.append(collecFilter)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo_whi")
        imageView.image = image
        navigationItem.titleView = imageView
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.cardView.shadowView(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        getFilter()
        
        //        let rightFilterBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainVC.addTapped))
        //
        //        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(MainVC.searchTapped))
        
        //create a new button
        let rightFilterBarButtonItem: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        rightFilterBarButtonItem.setImage(UIImage(named: "filter_1x"), for: UIControlState.normal)
        //add function for button
        rightFilterBarButtonItem.addTarget(self, action: #selector(MainVC.addTapped), for: UIControlEvents.touchUpInside)
        //set frame
        rightFilterBarButtonItem.frame = CGRect(x: 0,y: 0,width: 40,height: 31)
        //CGRectMake(0, 0, 53, 31)
        let barButtonFilter = UIBarButtonItem(customView: rightFilterBarButtonItem)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonFilter
        
        
        let rightSearchBarButtonItem: UIButton = UIButton(type: UIButtonType.custom)
        rightSearchBarButtonItem.setImage(UIImage(named: "search_1x"), for: UIControlState.normal)
        rightSearchBarButtonItem.addTarget(self, action: #selector(MainVC.searchTapped), for: UIControlEvents.touchUpInside)
        rightSearchBarButtonItem.frame = CGRect(x: 0,y: 0,width: 30,height: 31)
        let barButtonSearch = UIBarButtonItem(customView: rightSearchBarButtonItem)
        //self.navigationItem.rightBarButtonItem = barButtonSearch
        self.navigationItem.rightBarButtonItems = [barButtonSearch,barButtonFilter]
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GoToLogin),
                                               name: NSNotification.Name("LoginViewController"),
                                               object: nil)
    }
    
    @objc func GoToLogin(){
        performSegue(withIdentifier: "gotologin", sender: self)
    }
    func call_Get_Branch(_ km: String, _ rating: String, _ isSelectedID: String) {
        
        let user_id = UserDefaults.standard.value(forKey: "id") as? String
        if let userid = user_id {
            self.callBranch(self.zipcode, isSelectedID, rating, km, userid)
        }
    }
    
    func getFilter() {
        
        KidZoneServiceHandler.share.callGetAllLKServices { (success, Error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                self.colFilter = [CollectFilter]()
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let serviceDic = dataDictionary["services"] as? [[String: Any]] {
                            for serDictionary in serviceDic {
                                let collectFilterValue = CollectFilter()
                                if let id = serDictionary["id"] as? String, let services_green = serDictionary["services_green"] as? String, let name = serDictionary["name"] as? String, let services_white  = serDictionary["services_white"] as? String, let services_log = serDictionary["services_log"] as? String {
                                    
                                    collectFilterValue.id = id
                                    collectFilterValue.name = name
                                    collectFilterValue.services_green = "http://13.126.125.165/kidzone/\(services_green)"
                                    collectFilterValue.services_white = "http://13.126.125.165/kidzone/\(services_white)"
                                    collectFilterValue.services_log = "http://13.126.125.165/kidzone/\(services_log)"
                                }
                                self.colFilter?.append(collectFilterValue)
                            }
                        }
                        self.filterCollectionView.reloadData()
                    }
                }
            }
        }
    }
    fileprivate func callGetProviderDetails(isSelectedID: String, isSelectedName: String) {
        TabName = isSelectedName
        let params = ["id": isSelectedID]
        KidZoneServiceHandler.share.callGetProviderDetails(params: params) { (success, error) in
            
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                self.branch = [Branch]()
                self.provider_Branch_Details = [Branch_Details]()
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let provider_details = dataDictionary["provider_details"] as? [[String: Any]] {
                            for pro_Details in provider_details {
                                let pro_brance = Branch()
                            
                                if let company_name = pro_Details["company_name"] as? String {
                                    pro_brance.company_name = company_name
                                }
                                if let mobile_No = pro_Details["mobile_no"] as? String {
                                    
                                    pro_brance.mobile_no = mobile_No
                                }
                                if let user_profile = pro_Details["user_profile_url"] as? String {
                                    pro_brance.user_profile_url = user_profile
                                }
                                if let address = pro_Details["address"] as? String {
                                    pro_brance.address = address
                                }
                                if let address2 = pro_Details["address2"] as? String {
                                    pro_brance.address2 = address2
                                }
                                self.branch?.append(pro_brance)
                            }
                            
                            if let provider_Branch = dataDictionary["branch_details"] as? [[String: Any]] {
                                for pro_Branch in provider_Branch {
                                    let provider_Branch = Branch_Details()
                                    if let pro_Branch_description = pro_Branch["description"] as? String {
                                        provider_Branch.descript = pro_Branch_description
                                    }
                                    if let provider_name = pro_Branch["name"] as? String {
                                        provider_Branch.name = provider_name
                                    }
                                    if let provider_state = pro_Branch["state"] as? String {
                                        provider_Branch.state = provider_state
                                    }
                                    if let provider_city = pro_Branch["city"] as? String {
                                        provider_Branch.city = provider_city
                                    }
                                    if let provider_business_hours = pro_Branch["bussiness_hour"] as? String {
                                         provider_Branch.bussiness_hour = provider_business_hours
                                    }
                                    self.provider_Branch_Details?.append(provider_Branch)
                                }
                            }
                        }
                        self.classesCollectView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func callBranch(_ zipcode: String, _ servive_id: String, _ rating: String, _ distance: String, _ user_ID: String) {
        
        KidZoneServiceHandler.share.callGetBranchData(params: ["zipcode": zipcode, "rating": rating, "distance": distance, "service_id": servive_id, "user_id": user_ID]) { (success, error) in
            self.branch = [Branch]()
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let provider_branch = dataDictionary["provider_branch"] as? [[String: Any]] {
                            for pro_branch in provider_branch {
                                let branchDta = Branch()
                                if let id = pro_branch["id"] as? String, let user_id = pro_branch["user_id"] as? String, let name = pro_branch["name"] as? String, let service_id  = pro_branch["service_id"] as? String, let country_code = pro_branch["country_code"] as? String, let mobile_no = pro_branch["mobile_no"] as? String,let address = pro_branch["address"] as? String,let city = pro_branch["city"] as? String, let state = pro_branch["state"] as? String, let zipcode = pro_branch["zipcode"] as? String,let country = pro_branch["country"] as? String {
                                    
                                    branchDta.id = id
                                    branchDta.user_id = user_id
                                    branchDta.service_id = service_id
                                    branchDta.name = name
                                    branchDta.country_code = country_code
                                    branchDta.address = address
                                    branchDta.mobile_no = mobile_no
                                    branchDta.city = city
                                    branchDta.country = country
                                    branchDta.state = state
                                    branchDta.zipcode = zipcode
                                }
                                if let latitude = pro_branch["latitude"] as? String,let longitude = pro_branch["longitude"] as? String,let photo_url1 = pro_branch["photo_url1"] as? String, let photo_url2 = pro_branch["photo_url2"] as? String, let photo_url3 = pro_branch["photo_url3"] as? String, let photo_url4 = pro_branch["photo_url4"] as? String, let photo_url5 = pro_branch["photo_url5"] as? String, let bussiness_hour = pro_branch["bussiness_hour"] as? String,let rating = pro_branch["rating"] as? String,let is_approved = pro_branch["is_approved"] as? String,let distance = pro_branch["distance"] as? String, let description = pro_branch["description"] as? String,let address2 = pro_branch["address2"] as? String {
                                    
                                    branchDta.is_approved = is_approved
                                    branchDta.latitude = latitude
                                    branchDta.longitude = longitude
                                    branchDta.photo_url1 = photo_url1
                                    branchDta.photo_url2 = photo_url2
                                    branchDta.photo_url3 = photo_url3
                                    branchDta.photo_url4 = photo_url4
                                    branchDta.photo_url5 = photo_url5
                                    branchDta.bussiness_hour = bussiness_hour
                                    branchDta.rating = rating
                                    branchDta.distance = distance
                                    branchDta.descript = description
                                    branchDta.address2 = address2
                                }
                                self.branch?.append(branchDta)
                            }
                        }
                        self.classesCollectView.reloadData()
                    }
                }else if Int(statusCode) == 100 {
                    self.classesCollectView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
                self.callBranch(self.zipcode, "","", "", "")
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            zipcode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode! : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            if let city = self.cityNameLab, let userName = self.userNameLab {
                city.text = locality
                let userName1 = UserDefaults.standard.value(forKey: "first_name") as? String
                userName.text = "Welcome Mr.\(userName1!)"
            }
            
            print(locality!)
            print(zipcode)
            print(administrativeArea!)
            print(country!)
            
        }
    }
    
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            //popup.removeFromSuperview()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        let postalcode = UserDefaults.standard.value(forKey: "zipcode") as? String
        if let zcode = postalcode {
            self.callBranch(zcode, "","", "", "")
        }
    }
    
    @objc func searchTapped(sender:UIButton) {
        let search_storyVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
        self.navigationController?.pushViewController(search_storyVC!, animated: true)
    }
    
    @objc func addTapped (sender:UIButton) {
        let filter_storyVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        filter_storyVC?.get_Branch_Delegate = self
        self.navigationController?.pushViewController(filter_storyVC!, animated: true)
    }
    
    @IBAction func onMoreTapped() {
        print("TOGGLE SIDE MENU")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterCollectionView {
            return colFilter?.count ?? 0
        }
        else {
            return self.branch?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filter_Cell", for: indexPath) as? filter_Cell
            cell?.Fname.text = colFilter?[indexPath.row].name
            let image = colFilter?[indexPath.row].services_log
            if image == "all_icon_gre_1x" {
                
                cell?.Ficons.image = UIImage(named: image!)
            }else {
                cell?.Ficons.downloadImage(from: image!)
            }
            
            return cell!
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pro_name_Details_Cell", for: indexPath) as? pro_name_Details_Cell
            cell?.Ficons.image = UIImage(named: "building_bl3x")
            if (self.branch?.count)! > 0 {
                cell?.Fname.text = self.branch?[indexPath.row].name
            }
            cell?.cardView.shadowView(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.filterCollectionView {
            isSelectedTab = true
            let selectedID = colFilter?[indexPath.row].id
            let selectedName = colFilter?[indexPath.row].name
            UserDefaults.standard.set(selectedID, forKey: "selectedID")
            let cell = collectionView.cellForItem(at: indexPath) as? filter_Cell
//            let user_id = UserDefaults.standard.value(forKey: "id") as? String
//            let service_id = colFilter?[indexPath.row].id
            let image = colFilter?[indexPath.row].services_green
            if image == "all_icon_green_1x" {
                cell?.Ficons.image = UIImage(named: image!)
            }else {
                cell?.Ficons.downloadImage(from: image!)
            }
            self.callGetProviderDetails(isSelectedID: selectedID!, isSelectedName: selectedName!)
        }else {
            
            let select_cell_storyboard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
            let name = self.branch?[indexPath.row].company_name
            let address = self.branch?[indexPath.row].address
            var state: String?
            var city: String?
            var working_days: String?
            var mobile_no: String?
            
            if isSelectedTab {
                state = self.provider_Branch_Details?[indexPath.row].state
                city = self.provider_Branch_Details?[indexPath.row].city
                working_days = self.provider_Branch_Details?[indexPath.row].bussiness_hour
            }else {
                state = self.branch?[indexPath.row].state
                city = self.branch?[indexPath.row].city
                mobile_no = self.branch?[indexPath.row].mobile_no
            }
            
            select_cell_storyboard?.title_name = TabName
            if let selec_name = name, let selec_address = address {
                select_cell_storyboard?.address = selec_name  + selec_address
            }
            
            select_cell_storyboard?.detail_tl = name
            if let selec_city = city, let selec_state = state {
                select_cell_storyboard?.detail_ST = selec_city + selec_state
            }
            select_cell_storyboard?.number = mobile_no
            select_cell_storyboard?.detail_working_days = working_days
            select_cell_storyboard?.detail_icon = UIImage(named: "building_bl3x")
            self.navigationController?.pushViewController(select_cell_storyboard!, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == self.filterCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? filter_Cell
            let image = colFilter?[indexPath.row].services_log
            if image == "all_icon_gre_1x" {
                cell?.Ficons.image = UIImage(named: image!)
            }else {
                cell?.Ficons.downloadImage(from: image!)
            }
        }
    }
}
