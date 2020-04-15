//
//  Bloom
//
//  Created by Serik on 06.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class UserSettings: UIViewController {
    
    @IBOutlet var line1: UIView!   //----
    @IBOutlet var line2: UIView!   // #### just for style
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    
    @IBOutlet weak var changePosition: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet var bottomButtons: [UIButton]!
    
    @IBOutlet weak var bottomView: UIView!
    
    let checkedImage = UIImage(named: "checked")!
    let editImage = UIImage(named: "editProfile")!
    
    
    var isChecked: Bool = false
    var info = UserModel.info().getDataFromUserDefault()
    var city = UserModel.info().getAddress()
    var name: String!
    var surname: String!
    var id: Int!
    var position: String!
    var sectionOfProfilePressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Animations.sharedInstance.setSettingsOfNavigationController(target: self)
        
        name = info["name"] as! String
        surname = info["surname"] as! String
        id = info["id"] as! Int
        nameTextField.text = name
        surnameTextField.text = surname
        setInterfaceSettings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        var city = UserModel.info().getAddress()
        position = city["city"] as! String
        addressLabel.text = position
        super.viewWillAppear(animated)
        if sectionOfProfilePressed{
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
        sectionOfProfilePressed = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if sectionOfProfilePressed{
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
    }

    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        surnameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        if isChecked{
            if nameTextField.text?.characters.count != 0 && surnameTextField.text?.characters.count != 0{
                disableBottomButtons(yes: false)
                
                if nameTextField.text != name || surnameTextField.text != surname{
                    name = nameTextField.text!
                    surname = surnameTextField.text!
                    updateUserInformation(name: name, surname: surname)
                }
                
                isChecked = !isChecked
            }else{
                showErrorAlert(errorMessage: "Заполните поля")
            }
        } else {
            disableBottomButtons(yes: true)
            isChecked = !isChecked
        }
    }
    
    func disableBottomButtons(yes: Bool){
        if yes{
            for button in bottomButtons{
                button.titleLabel?.textColor = UIColor.lightGray
            }
            self.editButton.image = checkedImage
            self.changePosition.alpha = 1
            bottomView.isHidden = false
            self.line1.layer.backgroundColor = UIColor.black.cgColor
            self.line2.layer.backgroundColor = UIColor.black.cgColor
            nameTextField.isUserInteractionEnabled = true
            surnameTextField.isUserInteractionEnabled = true
        }else{
            for button in bottomButtons{
                button.titleLabel?.textColor = #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1)
            }
            self.editButton.image = editImage
            self.changePosition.alpha = 0
            bottomView.isHidden = true
            self.line1.layer.backgroundColor = UIColor.lightGray.cgColor
            self.line2.layer.backgroundColor = UIColor.lightGray.cgColor
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
        }
        
    }
    
    
    @IBAction func changePosition(_ sender: UIButton) {
        sectionOfProfilePressed = true
        UserModel.info().typeOfPage = true
        let map = Bundle.main.loadNibNamed("MapSetAddress", owner: self, options: nil)?.first as! UIViewController
        self.navigationController?.pushViewController(map, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func setInterfaceSettings(){
        if self.view.frame.height < 600{
            changePosition.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 12)
        }
        nameTextField.isUserInteractionEnabled = false
        surnameTextField.isUserInteractionEnabled = false
    }
    
    
    func showErrorAlert(errorMessage: String){
        if let view = self.view.viewWithTag(1000){
            view.removeFromSuperview()
        }
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as!  ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        showErrorAlert.view.tag = 1000
        
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    
    // SHOW CHANGE PASSWORD VIEW
    @IBAction func showPopupChangePassword(_ sender: Any) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let popOverVC = UIStoryboard(name: "UserSettingsPart", bundle: nil).instantiateViewController(withIdentifier: "popUpChangePass") as! popUpViewChangePassword
        popOverVC.profile = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        super.touchesBegan(touches, with:event)
    }
    
    
    @IBAction func logOutButton(_ sender: UIButton) {
        Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        UserModel.info().removeUserDefault()
        let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Registration") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }
    
    
    func updateUserInformation(name: String, surname: String){
        let parameters: Dictionary<String, Any> = [
            "name" : name,
            "surname" : surname
        ]
        APIManager.sharedInstance.authChangeUser(userID: id, parameters: parameters, onSuccess: {(json) in
            var dict = [String: Any]()
            dict = ["name": name, "surname": surname, "id": self.info["id"] as! Int, "type": self.info["type"] as! Int]
            UserModel.info().saveUserDict(dict: dict)
            print(json)
        })
    }
    
}
