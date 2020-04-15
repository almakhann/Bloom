//
//  ListSegueTable.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/14/17.
//  Copyright © 2017 asamasa. All rights reserved.
//
import Foundation
import UIKit

class ListSegueTable: UIView, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var salonResponseListTableView: UITableView!
    var superVC:UIViewController!
    
    var allFeatures : [Category] = []
    var massiveOfSalons : [Marker] = []
    var stars : [UIImageView] = []
    var phoneNumber = String()
        
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ListSegueTable", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setupTableView() {
        salonResponseListTableView.dataSource = self
        salonResponseListTableView.delegate = self
        
        salonResponseListTableView.reloadData()
        
        let buttonImage = UIButton(frame: CGRect(x: 20, y: self.frame.height - 64 - 50, width: 45, height: 45))
        
        buttonImage.backgroundColor = UIColor(hex: "026C61")
        let image = UIImage(named: "placeholder")
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: buttonImage.bounds.width/2, y: buttonImage.bounds.height/2, width: 32, height: 32)
        imageView.center.x = buttonImage.bounds.width/2
        imageView.center.y = buttonImage.bounds.height/2
        buttonImage.setImage(imageView.image, for: .normal)
        buttonImage.layer.cornerRadius = 3
        buttonImage.addTarget(self, action: #selector(opentable(sender:)), for: .touchUpInside)
        self.addSubview(buttonImage)
        
        self.backgroundColor = UIColor.white
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
    
    required init?(coder aDecoder: NSCoder) {        
        super.init(coder: aDecoder)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massiveOfSalons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ListOfSalonsTableViewCell", owner: self, options: nil)?.first as! ListOfSalonsTableViewCell
        cell.distanceImage.image = UIImage(named: "distance")
        cell.distanceLabel.text = massiveOfSalons[indexPath.row].distance
        cell.streetImage.image = UIImage(named: "Point")
        cell.streetLabel.text = massiveOfSalons[indexPath.row].salonAddress
        cell.nameOfSalonLabel.text = massiveOfSalons[indexPath.row].salonName
        if superVC.view.frame.height < 600{
            cell.nameOfSalonLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        }else{
            cell.nameOfSalonLabel.font = UIFont(name: "Comfortaa-Regular", size: 22)
        }
        if massiveOfSalons[indexPath.row].status == 1 {
            cell.checkMarkImage.alpha = 1
            cell.checkMarkImage.image = UIImage(named: "check")
        }
        cell.checkMarkImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.checkMarkImage.addGestureRecognizer(tapGestureRecognizer)
        
        stars.removeAll()
        stars.append(cell.firstStar)
        stars.append(cell.secondStar)
        stars.append(cell.thirdStar)
        stars.append(cell.fourthStar)
        stars.append(cell.fifthStar)
        
        self.executeRating(array: stars, count: massiveOfSalons[indexPath.row].salonRating)

        cell.selectionStyle = .none
        cell.nameOfSalonLabel.sizeToFit()
        
        if superVC.view.frame.height < 600 {
            cell.nameOfSalonLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        } else {
            cell.nameOfSalonLabel.font = UIFont(name: "Comfortaa-Regular", size: 22)
        }
        return cell
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("CheckMark Image Tapped!!!")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clear
        let highlightedView : UIView = UIView(frame: CGRect(x: 5, y: 5, width: self.frame.size.width - 10, height: 100))
        
        highlightedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        highlightedView.layer.masksToBounds = false
        highlightedView.layer.cornerRadius = 1.0
        highlightedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        highlightedView.layer.shadowOpacity = 0.5
        highlightedView.layer.shadowRadius = 3.0
        
        cell.contentView.addSubview(highlightedView)
        cell.contentView.sendSubview(toBack: highlightedView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MapPart", bundle: nil)
        let salonProfile = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        salonProfile.distanceImg = UIImage(named: "distance")
        salonProfile.distanceLbl = self.massiveOfSalons[indexPath.row].distance
        salonProfile.streetImg = UIImage(named: "Point")
        salonProfile.streetLbl = self.massiveOfSalons[indexPath.row].salonAddress
        salonProfile.salonName = self.massiveOfSalons[indexPath.row].salonName
        salonProfile.salonRating = self.massiveOfSalons[indexPath.row].salonRating
        salonProfile.salonDescription = self.massiveOfSalons[indexPath.row].salonDescription
        salonProfile.salonStatus = self.massiveOfSalons[indexPath.row].status
        salonProfile.allFeatures = self.allFeatures
        UserModel.info().calendarID = self.massiveOfSalons[indexPath.row].id
        superVC.navigationController?.pushViewController(salonProfile, animated: true)
    }
    
    
    func opentable(sender : UIButton){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.showHideTransitionViews], animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }

}
