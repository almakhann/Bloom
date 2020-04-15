//
//  ServicesVC.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/20/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    
    @IBOutlet weak var servicesTableView: UITableView!
        
    var imagesForType = [56: UIImage(named: "nails"), 37: UIImage(named: "Scissors-1"),14: UIImage(named: "eyeMakeUp"),1: UIImage(named: "bodyCare")]
    var sections = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = UserModel.info().calendarFeature
        servicesTableView.reloadData()
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "026C61")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Comfortaa-Bold", size: 20)!, NSForegroundColorAttributeName:UIColor.white]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].types.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded == true) {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].features , section: section, delegate: self)
        header.contentView.backgroundColor = UIColor(hex: "F9F9F9")
        
        var image = UIImageView()
        image = UIImageView.init(frame: CGRect(x: 15, y: 10 , width: 20, height: 20))
        image.contentMode = UIViewContentMode.scaleAspectFit
        image.image = imagesForType[sections[section].id]!
        image.image = image.image?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor(hex: "C8AA71")
        
        header.addSubview(image)
        
        return header
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        servicesTableView.beginUpdates()
        servicesTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.textColor = UIColor(hex: "81807E")
        cell.textLabel?.text = sections[indexPath.section].types[indexPath.row]
        return cell
    }
}
