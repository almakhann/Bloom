//
//  LoginVC.swift
//  Bloom
//
//  Created by Serik on 13.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit


class LoginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var backView: UIView!
       
    
    var number = ""
    var password = ""
    var tokens = ""
    
    var y = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        numberTextField.delegate = self
        
        y = backView.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //## Keyboard Function
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y == y{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y -= keyboardSize.height / 2
                })
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y != 0{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y += keyboardSize.height / 2
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == numberTextField{
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if text.characters.first == "8"{
                return newLength <= 11
            }
            else{
                return newLength <= 12
            }
            
        }
        else{
            return true
        }
    }
    
    
    //### LOGIN button pressed
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        if(PasswordCheck() == 1){
            Animations.sharedInstance.showIndicator(viewController: self)
            Login(number: number, password: password)
        }
    }
    
    
    ///### REGISTERBUTTON PRESSED
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        UserModel.info().forget = 0
        UserModel.info().typeOfPage = false
        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "categoryVC") as UIViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //### FORGOT BUTTON PRESSED
    @IBAction func forgotPassword(_ sender: UIButton) {
        if(NumberCheck() == 1) {
            Animations.sharedInstance.showIndicator(viewController: self)
            sendPhoneNumber(phone: numberTextField.text!)
            UserModel.info().phone = numberTextField.text!
            UserModel.info().forget = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
            if(PasswordCheck() == 1){
                Animations.sharedInstance.showIndicator(viewController: self)
                Login(number: number, password: password)
            }
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    // VALIDATION CHECKER
    func PasswordCheck() -> Int{
        password = passwordTextField.text!
        if(NumberCheck() == 1){
            if(password != ""){
                return 1
            }
            else{
                showErrorAlert(errorMessage: "Заполните поле")
                return 0
            }
        }
        else{
            return 0
        }
    }
    func NumberCheck() -> Int{
        number = numberTextField.text!
        if(number != ""){
            if(number.characters.count == 12){
                numberTextField.isUserInteractionEnabled = true
                if(String(number.characters.prefix(3)) == "+77"){
                    return 1
                }
                else{
                    showErrorAlert(errorMessage: "Номер неправильно")
                    return 0
                }
            }
            else if(number.characters.count == 11){
                if(String(number.characters.prefix(2)) == "87"){
                    return 1
                }
                else{
                    showErrorAlert(errorMessage: "Номер неправильно")
                    return 0
                }
            }
            if(number.characters.count > 12){
                numberTextField.isUserInteractionEnabled = false
                return 0
            }
            else{
                showErrorAlert(errorMessage: "Номер неправильно")
                return 0
            }
        }
        else{
            showErrorAlert(errorMessage: "Заполните поле")
            return 0
        }
    }
    
    
    //##### To call ErrorAlert
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as!  ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        showErrorAlert.view.tag = 1000
        var contains = false
        for view in self.view.subviews{
            if view.tag == 1000{
                contains = true
            }
        }
        
        if contains{
            let errorView = self.view.subviews.last
            errorView?.removeFromSuperview()
        }else{
            self.view.addSubview(showErrorAlert.view)
        }
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    //KEYBOARD FUNTIONS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

    
    
    //BACKEND
    var dict = [String: Any]()
    func Login(number: String, password: String){
        APIManager.sharedInstance.authLoginOfAdminAndUser(phone: number, password: password, onSuccess: {(json) in
            print(json)
            if json["auth_token"].string != nil{
                
                var surname = json["surname"].string
                let id = json["id"].int
                let type = json["type"].int
                let auth_token = json["auth_token"].string
                
                var name = String()
                var city = String()
                var address = String()
                var locationX = String()
                var locationY = String()
                
                var featureSubChild = [Int]()
                var featureChild = [Int]()
                var parent = [Int]()
                var placeID = Int()
                var feedbackDict = [String: Any]()
                
                var text = [String]()
                var date = [String]()
                var nameFeed = [String]()
                if(type != 0){
                    
                    for temp in json["places"].array!{
                        name = temp["name"].string!
                        placeID = temp["id"].int!
                        address = temp["address"].string!
                        locationX = temp["location_x"].string!
                        locationY = temp["location_y"].string!
                        
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
                            
                            if(!featureChild.contains(x)){
                                featureChild.append(x)
                                
                                parent = Animations.sharedInstance.saveIdOfFeature(id: x, arrayID: parent)
                                
                            }
                        }
                    }
                }else{
                    name = json["name"].string!
                    city = json["city"].string!
                    locationX = json["location_x"].string!
                    locationY = json["location_y"].string!
                }
    
                if surname == nil{
                    surname = String()
                }
                
                self.dict = ["name": name, "surname": surname!,  "id": id!, "type": type!, "placeID": placeID]
                let featureDict = ["featureSubChild": featureSubChild, "featureChild": featureChild, "parent": parent]
                let addressDict = ["city": city, "address": address, "locationX": locationX, "locationY": locationY]
                
                
                UserModel.info().saveToken(token: auth_token!)
                UserModel.info().saveUser(userDictionary: self.dict)
                UserModel.info().saveFeature(dict: featureDict)
                UserModel.info().saveAddress(dict: addressDict)
                
                UIApplication.shared.keyWindow?.rootViewController = Animations.sharedInstance.createAndGetTabBar()
                
                Animations.sharedInstance.hideIndicator(viewController: self)
                
            }else{
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Неправильно")
            }
        })
    }
    
    func sendPhoneNumber(phone: String){
        APIManager.sharedInstance.authForgotPasswordSendSMSCode(phone: phone, onSuccess: { (json) in
            print(json)
            if(json["status"].string != "0"){
                print(json)
                let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVc") as UIViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                Animations.sharedInstance.hideIndicator(viewController: self)
                
            }
            else{
                
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Номер неправильно" )
            }
        })
    }
    
}
