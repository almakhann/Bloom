//
//  CategoryVC.swift
//  Bloom
//
//  Created by Serik on 14.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func backPressed(_ sender: UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    var tag: Int?
    @IBAction func chooseCategory(_ sender: UIButton) {
        tag = sender.tag
        
        UserModel.info().type = tag!
        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "UserInformationVC") as UIViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
