//
//  SecondSelectTypeTableView.swift
//  Bloom
//
//  Created by Serik on 25.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit



class SecondSelectTypeTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int) { // ADDED
        // ADDED
    } // ADDED

    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var background: UIImageView!
    @IBOutlet var backButtonView: UIView!
    @IBOutlet var selectService: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sections = [Section]()
    var selectedPaths: [IndexPath] = []
    var features = UserModel.info().children
    var type = UserModel.info().type
    var info = UserModel.info().getDataFromUserDefault()
    var feature = UserModel.info().getFeature()
    var placeID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeature()
        
        
        if UserModel.info().typeOfPage{
            self.automaticallyAdjustsScrollViewInsets = false
            self.extendedLayoutIncludesOpaqueBars = true
            
            placeID = info["placeID"] as! Int
            backButtonView.isHidden = true
            background.isHidden = true
            selectService.textColor = UIColor.black
            doneButton.setTitle("Сохранить", for: .normal)
    
            let coll = feature["featureSubChild"] as! [Int]
            
            
            var count = 0
            var count1 = 0
            for i in features{
                count1 = 0
                for j in i.children{
                    if(coll.contains(j.id)){
                        selectedPaths.append([count,count1])
                        selectedType.append(j.id)
                    }
                    count1 += 1
                }
                count += 1
            }
        }
    }
    
    func getFeature(){
        for parent in features{
            var qwe = [String]()
            for children in parent.children{
                qwe.append(children.name)
            }
            sections.append(Section(genre: parent.name, movies: qwe, expanded: false, id: parent.id))
        }
    }
    
    
    
    //## TABLE VIEW FUNCTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.view.frame.height < 600{
            return 44
        }
        else{
            return 48
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded == true) {
            if self.view.frame.height < 600{
                return 52
            }
            else{
                return 56.5
            }
        } else {
            return 0
        }
    }
    //## FOOTER HEIGHT
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.view.frame.height < 600{
            return 5
        }
        else{
            return 10
        }
    }
    // FOOTER COLOR
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UITableViewHeaderFooterView()
        footer.layer.backgroundColor = UIColor.clear.cgColor
        return footer
    }
    
    //## HEADER, CHANGE IMAGE HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        //header.customInit(title: sections[section].genre, section: section, delegate: self)
        
        header.reloadInputViews()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForHead") as! HeaderCell
        header.contentView.backgroundColor = UIColor(red:0.01, green:0.42, blue:0.38, alpha:1.0)
        
        cell.headerLabel.textAlignment = .center
        cell.headerLabel.text = sections[section].genre
        
        if self.view.frame.height < 600{
            cell.headerLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
        }
        else{
            cell.headerLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        }
        
        var imageView = UIImageView()
        if (sections[section].expanded == true) {
            imageView = UIImageView.init(frame: CGRect(x: (tableView.frame.size.width) - 30  , y: (cell.frame.size.height) / 2 - 5, width: 18, height: 10))
            imageView.image = UIImage(named: "downButton")
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            
        } else {
            imageView = UIImageView.init(frame: CGRect(x: (tableView.frame.size.width) - 30  , y: (cell.frame.size.height) / 2 - 5, width: 18, height: 10))
            imageView.image = UIImage(named: "upButton")
            imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
        let tappedSection = UIButton.init(frame: CGRect(x: 0, y: 0, width: 250, height: 48))
        tappedSection.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        tappedSection.tag = section
        
        header.addSubview(cell)
        header.addSubview(imageView)
        header.addSubview(tappedSection)
        
        return header
    }
    
    //TO SHOW SUBVIEW
    func sectionTapped(_ sender: UIButton) {
        let tag = sender.tag
        sections[tag].expanded = !sections[tag].expanded
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: tag), with: .automatic)
        tableView.endUpdates()
    }
    
    
    //## SUBVIEW COLOR CHANGER
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubviewCell") as! SubViewCell
        cell.indexPathOfCell = indexPath
        
        if selectedType.contains(self.features[indexPath[0]].children[indexPath[1]].id){
            cell.subViewView.backgroundColor = UIColor(red:0.76, green:0.63, blue:0.38, alpha:1.0)
        }else{
            cell.subViewView.backgroundColor = UIColor.gray
            }
        if self.view.frame.height < 600{
            
            cell.subViewLabel.font = UIFont(name: "Comfortaa-Regular", size: 13)
        }
        else{
            cell.subViewLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        }
        
        cell.subViewLabel.text = sections[indexPath.section].movies[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    //## TO GET SELECTED TYPE
    var selectedType = [Int]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !selectedPaths.contains(indexPath){
            selectedPaths.append(indexPath)
            selectedType.append(self.features[indexPath[0]].children[indexPath[1]].id)
            
        }else{
            var count = 0
            for path in selectedPaths{
                if path == indexPath{
                    selectedPaths.remove(at: count)
                }
                count = count + 1
            }
            count = 0
            for path in selectedType{
                if path == self.features[indexPath[0]].children[indexPath[1]].id{
                    selectedType.remove(at: count)
                }
                count += 1
            }
        }
        tableView.reloadData()
    }
    
    
    //## Start Button
    var phone = UserModel.info().phone
    var name = UserModel.info().name
    var password = UserModel.info().password
    var city = UserModel.info().city
    var addresses = UserModel.info().address
    var location_x = UserModel.info().locationX
    var location_y = UserModel.info().locationY
    var descriptions = UserModel.info().description
    var image = UserModel.info().images
    
    
    @IBAction func startButton(_ sender: UIButton) {
        if(selectedPaths.count != 0){
            if !UserModel.info().typeOfPage{
                Animations.sharedInstance.showIndicator(viewController: self)
                register(phone: phone ,password: password, description: descriptions, name: name, surname: String(), city: String(), address: addresses, location_x: location_x, location_y: location_y, type: type, image: image, feature: selectedType)
            }
            else{
                Animations.sharedInstance.showIndicator(viewController: self)
                changeFeature(feature: selectedType)
            }
        }
        else{
            showErrorAlert(errorMessage: "select")
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //##### TO CALL ERROR ALERT
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as! ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    
    
    //## BACKEND
    var dict = [String: Any]()
    func register(phone: String, password: String, description: String,name: String, surname: String, city: String, address: String, location_x: Double, location_y: Double , type: Int, image: [UIImage], feature: [Int]){
        
        APIManager.sharedInstance.authRegistrationOfUserAndAdmin(name: name, surname: surname, phone: phone, password: password, city: city, address: address, type: type, locationX: location_x, locationY: location_y, onSuccess: {(json) in
            
            var text = [String]()
            var date = [String]()
            var nameFeed = [String]()
            if(json["auth_token"].string != nil){
                let token = json["auth_token"].string!
                let name = json["name"].string
                var surname = json["surname"].string
                let id = json["id"].int
                let type = json["type"].int
                
            
                var featureSubChild = [Int]()
                let featureChild = [Int]()
                var parent = [Int]()
                var feedbackDict = [String: Any]()
                var placeID = Int()
                if(type != 0){
                    
                    for temp in json["places"].array!{
                        placeID = temp["id"].int!
                        
                        for feedback in temp["feedback"].array!{
                            if feedback != []{
                                nameFeed.append(feedback["owner"]["name"].string!)
                                text.append(feedback["text"].string!)
                                date.append(Animations.sharedInstance.convertDateToDateStringToComment(UTCTime: feedback["date"].string!))
                            }
                        }
                        
                        feedbackDict = ["name": nameFeed, "text": text, "date": date]
                        UserModel.info().saveFeedbacks(dict: feedbackDict)
                        
                        for features in temp["feature"].array!{
                            featureSubChild.append(features["id"].int!)
                            let x = features["parent"].int!
                            
                            parent = Animations.sharedInstance.saveIdOfFeature(id: x, arrayID: parent)
                        }
                    }
                }

                // To Save in UserDefault
                if(surname == nil){
                    surname = String()
                }
                self.dict = ["name": name!, "surname": surname!, "id": id!, "type": type!, "placeID": placeID]
                let featureDict = ["featureSubChild": featureSubChild, "featureChild": featureChild, "parent": parent]

                UserModel.info().saveToken(token: token)
                UserModel.info().saveUser(userDictionary: self.dict)
                UserModel.info().saveFeature(dict: featureDict)

                let parameters: Dictionary<String, Any> = [
                    "description" : description,
                    "feature" : feature,
                    "address":  self.addresses,
                    "name": self.name,
                    "location_x": location_x,
                    "location_y": location_y
                ]
                
                APIManager.sharedInstance.placeChangeInformation(placeID: placeID, parameters: parameters, onSuccess: {(json) in
                    print(json)
     
                    let address = json["address"].string
                    let locationX = json["location_x"].string
                    let locationY = json["location_y"].string
                    
                    let addressDict = ["city": String(), "address": address!, "locationX": locationX!, "locationY": locationY!]
                    
                    UserModel.info().saveAddress(dict: addressDict)
                })
                APIManager.sharedInstance.placeUploadPhotos(type: 0, placeID: placeID , comment: String(), images: image, onSuccess: {(json) in
                    print(json)
                })
                
                Animations.sharedInstance.hideIndicator(viewController: self)
                UIApplication.shared.keyWindow?.rootViewController = Animations.sharedInstance.createAndGetTabBar()
            }
            else{
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Повторите попытку")
            }
        })
    }
    
    func changeFeature(feature: [Int]){
        let parameters: Dictionary<String, Any> = [
            "feature" : feature
        ]
        APIManager.sharedInstance.placeChangeInformation(placeID: placeID, parameters: parameters, onSuccess: {(json) in
            print(json)
            
            if json["id"].int != nil{
                var featureSubChild = [Int]()
                var featureChild = [Int]()
                var parent = [Int]()
                

                for features in json["feature"].array!{
                    featureSubChild.append(features["id"].int!)
                    let x = features["parent"].int!
                    
                    if(!featureChild.contains(x)){
                        featureChild.append(x)
                        
                        if 0 < x && 14 > x{
                            if(!parent.contains(1)){
                                parent.append(1)
                            }
                        }
                        if 13 < x &&  37 > x{
                            if(!parent.contains(14)){
                                parent.append(14)
                            }
                        }
                        if 36 < x &&  56 > x{
                            if(!parent.contains(37)){
                                parent.append(37)
                            }
                        }
                        if 55 < x{
                            if(!parent.contains(56)){
                                parent.append(56)
                            }
                        }
                    }
                }
                
                var dict = [String: Any]()
                dict = ["featureSubChild": featureSubChild,
                        "featureChild": featureChild,
                        "parent": parent]

                UserModel.info().saveFeature(dict: dict)
                
                var viewControllers = self.navigationController?.viewControllers
                viewControllers?.removeLast(3)
                self.navigationController?.setViewControllers(viewControllers!, animated: true)

                Animations.sharedInstance.hideIndicator(viewController: self)
            }
            else{
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Повторите попытку")
                
            }
        })
    }
}
