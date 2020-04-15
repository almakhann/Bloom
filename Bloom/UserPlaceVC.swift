//
//  UserPlaceVC.swift
//  Bloom
//
//  Created by Serik on 14.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class UserPlaceVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var yourPlaceTitle: UILabel!
    @IBOutlet var cityLine: UIView!
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var cityImage: UIImageView!
    
    @IBOutlet var streetImage: UIImageView!
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    @IBOutlet var streetTextField: AutoCompleteTextField!
    @IBOutlet var streetView: UIView!
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var background: UIImageView!
    
    var locationManager = CLLocationManager()
    var type = UserModel.info().type
    var location_x: CLLocationDegrees = 0.0
    var location_y: CLLocationDegrees = 0.0
    var info = UserModel.info().getDataFromUserDefault()
    var address = UserModel.info().getAddress()
    var id = Int()
    var placeID = Int()
    var placeIDForMAp = [String]()
    var list = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleTextFieldInterfaces()
        handleTextFieldInterface()
        
        autocompleteTextfield.delegate = self
        streetTextField.delegate = self
        
       
        
        //Your map initiation code
        self.mapView.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        

        
        if(UserModel.info().typeOfPage == false){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()

            if(type == 0){
                startBtn.setTitle("Начать", for: .normal)
                streetTextField.isHidden = true
                streetView.isHidden = true
                streetImage.isHidden = true
                autocompleteTextfield.returnKeyType = .done
            }
            else{
                startBtn.setTitle("Продолжить", for: .normal)
                streetTextField.isEnabled = false
                
                autocompleteTextfield.returnKeyType = .next
                streetTextField.returnKeyType = .done
            }
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
            self.extendedLayoutIncludesOpaqueBars = true
            streetImage.image = UIImage(named: "street")?.maskWithColor(color: UIColor.gray)
            cityImage.image = UIImage(named: "city")?.maskWithColor(color: UIColor.gray)
            startBtn.setTitle("Выбрать", for: .normal)
            yourPlaceTitle.text = "Выберите новый адрес"
            yourPlaceTitle.textColor = UIColor.gray
            background.isHidden = true
            autocompleteTextfield.textColor = UIColor.black
            cityLine.backgroundColor = UIColor.gray
            autocompleteTextfield.attributedPlaceholder = NSAttributedString(string: "Введите ваш город",
                                                                             attributes: [NSForegroundColorAttributeName: UIColor.gray])
            
            let lati = address["locationX"] as! String
            let long = address["locationY"] as! String
            id = info["id"] as! Int
            createMarker(titleMarker: "", latitude: Double(lati)! , longitude: Double(long)!  , zoom: 16)
            
            if info["type"] as! Int == 0{
                type = 0
                autocompleteTextfield.returnKeyType = .done
                autocompleteTextfield.text = (address["city"] as! String)
                
                streetTextField.isHidden = true
                streetView.isHidden = true
                streetImage.isHidden = true
            }
            else{
                placeID = info["placeID"] as! Int
                type = 1
                let add = (address["address"] as! String)
                let arr = add.components(separatedBy: ",")
                
                autocompleteTextfield.text = arr[0]
                streetTextField.text = arr[1]
                autocompleteTextfield.returnKeyType = .next
                streetTextField.returnKeyType = .done
                streetView.backgroundColor = UIColor.gray
                streetTextField.textColor = UIColor.black
                streetTextField.attributedPlaceholder = NSAttributedString(string: "Введите вашу улицу",
                                                                           attributes: [NSForegroundColorAttributeName: UIColor.gray])
            }
        }
    }
    
   
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String,  latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        
        self.mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = mapView
        location_x = latitude
        location_y = longitude
    }
    
    var locationX: CLLocationDegrees = 0.0
    var locationY: CLLocationDegrees = 0.0
    //MARK: - Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        createMarker(titleMarker: "you position", latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 10)

        locationX = (self.locationManager.location?.coordinate.latitude)!
        locationY = (self.locationManager.location?.coordinate.longitude)!
        self.locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.isMyLocationEnabled = true
        return false
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
        createMarker(titleMarker: "Выбранное место", latitude: coordinate.latitude, longitude: coordinate.longitude , zoom: 16.0)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapView.isMyLocationEnabled = true
        mapView.selectedMarker = nil
        return false
    }
    
    
    //## Back Button Pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if type == 0 {
            if textField == autocompleteTextfield{
                done()
            }
        }
        else{
            if textField == autocompleteTextfield{
                streetTextField.isEnabled = true
                streetTextField.becomeFirstResponder()
            }
            if textField == streetTextField {
                textField.resignFirstResponder()
                done()
            }
            else{
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    
    //## Start Button
    @IBAction func startButtonPressed(_ sender: UIButton) {
        done()
    }
    
    func done(){
        if UserModel.info().typeOfPage == false{
            if(type == 0){
                if(autocompleteTextfield.text != ""){
                    Animations.sharedInstance.showIndicator(viewController: self)
                    register(name: UserModel.info().name, surname: UserModel.info().surname, phone: UserModel.info().phone, password: UserModel.info().password, city: cityName, address: streetTextField.text!, type: self.type, locationX: location_x, locationY: location_y)
                }
                else{
                    showErrorAlert(errorMessage: "Заполните поле")
                }
            }
                
            else{
                if(autocompleteTextfield.text != "" && streetTextField.text != ""){
                    Animations.sharedInstance.hideIndicator(viewController: self)
                    UserModel.info().address = autocompleteTextfield.text! + "," + streetTextField.text!
                    UserModel.info().locationX = location_x
                    UserModel.info().locationY = location_y
                    
                    let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                    let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "ChooseSalonCategoryVC") as UIViewController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                else{
                    showErrorAlert(errorMessage: "Заполните поле")
                }
            }
        }
        else{
            if info["type"] as! Int == 0 {
                if autocompleteTextfield.text != ""{
                    Animations.sharedInstance.showIndicator(viewController: self)
                    ChangeUserPlace(city: autocompleteTextfield.text!, locationX: location_x, locationY: location_y)
                }
                else{
                    showErrorAlert(errorMessage: "Заполните поле")
                }
            }
            else{
                if autocompleteTextfield.text != "" && streetTextField.text != ""{
                    Animations.sharedInstance.showIndicator(viewController: self)
                    changeSalonFreelancerPlace(city: autocompleteTextfield.text!, street: autocompleteTextfield.text! + ", " + streetTextField.text!, locationX: location_x, locationY: location_y)
                }
                else{
                    showErrorAlert(errorMessage: "Заполните поле")
                }
            }
        }

    }
    
    
    //##### To call ErrorAlert
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as! ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        autocompleteTextfield.resignFirstResponder()
        streetTextField.resignFirstResponder()
    }

    
    var cityName = String()
    fileprivate func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                
                self?.fetchAutocompletePlaces(text, (self?.autocompleteTextfield)!, 0)
            }
        }
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            let city = text.components(separatedBy: ",")
            self?.autocompleteTextfield.text = city.first
            self?.cityName = city.first!
            self?.streetTextField.isEnabled = true
            self?.getLocation(placeID: (self?.placeIDForMAp[indexpath.row])! , type: 1 )
        }
    }
    
    fileprivate func handleTextFieldInterface(){
        streetTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text, (self?.streetTextField)!, 1)
            }
        }
        
        streetTextField.onSelect = {[weak self] text, indexpath in
            let city = text.components(separatedBy: ",")
            self?.streetTextField.text = city.first
            self?.getLocation(placeID: (self?.placeIDForMAp[indexpath.row])!, type: 0)
        }
    }

    fileprivate var responseData:NSMutableData?
    //fileprivate let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    fileprivate let googleMapsKey = "AIzaSyDjkWFzuIIqhGuHKfJtnEPL6A8_dmdMt7M"
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
    fileprivate var dataTask:URLSessionDataTask?
    
    var urlString = String()
    fileprivate func fetchAutocompletePlaces(_ keyword:String,_ textField: AutoCompleteTextField, _ type: Int) {
        if(type == 0){
            urlString = "\(baseURLString)\(keyword)&types=(cities)&language=ru&key=\(googleMapsKey)"

        }
        if(type == 1){
            urlString = "\(baseURLString)\(cityName)\(keyword)&language=ru&key=\(googleMapsKey)"
        }
        
        let s = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        s.addCharacters(in: "+&")
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s as CharacterSet) {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        var locations = [String]()
                                        self.placeIDForMAp = [String]()
                                        for dict in predictions as! [NSDictionary]{
                                        
                                            locations.append(dict["description"] as! String)
                                            self.placeIDForMAp.append(dict["place_id"] as! String)

                                        }
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            textField.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                    textField.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }

    func getLocation(placeID: String, type: Int){
        let url = "https://maps.googleapis.com/maps/api/place/details/json?&placeid="
        let UrlString = "\(url)\(placeID)&key=\(googleMapsKey)"
        
        if let url = URL(string: UrlString) {
            let request = URLRequest(url: url)
            dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data{
                    do{
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
                        if let status = result["status"] as? String{
                            if status == "OK"{
                                var list = [Double]()
                                if let neededLocation = (result["result"] as? Dictionary<String, Any>){
                                    
                                    list.append(((neededLocation["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lat"] as! Double)
                                    list.append(((neededLocation["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lng"] as! Double)
                                }
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if type == 1{
                                        self.createMarker(titleMarker: "city", latitude: list[0], longitude: list[1], zoom: 14)
                                    }
                                    else{
                                        self.createMarker(titleMarker: "street", latitude: list[0], longitude: list[1], zoom: 16)
                                    }
                                    
                                    
                                })
                            }
                        }
                    }
                    catch let error as NSError{
                        print("Error: \(error.localizedDescription)")
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
    
    



    //## Backend
    var dict = [String: Any]()
    func register(name: String, surname: String, phone: String, password: String, city: String, address: String, type: Int, locationX: Double, locationY: Double){
        APIManager.sharedInstance.authRegistrationOfUserAndAdmin(name: name, surname: surname, phone: phone,  password: password, city: city, address: address, type: type, locationX: locationX, locationY: locationY, onSuccess: {(json) in
            
            print(json)
            if(json["auth_token"].string != nil){
                let token = json["auth_token"].string!
                let name = json["name"].string
                var surname = json["surname"].string
                let id = json["id"].int
                let type = json["type"].int
                let city = json["city"].string
                var address = json["address"].string
                let locationX = json["location_x"].string
                let locationY = json["location_y"].string
                
                // To Save in UserDefault
                if(surname == nil){
                    surname = String()
                }
                if(type == 0){
                    address = String()
                }
                self.dict = ["name": name!, "surname": surname!,  "id": id!, "type": type!]
                let addressDict = ["city": city!, "address": address!, "locationX": locationX!, "locationY": locationY!]
                
                UserModel.info().saveToken(token: token)
                UserModel.info().saveUser(userDictionary: self.dict)
                UserModel.info().saveAddress(dict: addressDict)
                Animations.sharedInstance.hideIndicator(viewController: self)
                
                UIApplication.shared.keyWindow?.rootViewController = Animations.sharedInstance.createAndGetTabBar()
            }
        })
    }
    
    
    //For Profile Setting
    

    var addressDict = [String: Any]()
    func ChangeUserPlace(city: String, locationX: Double, locationY: Double) {
        let parameters: Dictionary<String, Any> = [
            "location_x" : locationX,
            "location_y" : locationY,
            "city" : city
        ]
        APIManager.sharedInstance.authChangeUser(userID: id, parameters: parameters, onSuccess: {(json) in
            print(json)
            
            let city = json["city"].string
            let address = String()
            let locationX = json["location_x"].string
            let locationY = json["location_y"].string
   
            
            self.addressDict = ["city": city!, "address": address, "locationX": locationX!, "locationY": locationY!]
            UserModel.info().saveAddress(dict: self.addressDict)
            
            
            _ = self.navigationController?.popViewController(animated: true)
            Animations.sharedInstance.hideIndicator(viewController: self)
            print(UserModel.info().getAddress(), "Address")
           
            
            
        })
    }
    
    func changeSalonFreelancerPlace(city: String, street: String, locationX: Double, locationY: Double){
        let parameters: Dictionary<String, Any> = [
            "location_x" : locationX,
            "location_y" : locationY,
            "address": street
        ]
        
        APIManager.sharedInstance.placeChangeInformation(placeID: placeID, parameters: parameters, onSuccess: {(json) in
            print(json)
            
            let city = String()
            let address = json["address"].string
            let locationX = json["location_x"].string
            let locationY = json["location_y"].string


            self.addressDict = ["city": city, "address": address!, "locationX": locationX!, "locationY": locationY!]
            
            UserModel.info().saveAddress(dict: self.addressDict)
            _ = self.navigationController?.popViewController(animated: true)
            Animations.sharedInstance.hideIndicator(viewController: self)
        })
    }
}








