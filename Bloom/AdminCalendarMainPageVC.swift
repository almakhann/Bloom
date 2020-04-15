//
//  AdminCalendarMainPageVC.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/21/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminCalendarMainPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var titleDay: UILabel!
    @IBOutlet weak var titleDayOfWeek: UILabel!
    @IBOutlet weak var noOrdersView: UIView!
    @IBOutlet weak var noOrdersLabel: UILabel!
    
    var ordersList : [OrderAdmin] = []
    var finalOrdersList : [OrderAdmin] = []
    var days = [String]()
    var reference : String = ""
    var today : Int = Int()
    var todayStr : String = ""
    var deleteIndexPath : Int = Int()
    var indPth : IndexPath = []
    var indexPathOfSelectedDay: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Animations.sharedInstance.showIndicator(viewController: self)
        
        ordersTableView.register(UINib(nibName: "AdminOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCell")
        
        titleDay.textColor = UIColor(hex: "929292")
        titleDay.font = UIFont(name: "Comfortaa-Regular", size: 20)
        titleDayOfWeek.textColor = UIColor(hex: "C2A162")
        titleDayOfWeek.font = UIFont(name: "Comfortaa-Regular", size: 14)

        getOrdersOfAdmin()
        
        var futureDaysOfArray = [String]()
        
        let secondsInADay: TimeInterval = 24 * 60 * 60
        let now = NSDate()
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        for i in 1...31 {
            let theDate = now.addingTimeInterval(secondsInADay * TimeInterval(31 - i))
            var ComponentOfDay = DateComponents()
            let dateComponent = calendar?.components(.day, from: theDate as Date)
            ComponentOfDay.day = dateComponent?.day
            let monthComponent = calendar?.components(.month, from: theDate as Date)
            ComponentOfDay.month = monthComponent?.month
            let yearComponent = calendar?.components(.year, from: theDate as Date)
            ComponentOfDay.year = yearComponent?.year
            let dayOfWeek = calendar?.components(.weekday, from: theDate as Date)
            ComponentOfDay.weekday = dayOfWeek?.weekday
            let finalDateOfCalendar = calendar?.date(from: ComponentOfDay)!
            let finalDate = dateFormatter.string(from: finalDateOfCalendar!)
            futureDaysOfArray.append(finalDate)
        }
        futureDaysOfArray.reverse()
        
        for i in 1 ..< futureDaysOfArray.count {
            days.append(futureDaysOfArray[i])
        }
        let todayString = dateFormatter.string(from: now as Date)
        todayStr = todayString
        for i in 0 ..< days.count {
            if days[i] == todayString {
                today = i
            }
        }
        let todayPath = IndexPath.init(row: today, section: 0)
        self.daysTableView.scrollToRow(at: todayPath, at: .none, animated: true)
        self.daysTableView.selectRow(at: todayPath, animated: false, scrollPosition: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        indexPathOfSelectedDay = IndexPath(row: 0, section: 0)
        self.daysTableView.scrollToRow(at: indexPathOfSelectedDay, at: .top, animated: true)
        self.daysTableView.selectRow(at: indexPathOfSelectedDay, animated: false, scrollPosition: .top)
        self.titleDay.text = Animations.sharedInstance.convertDateToTitleTimeString(UTCTime: days[indexPathOfSelectedDay.row])
        self.titleDayOfWeek.text = Animations.sharedInstance.convertDateToDayOfWeek(UTCTime: days[indexPathOfSelectedDay.row])
        let refer = days[indexPathOfSelectedDay.row]
        getOrdersOfSomeDate(reference: refer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return days.count
        }
        else {
            return finalOrdersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            noOrdersView.alpha = 0
            titleDay.text = Animations.sharedInstance.convertDateToTitleTimeString(UTCTime: days[indexPath.row])
            titleDayOfWeek.text = Animations.sharedInstance.convertDateToDayOfWeek(UTCTime: days[indexPath.row])
            reference = days[indexPath.row]
            getOrdersOfSomeDate(reference: reference)
            self.indexPathOfSelectedDay = indexPath
        }
        if tableView.tag == 2 {
            deleteIndexPath = indexPath.row
            indPth = indexPath
            self.createAlert(title: "Вы действительно хотите принять заявку?")
        }
        ordersTableView.reloadData()
    }
    
    func createAlert (title: String!) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Принять", style: .default, handler: { (action) in
            self.alertOkPressed()
        }))
        alert.addAction(UIAlertAction(title: "Отклонить", style: .destructive, handler: { (action) in
            self.alertNoPressed()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    var responseView : UIView = UIView()
    
    func alertOkPressed() {
        Animations.sharedInstance.showIndicator(viewController: self)
        responseView.backgroundColor = UIColor(hex: "FBFBFB")
        responseView.layer.borderWidth = 0.5
        responseView.layer.borderColor = UIColor.lightGray.cgColor
        let checkMarkButton = UIButton()
        checkMarkButton.backgroundColor = UIColor(hex: "C2A162")
        checkMarkButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        let chekedLabel = UILabel()
        chekedLabel.text = "Успешное подтвержение заявки!"
        chekedLabel.textColor = UIColor(hex: "545454")
        chekedLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
        responseView.addSubview(checkMarkButton)
        responseView.addSubview(chekedLabel)
        self.view.addSubview(responseView)
        
        checkMarkButton.frame.origin = CGPoint(x: 0, y: 0)
        checkMarkButton.frame.size = CGSize(width: (tabBarController?.tabBar.frame.height)!, height: (tabBarController?.tabBar.frame.height)!)
        chekedLabel.frame.origin = CGPoint(x: (tabBarController?.tabBar.frame.height)! + 10, y: (tabBarController?.tabBar.frame.height)!/4)
        chekedLabel.frame.size = CGSize(width: (tabBarController?.tabBar.frame.width)! - (tabBarController?.tabBar.frame.height)! + 10, height: 18)
        
        responseView.frame.size = CGSize(width: self.view.frame.size.width, height: (tabBarController?.tabBar.frame.height)!)
        responseView.frame.origin = CGPoint(x: self.view.frame.size.width, y: self.view.frame.size.height - (tabBarController?.tabBar.frame.height)!)
        
        self.acceptOrder(responseID: finalOrdersList[indPth.row].responseID)
        
    }
    
    func alertNoPressed() {
        Animations.sharedInstance.showIndicator(viewController: self)
        self.declineOrder(responseID: finalOrdersList[indPth.row].responseID)
    }
 
    func showView(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.responseView.frame.origin.x = 0
        }) { (finished) in
            self.hideView(view: self.responseView)
        }
    }
    
    func hideView(view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0.8, animations: {
            self.responseView.frame.origin.x = view.frame.size.width
        }) { finished in
            self.showTabBar()
        }
    }
    
    func hideButtonView(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            self.responseView.frame.origin.x = view.frame.size.width
        }) { finished in
            self.showTabBar()
        }
    }
    
    func hideTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height + (frame?.size.height)!
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.tabBar.frame = frame!
        }) { finished in
            self.showView(view: self.responseView)
        }
    }
    
    func showTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height - (frame?.size.height)!
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "daysCell", for: indexPath) as! AdminDaysTableViewCell
            
            let dayOfCalendar = days[indexPath.row]
            cell.dayLabel.text = dayOfCalendar
            
            if indexPath == indexPathOfSelectedDay{
                daysTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            if indexPath.row == 0 {
                cell.selectedView.alpha = 1
                cell.dayLabel.textColor = UIColor.white
            } else {
                cell.selectedView.alpha = 0
            }

            var count = 0
            for order in ordersList{
                if order.orderDate == dayOfCalendar{
                    count = count + 1
                }
            }
            if count > 0{
                cell.countOfOrder.alpha = 1
                cell.countOfOrder.text = String(count)
            }else{
                cell.countOfOrder.alpha = 0
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(hex: "C2A162")
            cell.selectedBackgroundView = backgroundView
            
            if (indexPath.row == 0) {
                cell.dayLabel.textColor = UIColor.white
            } else {
                cell.dayLabel.textColor = UIColor(hex: "929292")
            }
            
            return cell
        }
        else if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! AdminOrdersTableViewCell
            for view in cell.subviews{
                if view.tag >= 100{
                    view.removeFromSuperview()
                }
            }
            
            for _ in finalOrdersList {
                noOrdersView.alpha = 0
                let order = finalOrdersList[indexPath.row]
                cell.orderTime.text = order.orderTime
                cell.salonName.text = order.userName + ", " + order.userPhone
                for i in 0..<order.orderName.count{
                    let orderView: UIView = UIView()
                    orderView.tag = i + 100
                    let nameOfOrder = UILabel()
                    nameOfOrder.text = order.orderName[i]
                    let priceOfOrder = UILabel()
                    priceOfOrder.text = order.orderPrice[i]
                    let imageName = "Nails_Green"
                    let image = UIImage(named: imageName)
                    let imageView = UIImageView(image: image!)
                    orderView.addSubview(imageView)
                    orderView.addSubview(nameOfOrder)
                    orderView.addSubview(priceOfOrder)
                    cell.addSubview(orderView)
                    
                    orderView.frame.size = CGSize(width: cell.contentView.frame.width - 15, height: 20)
                    imageView.frame = CGRect(x: 10, y: 15, width: 16, height: 16)
                    priceOfOrder.frame = CGRect(x: Int(orderView.frame.width - 50), y: 8, width: 50, height:32)
                    nameOfOrder.frame = CGRect(x: 30, y: 8, width: 10+orderView.frame.width-priceOfOrder.frame.width, height:32)
                    priceOfOrder.baselineAdjustment = .alignCenters
                    priceOfOrder.numberOfLines = 0
                    priceOfOrder.textAlignment = .right
                    nameOfOrder.baselineAdjustment = .alignCenters
                    nameOfOrder.numberOfLines = 0
                    
                    orderView.center.x = cell.contentView.center.x
                    orderView.frame.origin = CGPoint(x: 5, y: i*27)
                    priceOfOrder.textColor = UIColor(hex: "C2A162")
                    nameOfOrder.textColor = UIColor(hex: "636262")
                    if self.view.frame.height < 600{
                        nameOfOrder.font = UIFont(name: "Comfortaa-Regular", size: 11)
                        priceOfOrder.font = UIFont(name: "Comfortaa-Regular", size: 12)
                    }else{
                        nameOfOrder.font = UIFont(name: "Comfortaa-Regular", size: 13)
                        priceOfOrder.font = UIFont(name: "Comfortaa-Regular", size: 14)
                    }
                }
            }
            cell.selectionStyle = .default
            return cell
        }
        ordersTableView.reloadData()
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 2 {
            let order = finalOrdersList[indexPath.row]
            return CGFloat((order.orderName.count * 25) + 50)
        }else{
            return 75
        }
    }
    
    func getOrdersOfSomeDate(reference: String){
        finalOrdersList.removeAll()
        if self.view.frame.height < 600 {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        } else {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 18)
        }
        if reference != "" {
            for i in ordersList {
                if i.orderDate == reference {
                    finalOrdersList.append(i)
                }
                else if i.orderDate != reference {
                    noOrdersView.alpha = 1
                }
            }
            ordersTableView.reloadData()
        }
        print(ordersList.count,finalOrdersList.count)
    }

    func getOrdersOfAdmin() {
        APIManager.sharedInstance.orderGetOrders { (json) in
            print(json)
            for data in json.array! {
                if data["status"].int == 0{
                    var order: OrderAdmin = OrderAdmin()
                    var date = String()
                    var time = String()
                    let mainDate = data["request"]["time"].string!
                    date = Animations.sharedInstance.convertDateToDateString(UTCTime: mainDate)
                    time = Animations.sharedInstance.convertDateToTimeString(UTCTime: mainDate)
                    let responseID = data["id"].int!
                    let requestID = data["request"]["id"].int!
                    let userName = data["request"]["owner"]["name"].string!
                    let userPhone = data["request"]["owner"]["phone"].string!
                    
                    for feature in data["request"]["features"].array! {
                        order.orderName.append(feature["feature"]["name"].string!)
                        order.orderPrice.append(String(feature["price"].int!))
                        order.orderType.append(feature["id"].int!)
                    }
                    self.ordersList.append(OrderAdmin(orderDate: date, orderType: order.orderType, orderName: order.orderName, orderPrice: order.orderPrice, orderTime: time, userName: userName, userPhone: userPhone, requestID: requestID, responseID: responseID))
                }
            }
            OperationQueue.main.addOperation {
                self.daysTableView.reloadData()
                self.getOrdersOfSomeDate(reference: self.todayStr)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
        }
    }
    func acceptOrder(responseID: Int) {
        APIManager.sharedInstance.orderAcceptOrderOfUser(responseID: responseID) { (json) in
            print(json)
            Animations.sharedInstance.hideIndicator(viewController: self)
            self.deleteFormOrderList(orderToDelete: self.finalOrdersList[self.deleteIndexPath])
            self.finalOrdersList.remove(at: self.deleteIndexPath)
            self.ordersTableView.deleteRows(at: [self.indPth], with: .right)
            self.daysTableView.reloadData()
            self.hideTabBar()
            print(self.ordersList.count,self.finalOrdersList.count)
        }
    }
    func deleteFormOrderList(orderToDelete: OrderAdmin){
        var count = 0
        for order in ordersList{
            if order.responseID == orderToDelete.responseID{
                ordersList.remove(at: count)
            }
            count+=1
        }
    }
    func declineOrder(responseID: Int) {
        APIManager.sharedInstance.orderDeleteResponsedOrderAdmin(responseID: responseID) { (json) in
            print(json)
            Animations.sharedInstance.hideIndicator(viewController: self)
            self.deleteFormOrderList(orderToDelete: self.finalOrdersList[self.deleteIndexPath])
            self.finalOrdersList.remove(at: self.deleteIndexPath)
            self.ordersTableView.deleteRows(at: [self.indPth], with: .right)
            self.daysTableView.reloadData()
        }
    }
}

