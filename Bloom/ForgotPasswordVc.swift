//
//  ForgotPasswordVc.swift
//  Bloom
//
//  Created by Serik on 15.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ForgotPasswordVc: UIViewController {
    
    @IBOutlet var resendBtn: UIButton!
    @IBOutlet var codeTextFiled: UITextField!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var backView: UIView!
    
    
    var phone: String = ""
    var x = 30
    var timer = Timer()
    var type = UserModel.info().type
    var y = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        resendBtn.isHidden = true
        
        
        y = backView.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //  Keyboard function
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y == y{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y -= keyboardSize.height / 2.4
                })
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y != 0{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y += keyboardSize.height / 2.4
                })
            }
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func timerAction() {
        resendBtn.isHidden = true
        if(x > 0){
            if(x > 10){
                x -= 1
                timerLabel.text = "00 : \(x)"
            }
            else{
                x -= 1
                timerLabel.text = "00 : 0\(x)"
            }
        }
        else{
            timerLabel.text = "00 : 00"
            resendBtn.isHidden = false
        }
    }
    
    //## BACK
    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        codeTextFiled.resignFirstResponder()
    }
    
    //## NEXT BUTTON PRESSED
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if(codeTextFiled.text != "" ){
            Animations.sharedInstance.showIndicator(viewController: self)
            if(UserModel.info().forget == 1){
                phone = UserModel.info().phone
                sendSmsCode(phone: phone, code: codeTextFiled.text!)
            }
            else{
                phone = UserModel.info().phone
                checkRegister(phone: phone, code: codeTextFiled.text!)
            }
        }
        else{
            Animations.sharedInstance.hideIndicator(viewController: self)
            showErrorAlert(errorMessage: "Заполните поле")
        }
    }


    
    @IBAction func resendButonPressed(_ sender: UIButton) {
        x = 30
        Animations.sharedInstance.showIndicator(viewController: self)
        if(UserModel.info().forget == 1){
            phone = UserModel.info().phone
            sendPhoneNumber(phone: phone)
        }
        else{
            phone = UserModel.info().phone
            sendSmsRegister(number: phone)
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
    
    
    //###### BACKEND
    func sendSmsCode(phone: String, code: String){
        APIManager.sharedInstance.authForgotPasswordCheckSMSCode(phone: phone, code: code, onSuccess: {(json) in
            if(json["code"].string != nil){
                let code = json["code"].string
                let phone1 = json["phone"].string
                UserModel.info().code  = code!
                UserModel.info().phone = phone1!
                
                let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "NewPasswordVC") as UIViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
            else{
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage:  "Неправильно")
            }
        })
    }
    
    func sendPhoneNumber(phone: String){
        APIManager.sharedInstance.authForgotPasswordSendSMSCode(phone: phone, onSuccess: { (json) in
            print(json)
            Animations.sharedInstance.hideIndicator(viewController: self)
        })
    }
    
    
    func checkRegister(phone: String, code: String){
        APIManager.sharedInstance.authCheckIfSMSCodeIsCorrect(phone: phone, code: code, requestSent: {(statusCode) in
            if(statusCode == 200){
                if(self.type == 0){
                    let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                    let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "NameSurnameVC") as UIViewController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    Animations.sharedInstance.hideIndicator(viewController: self)
                }
                else{
                    let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                    let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "PhotoNameAboutYourSelfVC") as UIViewController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    Animations.sharedInstance.hideIndicator(viewController: self)
                }
            }
            else if(statusCode == 400){
                Animations.sharedInstance.hideIndicator(viewController: self)
                self.showErrorAlert(errorMessage: "Неправильно")
            }
        })
    }
    
    func sendSmsRegister(number: String){
        APIManager.sharedInstance.authGetSMSCode(phone: number, onSuccess: {(json) in
            print(json)
            Animations.sharedInstance.hideIndicator(viewController: self)

        })
    }
}
