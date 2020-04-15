//
//  SelectTypesAndSubTypesVC.swift
//  Bloom
//
//  Created by Serik on 18.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

struct Section{
    var price: Int
    var dostavka: String
    var time: String
    var total: String
    
    init(price: Int, dostavka: String, time: String, total: String) {
        self.price = price
        self.dostavka = dostavka
        self.time = time
        self.total = total
    }
}


class SelectTypesAndSubTypesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int) { // ADDED
        // ADDED
    } // ADDED

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var background: UIImageView!
    @IBOutlet var backButtomView: UIView!
    @IBOutlet var selectService: UILabel!
    
    
    var imagesForType = [56: UIImage(named: "nails"), 37: UIImage(named: "Scissors-1"),14: UIImage(named: "eyeMakeUp"),1: UIImage(named: "bodyCare")]
    
    var sections = [Section]()
    var selectedPaths: [IndexPath] = []
    var typeOfSalon = UserModel.info().salonType
    var parents = UserModel.info().parent
    
    var info = UserModel.info().getDataFromUserDefault()
    var feature = UserModel.info().getFeature()
    var coll = [Int]()
    
    override func viewDidLoad() {
        getParent()
       
        
        
        if UserModel.info().typeOfPage == true{
            
            self.automaticallyAdjustsScrollViewInsets = false
            self.extendedLayoutIncludesOpaqueBars = true
            backButtomView.isHidden = true
            background.isHidden = true
            selectService.textColor = UIColor.black
            coll = feature["featureChild"] as! [Int]
            
         
            var count = 0
            var count1 = 0
            for i in newParent{
                count1 = 0
                for j in i.children{
                    if(coll.contains(j.id)){
                        list.append(j)
                        selectedPaths.append([count, count1])
                    }
                    count1 += 1
                }
                count += 1
            }
            
            tableView.reloadData()
        }
        super.viewDidLoad()
    }

    var newParent = [Feature]()
    func getParent(){
        var count = 0
        for parent in parents{
            if(self.typeOfSalon.contains(parent.id)){
                var qwe = [String]()
                
                newParent.append(parent)
                
                for child in parent.children{
                    qwe.append(child.name)
                }
                
                sections.append(Section(genre: parent.name, movies: qwe, expanded: false, id: parent.id ))
            }
            count += 1
        }
        self.tableView.reloadData()
    }
    
    
    
    //## TABLE VIEW FUNCTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.view.frame.height < 600{
            return 44
        }
        else{
            return 48
        }    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded == true) {
            if self.view.frame.height < 600{
                return 52
            }
            else{
                return 56.5
            }
        } else {
            return 0
        }
    }
    //## FOOTER HEIGHT
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.view.frame.height < 600{
            return 5
        }
        else{
            return 10
        }
    }
    // FOOTER COLOR
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UITableViewHeaderFooterView()
        footer.layer.backgroundColor = UIColor.clear.cgColor
        return footer
    }
    

    //## HEADER, CHANGE IMAGE HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HeaderCell
        cell.headerLabel.text = sections[section].genre
        
        header.reloadInputViews()
        header.contentView.backgroundColor = UIColor(red:0.01, green:0.42, blue:0.38, alpha:1.0)
        cell.headerLabel.textAlignment = .center
 
        if self.view.frame.height < 600{
            cell.headerLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
        }
        else{
            cell.headerLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        }
        
        var image = UIImageView()
        image = UIImageView.init(frame: CGRect(x: 15, y: (cell.frame.size.height) / 2 - 10, width: 20, height: 20))
        image.contentMode = UIViewContentMode.scaleAspectFit
        
        image.image = imagesForType[sections[section].id]!
        
        var imageView = UIImageView()
        if (sections[section].expanded == true) {
            imageView = UIImageView.init(frame: CGRect(x: (tableView.frame.size.width) - 30  , y: (cell.frame.size.height) / 2 - 5, width: 18, height: 10))
            imageView.image = UIImage(named: "downButton")
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            
        } else {
            imageView = UIImageView.init(frame: CGRect(x: (tableView.frame.size.width) - 30  , y: (cell.frame.size.height) / 2 - 5, width: 18, height: 10))
            imageView.image = UIImage(named: "upButton")
            imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
        let tappedSection = UIButton.init(frame: CGRect(x: 0, y: 0, width: (cell.frame.size.width), height: (cell.frame.size.height)))
        tappedSection.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        tappedSection.tag = section
        
        
        header.addSubview(cell)
        header.addSubview(image)
        header.addSubview(imageView)
        header.addSubview(tappedSection)

        return header
    }

    
    //TO SHOW SUBVIEW
    func sectionTapped(_ sender: UIButton) {
        let tag = sender.tag
        sections[tag].expanded = !sections[tag].expanded
        
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: tag), with: .automatic)
        tableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubviewCell") as! SubViewCell
        cell.indexPathOfCell = indexPath

        if list.contains(self.newParent[indexPath[0]].children[indexPath[1]]){
            cell.subViewView.backgroundColor = UIColor(red:0.76, green:0.63, blue:0.38, alpha:1.0)
        }
        else{
            cell.subViewView.backgroundColor = UIColor.gray
        }

        
        if self.view.frame.height < 600{
            cell.subViewLabel.font = UIFont(name: "Comfortaa-Regular", size: 13)
        }
        else{
            cell.subViewLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        }

        cell.protocolOfVC = self
        cell.subViewLabel.text = sections[indexPath.section].movies[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    var list = [Child]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !selectedPaths.contains(indexPath){
            selectedPaths.append(indexPath)

            list.append(self.newParent[indexPath[0]].children[indexPath[1]])
            
        }else{
            var count = 0
            for path in selectedPaths{
                if path == indexPath{
                    selectedPaths.remove(at: count)
                }
                count = count + 1
            }
            count = 0
            for i in list{
                if i == self.newParent[indexPath[0]].children[indexPath[1]]{
                    list.remove(at: count)
                }
                
                count += 1
                
            }
            
        }
        tableView.reloadData()
    }
    
    //## Next Button Pressed
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if(list.count != 0){
            UserModel.info().children = self.list
            let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "SecondSelectTypeTableView") as UIViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
            
        else{
            showErrorAlert(errorMessage: "select")
        }
}


    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //##### To call ErrorAlert
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as! ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
}

