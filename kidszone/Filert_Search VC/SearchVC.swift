//
//  SearchVC.swift
//  kidszone
//
//  Created by Admin on 6/26/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ModernSearchBarDelegate {
    
    @IBOutlet weak var ModernSearchBar: ModernSearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search_tbl: UITableView!
    var providerName: [ProviderName]? = []
    var branch_DT: [Branch_Details]? = []
    var search_keys: [SearchKeys]? = []
    var filterArr: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makingSearchBarAwesome()
        
        
        collectionView.isHidden = true
        
        callSearchKeys()
    }
    
    fileprivate func callSearchKeys() {
        
        KidZoneServiceHandler.share.callGetKeys { (success, error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                self.search_keys = [SearchKeys]()
                var suggestionListWithUrl = Array<ModernSearchBarModel>()
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        //                        if let services = dataDictionary["services"] as? [[String: Any]] {
                        //                            for ser_Details in services {
                        //                                let keys = SearchKeys()
                        //                                if let name = ser_Details["name"] as? String {
                        //                                    print("company_name:::\(name)")
                        //                                    keys.search_keys_name = name
                        //                                }
                        //                                self.search_keys?.append(keys)
                        //                            }
                        //                        }
                        if let provider_details = dataDictionary["provider_details"] as? [[String: Any]] {
                            for pro_Details in provider_details {
                                let keys = SearchKeys()
                                if let company_name = pro_Details["company_name"] as? String {
                                    print("company_name:::\(company_name)")
                                    keys.search_name_company_name = company_name
                                }
                                self.search_keys?.append(keys)
                                suggestionListWithUrl.append(ModernSearchBarModel(title: keys.search_name_company_name ?? "T"))
                                ///Adding delegate
                                self.ModernSearchBar.delegateModernSearchBar = self
                                
                                ///Set datas to search bar
                                self.ModernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)
                                self.configureSearchBarWithUrl()
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func callSearchData(_ pro_name: String) {
        
        let params = ["search_name": pro_name]
        
        KidZoneServiceHandler.share.callGetSearchData(params: params) { (success, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                self.providerName = [ProviderName]()
                self.branch_DT = [Branch_Details]()
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let provider_name = dataDictionary["provider_name"] as? [[String: Any]] {
                            for pro_name in provider_name { // some time last name, address is empty so need to Rearrange the order...
                                let pro_name_details = ProviderName()
                                if let id = pro_name["id"] as? String, let company_name = pro_name["company_name"] as? String, let email = pro_name["email"] as? String, let first_name  = pro_name["first_name"] as? String, let last_name = pro_name["last_name"] as? String, let mobile_no = pro_name["mobile_no"] as? String, let descrip = pro_name["description"] as? String,let address = pro_name["address"] as? String,let address2 = pro_name["address2"] as? String,let city = pro_name["city"] as? String, let state = pro_name["state"] as? String, let zipcode = pro_name["zipcode"] as? String,let country = pro_name["country"] as? String,let user_profile_url = pro_name["user_profile_url"] as? String, let website = pro_name["website"] as? String, let branch_details = pro_name["branch_details"] as? [[String: Any]] {
                                    pro_name_details.pro_name_id = id
                                    pro_name_details.pro_name_address = address
                                    pro_name_details.pro_name_address2 = address2
                                    pro_name_details.pro_name_city = city
                                    pro_name_details.pro_name_email = email
                                    pro_name_details.pro_name_state = state
                                    pro_name_details.pro_name_country = country
                                    pro_name_details.pro_name_website = website
                                    pro_name_details.pro_name_zipcode = zipcode
                                    pro_name_details.pro_name_last_name = last_name
                                    pro_name_details.pro_name_first_name = first_name
                                    pro_name_details.pro_name_company_name = company_name
                                    pro_name_details.pro_name_description = descrip
                                    pro_name_details.pro_name_mobile_no = mobile_no
                                    pro_name_details.pro_name_user_profile_url = user_profile_url
                                    print(branch_details)
                                    for branch_DT in branch_details {
                                        let branch_Details = Branch_Details()
                                        if let id = branch_DT["id"] as? String, let user_id = branch_DT["user_id"] as? String, let name = branch_DT["name"] as? String, let service_id  = branch_DT["service_id"] as? String, let country_code = branch_DT["country_code"] as? String, let mobile_no = branch_DT["mobile_no"] as? String, let description = branch_DT["description"] as? String,let address = branch_DT["address"] as? String,let address2 = branch_DT["address2"] as? String,let city = branch_DT["city"] as? String, let state = branch_DT["state"] as? String, let zipcode = branch_DT["zipcode"] as? String,let country = branch_DT["country"] as? String,let bussiness_hour = branch_DT["bussiness_hour"] as? String {
                                            branch_Details.id = id
                                            branch_Details.user_id = user_id
                                            branch_Details.service_id = service_id
                                            branch_Details.name = name
                                            branch_Details.country_code = country_code
                                            branch_Details.address = address
                                            branch_Details.address2 = address2
                                            branch_Details.mobile_no = mobile_no
                                            branch_Details.descript = description
                                            branch_Details.city = city
                                            branch_Details.bussiness_hour = bussiness_hour
                                            branch_Details.country = country
                                            branch_Details.state = state
                                            branch_Details.zipcode = zipcode
                                            
                                            if let latitude = branch_DT["latitude"] as? String,let longitude = branch_DT["longitude"] as? String,let photo_url1 = branch_DT["photo_url1"] as? String, let photo_url2 = branch_DT["photo_url2"] as? String, let photo_url3 = branch_DT["photo_url3"] as? String, let photo_url4 = branch_DT["photo_url4"] as? String, let photo_url5 = branch_DT["photo_url5"] as? String,let rating = branch_DT["rating"] as? String,let is_approved = branch_DT["is_approved"] as? String,let distance = branch_DT["distance"] as? String {
                                                
                                                branch_Details.latitude = latitude
                                                branch_Details.longitude = longitude
                                                branch_Details.photo_url1 = photo_url1
                                                branch_Details.photo_url2 = photo_url2
                                                branch_Details.photo_url3 = photo_url3
                                                branch_Details.photo_url4 = photo_url4
                                                branch_Details.photo_url5 = photo_url5
                                                branch_Details.rating = rating
                                                branch_Details.distance = distance
                                                branch_Details.is_approved = is_approved
                                            }
                                        }
                                        self.branch_DT?.append(branch_Details)
                                        self.providerName?.append(pro_name_details)
                                    }
                                }
                            }
                            self.collectionView.isHidden = false
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return providerName?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pro_Details_cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "pro_name_Details_Cell", for: indexPath) as? pro_name_Details_Cell
        pro_Details_cell?.Fname.text = providerName?[indexPath.row].pro_name_company_name
        pro_Details_cell?.Ficons.image = UIImage(named: "building_bl3x")
        return pro_Details_cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let select_cell_storyboard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        let name = self.providerName?[indexPath.row].pro_name_company_name
        let desc_str = self.branch_DT?[indexPath.row].descript
        let address = self.branch_DT?[indexPath.row].address
        let state = self.branch_DT?[indexPath.row].state
        let city = self.branch_DT?[indexPath.row].city
        let working_days = self.branch_DT?[indexPath.row].bussiness_hour
        let mobile_no = self.branch_DT?[indexPath.row].mobile_no
        select_cell_storyboard?.title_name = "Classes"
        select_cell_storyboard?.address = name! + address!
        select_cell_storyboard?.detail_tl = name
        select_cell_storyboard?.detail_ST = city! + state!
        select_cell_storyboard?.detail_description = desc_str
        select_cell_storyboard?.detail_working_days = working_days!
        select_cell_storyboard?.number = mobile_no
        select_cell_storyboard?.detail_icon = UIImage(named: "building_bl3x")
        self.navigationController?.pushViewController(select_cell_storyboard!, animated: true)
    }
    
    //----------------------------------------
    // OPTIONNAL DELEGATE METHODS
    //----------------------------------------
    
    
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
    }
    
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title)
        self.ModernSearchBar.text = item.title
        self.callSearchData(item.title)
    }
    
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change, what i'm suppose to do ?")
    }
    
    //----------------------------------------
    // CONFIGURE SEARCH BAR (TWO WAYS)
    //----------------------------------------
    
    // Configure search bar with a list of ModernSearchBarModel (If you want to show also an image from an url)
    
    private func configureSearchBarWithUrl(){
        
        ///Increase size of suggestionsView icon
        self.ModernSearchBar.suggestionsView_searchIcon_height = 40
        self.ModernSearchBar.suggestionsView_searchIcon_width = 40
        
        ///Custom design with all paramaters
        //self.customDesign()
        
    }
    
    //----------------------------------------
    // CUSTOM DESIGN (WITH ALL OPTIONS)
    //----------------------------------------
    
    private func customDesign(){
        
        // --------------------------
        // Enjoy this beautiful customizations (It's a joke...)
        // --------------------------
        
        
        //Modify shadows alpha
        self.ModernSearchBar.shadowView_alpha = 0.8
        
        //Modify the default icon of suggestionsView's rows
        self.ModernSearchBar.searchImage = ModernSearchBarIcon.Icon.none.image
        
        //Modify properties of the searchLabel
        self.ModernSearchBar.searchLabel_font = UIFont(name: "Avenir-Light", size: 30)
        self.ModernSearchBar.searchLabel_textColor = UIColor.red
        self.ModernSearchBar.searchLabel_backgroundColor = UIColor.black
        
        //Modify properties of the searchIcon
        self.ModernSearchBar.suggestionsView_searchIcon_height = 40
        self.ModernSearchBar.suggestionsView_searchIcon_width = 40
        self.ModernSearchBar.suggestionsView_searchIcon_isRound = false
        
        //Modify properties of suggestionsView
        ///Modify the max height of the suggestionsView
        self.ModernSearchBar.suggestionsView_maxHeight = 1000
        ///Modify properties of the suggestionsView
        self.ModernSearchBar.suggestionsView_backgroundColor = UIColor.brown
        self.ModernSearchBar.suggestionsView_contentViewColor = UIColor.yellow
        self.ModernSearchBar.suggestionsView_separatorStyle = .singleLine
        self.ModernSearchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray
        self.ModernSearchBar.suggestionsView_verticalSpaceWithSearchBar = 10
        self.ModernSearchBar.suggestionsView_spaceWithKeyboard = 20
    }
    
    private func makingSearchBarAwesome(){
        self.ModernSearchBar.backgroundImage = UIImage()
        self.ModernSearchBar.layer.borderWidth = 0
        self.ModernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
    }
}
