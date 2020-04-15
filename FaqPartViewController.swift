//
//  FaqVC.swift
//  Bloom
//
//  Created by Serik on 04.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe
import Alamofire

class FaqPartViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var answers: [String] = []
    var questions: [String] = []
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.delegate = self
        tableview.dataSource = self
        
        Animations.sharedInstance.setSettingsOfNavigationController(target: self)
        self.navigationItem.title = "F.A.Q."
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 140
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as? faqCell{
            cell.answerLabel.text = answers[indexPath.row]
            cell.questionLabel.text = questions[indexPath.row]
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func getData(){
        APIManager.sharedInstance.faqGetQuestionsAndAnswers(type: UserModel.info().type, onSuccess: {(json) in
            if json.count != 0{
                for cell in json.array!{
                    self.answers.append(cell["answer"].string!)
                    self.questions.append(cell["question"].string!)
                }
            }
            self.tableview.reloadData()
        })
    }
    
}
