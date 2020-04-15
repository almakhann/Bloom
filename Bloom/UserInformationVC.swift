//
//  UserInformationVC.swift
//  Bloom
//
//  Created by Serik on 14.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit


class UserInformationVC: UIViewController,  UITextFieldDelegate  {
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var repassTextField: UITextField!
    @IBOutlet var backView: UIView!
    
    var y = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.delegate = self
        passTextField.delegate = self
        repassTextField.delegate = self
        
        passTextField.isSecureTextEntry = true
        repassTextField.isSecureTextEntry = true
        
        y = backView.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //## Keyboard Function
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y == y{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y -= keyboardSize.height / 2.5
                })
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y != 0{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y += keyboardSize.height / 2.5
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField{
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


    @IBAction func continueButtonPressed(_ sender: UIButton) {
        send()
    }
    func send(){
        passTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        repassTextField.resignFirstResponder()
        if(PasswordCheck() == 1){
            Animations.sharedInstance.showIndicator(viewController: self)
            checkPhoneNumber(phone: phoneTextField.text!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.passTextField{
            repassTextField.becomeFirstResponder()
        }
        if textField == self.repassTextField {
            send()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func BackPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        repassTextField.resignFirstResponder()
    }
   
    
    
    //#### Function Show Error Alert
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
    
    
    // #### Validation
    var password = ""
    var repass = ""
    var phone = ""
    
    func PasswordCheck() -> Int{
        password = passTextField.text!
        repass = repassTextField.text!
        if(NumberCheck() == 1){
            if(password != "" && repass != ""){
                if(password == repass){
                    if(password.characters.count < 6 && repass.characters.count < 6){
                        showErrorAlert(errorMessage: "more than 6")
                        return 0
                    }
                    else{
                        return 1
                    }
                }
                else{
                    showErrorAlert(errorMessage: "Пароли не совпадают")
                    return 0
                }
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
        phone = phoneTextField.text!
        if(phone != ""){
            if(phone.characters.count == 12){
                if(String(phone.characters.prefix(3)) == "+77"){
                    return 1
                }
                else{
                    showErrorAlert(errorMessage: "Номер неправильно")
                    return 0
                }
            }
            else if(phone.characters.count == 11){
                if(String(phone.characters.prefix(2)) == "87"){
                    return 1
                }
                else{
                    showErrorAlert(errorMessage: "Номер неправильно")
                    return 0
                }
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
    
    //##BACKEND
    
    func checkPhoneNumber(phone: String){
        APIManager.sharedInstance.authCheckIfPhoneIsExist(phone: phone, requestSent: {(statusCode) in
            if(statusCode == 400){
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Такой номер существует")
            }else{
                self.sendSms(number: phone)
                UserModel.info().phone = phone
                UserModel.info().password = self.passTextField.text!
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
            
        })
    }
    
    func sendSms(number: String){
        APIManager.sharedInstance.authGetSMSCode(phone: number, onSuccess: {(json) in
            if(json["code"].string != nil){
                print(json)
                UserModel.info().phone = number
                let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVc") as UIViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
            else{
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Номер неправильно")
            }
        
        })
    }
}




