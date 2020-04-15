//
//  ShowMediaViewController.swift
//  Bloom
//
//  Created by Жарас on 29.04.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ShowMediaViewController: UIViewController {

    var image: UIImage? = nil
    
    @IBOutlet weak var imageView: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titre.text = titreText
        
        if image != nil {
            imageView.image = image
        } else {
            print("image not found")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
