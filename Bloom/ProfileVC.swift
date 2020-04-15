//
//  ProfileVC.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/19/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import Foundation

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let sharedInstance = ProfileVC()
    var arrayOfComments = [Comment]()
    
    @IBOutlet weak var profilesTableView: UITableView!
    
    let messageAndIconsButtonColor = UIColor(hex: "026C61")
    let checkMarkButtonColor = UIColor(hex: "C2A162")
    let infAndCommmentsLabelsColor = UIColor(hex: "686868")
    let titleAndCommentNameLabelsColor = UIColor(hex: "C2A162")
    
    var salonName : String = String()
    var salonDistance : String = String()
    var salonAddress : String = String()
    var salonDescription : String = String()
    var salonRating : Int = Int()
    var salonPhone : String = String()
    var headerLabel: UILabel!
    var feedbackBool : Bool = Bool()
    var arrayOfSalonInformations : [Salon] = []
    var stars : [UIImageView] = []
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Animations.sharedInstance.showIndicator(viewController: self)
        id = UserModel.info().calendarID
        getFeedbacks(id: id)
        
        profilesTableView.register(UINib(nibName: "ProfTableCell", bundle: nil), forCellReuseIdentifier: "profCell")
        profilesTableView.register(UINib(nibName: "CommentTableCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        profilesTableView.rowHeight = UITableViewAutomaticDimension
        profilesTableView.estimatedRowHeight = 10

        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.topItem?.title = salonName
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "026C61")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Comfortaa-Bold", size: 20)!, NSForegroundColorAttributeName:UIColor.white]
        
        profilesTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfComments.count + 1
    }
    
    func executeRating(array: [UIImageView], count: Int) {
        var count1 = count
        if (count1 > 5 || count1 == 5) {
            count1 = 5
        }
        if (count1 < 0 || count1 == 0) {
            count1 = 0
        }
        if (count1 < 5 && count1 > 0) {
            count1 = count
        }
        for i in 0 ..< count1 {
            
            let image = array[i]
            image.image = UIImage(named: "Star_Yellow")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profCell", for: indexPath) as! ProfTableCell
            stars.removeAll()
            stars.append(cell.firstStar)
            stars.append(cell.secondStar)
            stars.append(cell.thirdStar)
            stars.append(cell.fourthStar)
            stars.append(cell.fifthStar)
            
            var distance = Double(salonDistance)
            distance = round((10*distance!))/10
            
            cell.labelOfSalon.text = salonName
            cell.labelOfStreet.text = salonAddress
            cell.infoLabel.text = salonDescription
            cell.labelOfDistance.text = String(describing: distance!) + " км"
            cell.labelOfPhone.text = salonPhone
            
            if self.view.frame.height < 600{
                cell.labelOfSalon.font = UIFont(name: "Comfortaa-Regular", size: 18)
            }else{
                cell.labelOfSalon.font = UIFont(name: "Comfortaa-Regular", size: 20)
            }
            self.executeRating(array: stars, count: salonRating)
            cell.showButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            return cell
        }
        if indexPath.row > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableCell
            cell.topMargin.constant = 0
            if indexPath.row == 1{
                if headerLabel != nil{
                    headerLabel.removeFromSuperview()
                }
                headerLabel = UILabel(frame: CGRect(x: 30, y: 10, width: cell.contentView.frame.width-50, height: 20))
                headerLabel.tag = 999
                headerLabel.text = "Отзывы"
                headerLabel.font = UIFont(name: "Comfortaa-Regular", size: 18)
                headerLabel.textColor = UIColor(hex: "686868")
                cell.contentView.addSubview(headerLabel)
                cell.topMargin.constant = 30
            } else {
                if let label = cell.viewWithTag(999){
                    label.removeFromSuperview()
                }
            }
            let index = indexPath.row - 1
            cell.name.text = arrayOfComments[index].name
            cell.date.text = arrayOfComments[index].date
            cell.comment.text = arrayOfComments[index].comment
            return cell
        }
        return UITableViewCell()
    }

    func buttonPressed(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "CalendarPart", bundle: nil)
        let salonProfile = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        self.navigationController?.pushViewController(salonProfile, animated: true)
    }
    
    func getFeedbacks(id: Int) {
        APIManager.sharedInstance.placeGetByID(placeID: id) { (json) in
            print("json")
            print(json)
            var comment = [Comment]()
            for feed in json["feedback"].array! {
                comment.append(Comment(name: feed["owner"]["name"].string!,
                                       date: Animations.sharedInstance.convertDateToDateStringToComment(UTCTime:feed["date"].string!),
                                       comment: feed["text"].string! ))
            }
            self.arrayOfComments = comment
            self.salonPhone = json["owner"]["phone"].string!
        
            var parent = [Int]()
            var featureChild = [Int]()
            var featureSubChild = [Int]()
            let parents = UserModel.info().parent
            
            for features in json["feature"].array!{
                featureSubChild.append(features["id"].int!)
                let x = features["parent"].int!
                if(!featureChild.contains(x)){
                    featureChild.append(x)
                    
                    parent = Animations.sharedInstance.saveIdOfFeature(id: x, arrayID: parent)
                }
            }
            var sections = [Service]()
            var count = 0
            for info in parents{
                if parent.contains(info.id){
                    var qwe = [String]()
                    for child in info.children{
                        for subChild in child.children{
                            if featureSubChild.contains(subChild.id){
                                qwe.append(subChild.name)
                            }
                        }
                    }
                    sections.append(Service(features: info.name, types: qwe, expanded: false, id: info.id))
                }
                count += 1
            }
            UserModel.info().calendarFeature = sections
            self.profilesTableView.reloadData()
        }
     Animations.sharedInstance.hideIndicator(viewController: self)
    }
}
