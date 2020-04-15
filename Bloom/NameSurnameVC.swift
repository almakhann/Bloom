//
//  NameSurnameVC.swift
//  Bloom
//
//  Created by Serik on 14.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class NameSurnameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var backView: UIView!

    var y = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        surnameTextField.delegate = self
        // Do any additional setup after loading the view.
        
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

    
    
    //OK BUTTON PRESSED
    @IBAction func okButtonPressed(_ sender: UIButton) {
     send()
    }
    func send(){
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        if(nameTextField.text != "" && surnameTextField.text != ""){
            UserModel.info().name = nameTextField.text!
            UserModel.info().surname = surnameTextField.text!
            
            let map = Bundle.main.loadNibNamed("MapSetAddress", owner: self, options: nil)?.first as! UIViewController
            
            self.navigationController?.pushViewController(map, animated: true)
        }
        else{
            showErrorAlert(errorMessage: "Заполните поле")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField{
            surnameTextField.becomeFirstResponder()
        }
        if textField == self.surnameTextField {
            send()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    //BACK BOTTON PRESSED
    @IBAction func backButtonPressed(_ sender: UIButton) {
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(2)
        navigationController?.setViewControllers(viewControllers!, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
    }
}
