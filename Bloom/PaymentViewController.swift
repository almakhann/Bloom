//
//  PaymentViewController.swift
//  Bloom
//
//  Created by Жарас on 29.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var dateOfNextPayment: UILabel!
    @IBOutlet weak var paymentHistoryTableView: UITableView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Оплата"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentHistoryTableView.dequeueReusableCell(withIdentifier: "oneCell") as! PaymentHistoryCell
        if self.view.frame.height < 600{
            for label in cell.labelsCollection{
                label.font = UIFont(name: "Comfortaa-Regular", size: 11)
            }
            cell.amountOfPayment.font = UIFont(name: "Comfortaa-Regular", size: 11)
            cell.dateOfPayment.font = UIFont(name: "Comfortaa-Regular", size: 11)
            cell.paymentNumber.font = UIFont(name: "Comfortaa-Regular", size: 11)
            dateOfNextPayment.font = UIFont(name: "Comfortaa-Regular", size: 13)
            topLabel.font = UIFont(name: "Comfortaa-Regular", size: 12)
        }
        return cell
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
