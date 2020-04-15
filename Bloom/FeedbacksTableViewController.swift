//
//  FeedbacksTableViewController.swift
//  Bloom
//
//  Created by Жарас on 29.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class FeedbacksTableViewController: UITableViewController {
    
    var feedbacks: [Feedback] = [Feedback(text: "Была впервые в этом салоне. Осталась в незабываемои восторге! Показала на картинке цвет, который хочу мастеру Догану. Он смешал 5!!!! разных красок и сделал именно то, что я хотела. Теперь пойду к нему на кератин. И еще у них появился массаж. Там 2х часовой массаж сейчас по акции всего 6000 стоит. По городу везде уже 10000. Так что с понед еще и на массаж. Лето переди!", date: "22.10.2017", owner: "Аселя"),Feedback(text: "Была впервые в этом салоне. Осталась в незабываемои восторге! Показала на картинке цвет, который хочу мастеру Догану.", date: "23.10.2017", owner: "Камила")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Отзывы"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneFeedback", for: indexPath) as! OneFeedbackTableViewCell
        cell.owner.text = feedbacks[indexPath.row].owner
        cell.dateOfFeedback.text = feedbacks[indexPath.row].date
        cell.contextOfFeedback.text = feedbacks[indexPath.row].context
        
        return cell
    }
    

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
