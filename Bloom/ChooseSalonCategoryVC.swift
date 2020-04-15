//
//  ChooseSalonCategoryVC.swift
//  Bloom
//
//  Created by Serik on 15.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ChooseSalonCategoryVC: UIViewController {
    
    @IBOutlet var background: UIImageView!
    @IBOutlet var backButtonView: UIView!
    @IBOutlet var selectServiceLabel: UILabel!
    @IBOutlet var categoryButtons: [UIButton]!
    
    var isPressed: Bool = false
    var array = [Int]()
    var tag: Int?

 
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserModel.info().typeOfPage == true {
            self.automaticallyAdjustsScrollViewInsets = false
            self.extendedLayoutIncludesOpaqueBars = true
            backButtonView.isHidden = true
            background.isHidden = true
            selectServiceLabel.textColor = UIColor.black
            let info = UserModel.info().getFeature()
            array = info["parent"] as! [Int]
        }
        
        for category in categoryButtons{
            if(array.contains(category.tag)){
                category.backgroundColor = UIColor(red:0.73, green:0.58, blue:0.30, alpha:1.0)
            }
        }
    }


    @IBAction func buttonPressed(_ sender: UIButton) {
        tag = sender.tag
 
        if(!array.contains(tag!)){
            array.append(tag!)
            self.view.viewWithTag(Int(tag!))?.backgroundColor = UIColor(red:0.73, green:0.58, blue:0.30, alpha:1.0)
        }
        else{
            var count = 0
            for path in array{
                if path == tag{
                    array.remove(at: count)
                }
                self.view.viewWithTag(Int(tag!))?.backgroundColor = UIColor(red:0.01, green:0.42, blue:0.38, alpha:1.0)
                count += 1
            }
        }
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if array.count != 0{
            UserModel.info().salonType = array
            let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "SelectTypesAndSubTypesVC") as UIViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else{
            showErrorAlert(errorMessage: "Select")
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

}
