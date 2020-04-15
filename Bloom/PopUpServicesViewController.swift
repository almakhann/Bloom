//
//  PopUpServicesViewController.swift
//  Bloom
//
//  Created by Жарас on 22.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class PopUpServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var servicesAlertView: UIView!
    @IBOutlet weak var servicesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var servicesAlertViewHeight: NSLayoutConstraint!
    
    var services: [String] = []
    var types: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        servicesTableViewHeight.constant = CGFloat(services.count * 42)
        servicesAlertViewHeight.constant = servicesTableViewHeight.constant + 105
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "service") as! ServiceCell
        cell.nameOfService.text = services[indexPath.row]
        cell.imageOfService.image = UIImage(named: "eyeMakeUp")?.maskWithColor(color: #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1))
        return cell
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        removeAnimate()
    }
    
    func setService(servicesOfDialog: [_Service]){
        for oneService in servicesOfDialog{
            services.append(oneService.name)
            types.append(oneService.type)
        }
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
