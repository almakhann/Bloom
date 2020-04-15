//
//  popUpViewChangePassword.swift
//  Bloom
//
//  Created by Serik on 06.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class popUpViewChangePassword: UIViewController {
    
    @IBOutlet weak var curPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var reNewPass: UITextField!
    
    @IBOutlet weak var radioBtn: UIButton!
    
    let checked = UIImage(named: "off")!
    let unchecked = UIImage(named: "on")!
    var profile: UIViewController!
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == false {
                self.radioBtn.setImage(checked, for: UIControlState.normal)
            }else {
                self.radioBtn.setImage(unchecked, for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func RadioBtnChanger(_ sender: UIButton) {
        isChecked = !isChecked
        curPass.isSecureTextEntry = !isChecked
        newPass.isSecureTextEntry = !isChecked
        reNewPass.isSecureTextEntry = !isChecked
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        curPass.isSecureTextEntry = true
        newPass.isSecureTextEntry = true
        reNewPass.isSecureTextEntry = true
    }
    
    func keyboardWillShow(_ sender: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 60
        }
    }
    func keyboardWillHide(_ sender: NSNotification) {
        if self.view.frame.origin.y == -60{
            self.view.frame.origin.y += 60
        }
    }
    
    // TO SAVE OK BUTTON
    @IBAction func closePopUp(_ sender: AnyObject) {
        let currentPassword = curPass.text
        let newPassword = newPass.text
        let renewPassword = reNewPass.text
        
        if !currentPassword!.isEmpty && !newPassword!.isEmpty && !renewPassword!.isEmpty{
            if(newPassword == renewPassword){
                if newPassword == currentPassword{
                    Animations.sharedInstance.showSuccessView(viewContoller: profile)
                    removeAnimate()
                }else{
                    changePassword(oldPass: currentPassword, newPass: newPassword)
                }
            }
            else{
                showErrorAlert(errorMessage: "Пароли не совпадают")
            }
        }else{
            showErrorAlert(errorMessage: "Заполните поля")
        }
        

    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                
            }
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.view {
                removeAnimate()
            }else{
                curPass.resignFirstResponder()
                newPass.resignFirstResponder()
                reNewPass.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with:event)
    }
    
    
    func changePassword(oldPass: String!, newPass: String!){
        APIManager.sharedInstance.authChangePassword(currentPassword: oldPass, newPassword: newPass, requestSent: {(status) in
            if status == 200{
                Animations.sharedInstance.showSuccessView(viewContoller: self.profile)
                self.removeAnimate()
            }else{
                self.showErrorAlert(errorMessage: "Старый пароль неверен")
            }
        })
        
    }
    
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as!  ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame

        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }

}
