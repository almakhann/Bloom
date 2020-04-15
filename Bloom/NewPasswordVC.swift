//
//  NewPasswordVC.swift
//  Bloom
//
//  Created by Serik on 15.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class NewPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rePasswordTeextField: UITextField!

    @IBOutlet var backView: UIView!
    
    var y = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        rePasswordTeextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        rePasswordTeextField.delegate = self
        
        y = backView.frame.origin.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Keyboard Function
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
    
    
    //## NEXT BUTTON
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        send()
    }
    func send(){
        rePasswordTeextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if(passwordTextField.text != "" && rePasswordTeextField.text != ""){
            if(passwordTextField.text == rePasswordTeextField.text){
                Animations.sharedInstance.showIndicator(viewController: self)
                newPassword(password: passwordTextField.text!, phone: UserModel.info().phone, code: UserModel.info().code)
            }
            else{
                self.showErrorAlert(errorMessage:  "Пароли не совпадают")
            }
        }
        else{
            self.showErrorAlert(errorMessage: "Заполните поле")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.passwordTextField{
            rePasswordTeextField.becomeFirstResponder()
        }
        else if textField == self.rePasswordTeextField {
            textField.resignFirstResponder()
            send()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTextField.resignFirstResponder()
        rePasswordTeextField.resignFirstResponder()
    }
    
    
    //#### BACKEND
    func newPassword(password: String, phone: String, code: String){
        APIManager.sharedInstance.authForgotPasswordSetNewPassword(phone: phone, code: code, password: password, onSuccess: {(json) in
            print(json)
            if(json["auth_token"].string != nil){
                let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.addChildViewController(loginVC)
                loginVC.view.frame = self.view.frame
                self.view.addSubview(loginVC.view)
                loginVC.didMove(toParentViewController: self)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
            else{
                self.showErrorAlert(errorMessage: "Неправильно")
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
        })
    }
}
