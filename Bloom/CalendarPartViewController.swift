//
//  CalendarViewController.swift
//  Bloom
//
//  Created by Жарас on 11.06.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import UIKit

class CalendarPartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleDay: UILabel!
    @IBOutlet weak var titleDayOfWeek: UILabel!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var noOrders: UIView!
    @IBOutlet weak var noOrdersLabel: UILabel!
    
    var dayString : String = ""
    var monthString : String = ""
    var today : Int = Int()
    var todayStr : String = ""
    var days = [String]()
    var daysOfFromTill = [String]()
    var listOfOrders : [Order] = []
    var finalListOfOrders : [Order] = []
    var reference : String = ""
    var arrayOfSalonInformations : [Salon] = []
    var from: String = String()
    var till: String = String()
    
    
    var imagesForType = [56: UIImage(named: "nails")?.maskWithColor(color: UIColor.lightGray), 37: UIImage(named: "Scissors-1")?.maskWithColor(color: UIColor.lightGray),14: UIImage(named: "eyeMakeUp")?.maskWithColor(color: UIColor.lightGray),1: UIImage(named: "bodyCare")?.maskWithColor(color: UIColor.lightGray)]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Animations.sharedInstance.showIndicator(viewController: self)
        
        daysTableView.dataSource = self
        daysTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        ordersTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        titleDay.textColor = UIColor(hex: "929292")
        titleDay.font = UIFont(name: "Comfortaa-Regular", size: 20)
        titleDayOfWeek.textColor = UIColor(hex: "C2A162")
        titleDayOfWeek.font = UIFont(name: "Comfortaa-Regular", size: 14)

        var futureDaysOfArray = [String]()
        var arrayOfFromTill = [String]()
        
        let secondsInADay: TimeInterval = 24 * 60 * 60
        let now = NSDate()
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        
        let dateFormatterForDay = DateFormatter()
        dateFormatterForDay.dateFormat = "dd MMM"
        dateFormatterForDay.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterForDay.locale = Locale(identifier: "ru_KZ")
        
        let dateFormatterForFromTill = DateFormatter()
        dateFormatterForFromTill.dateFormat = "yyyy-MM-dd"
        dateFormatterForFromTill.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterForFromTill.locale = Locale(identifier: "ru_KZ")
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
            let finalDate = dateFormatterForDay.string(from: finalDateOfCalendar!)
            let finalDateFromTill = dateFormatterForFromTill.string(from: finalDateOfCalendar!)
            futureDaysOfArray.append(finalDate)
            arrayOfFromTill.append(finalDateFromTill)
        }
        
        futureDaysOfArray.reverse()
        arrayOfFromTill.reverse()
        
        for i in 1 ..< futureDaysOfArray.count {
            days.append(futureDaysOfArray[i])
        }
        for i in 1 ..< arrayOfFromTill.count {
            daysOfFromTill.append(arrayOfFromTill[i])
        }
        let todayString = dateFormatterForDay.string(from: now as Date)
        todayStr = todayString
        for i in 0 ..< days.count {
            if days[i] == todayString {
                today = i
            }
        }
        
        from = daysOfFromTill[0]
        till = daysOfFromTill.last!
        
        getOrders()
        let todayPath = IndexPath.init(row: today, section: 0)
        self.daysTableView.scrollToRow(at: todayPath, at: .top, animated: true)
        self.daysTableView.selectRow(at: todayPath, animated: false, scrollPosition: .top)
        self.titleDay.text = Animations.sharedInstance.convertDateToTitleTimeString(UTCTime: days[todayPath.row])
        self.titleDayOfWeek.text = Animations.sharedInstance.convertDateToDayOfWeek(UTCTime: days[todayPath.row])
        let refer = days[todayPath.row]
        getOrdersOfSomeDate(reference: refer)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return days.count
        }
        else {
            return finalListOfOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            noOrders.alpha = 0
            titleDay.text = Animations.sharedInstance.convertDateToTitleTimeString(UTCTime: days[indexPath.row])
            titleDayOfWeek.text = Animations.sharedInstance.convertDateToDayOfWeek(UTCTime: days[indexPath.row])
            reference = days[indexPath.row]
            getOrdersOfSomeDate(reference: reference)
        }
        
        if tableView.tag == 2 {
            let storyboard = UIStoryboard(name: "CalendarPart", bundle: nil)
            let salonProfile = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            salonProfile.salonName = self.arrayOfSalonInformations[indexPath.row].salonName
            salonProfile.salonAddress = self.arrayOfSalonInformations[indexPath.row].salonAddress
            salonProfile.salonDistance = self.arrayOfSalonInformations[indexPath.row].salonDistance
            salonProfile.salonDescription = self.arrayOfSalonInformations[indexPath.row].salonDescription
            salonProfile.salonRating = self.arrayOfSalonInformations[indexPath.row].salonRating
            UserModel.info().calendarID = self.arrayOfSalonInformations[indexPath.row].salonId
            self.navigationController?.pushViewController(salonProfile, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DaysTableViewCell
            
            let dayOfCalendar = days[indexPath.row]
            cell.monthLabel.text = dayOfCalendar
            
            if indexPath.row == 0 {
                cell.selectedView.alpha = 1
                cell.monthLabel.textColor = UIColor.white
            } else {
                cell.selectedView.alpha = 0
            }
            
            var count = 0
            for order in listOfOrders{
                if order.orderDate == dayOfCalendar{
                    count = count + 1
                }
            }
            if count > 0{
                cell.countOfOrder.alpha = 1
                cell.countOfOrder.text = String(count)
            } else{
                cell.countOfOrder.alpha = 0
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(hex: "C2A162")
            cell.selectedBackgroundView = backgroundView
            
            if (indexPath.row == 0) {
                cell.monthLabel.textColor = UIColor.white
            } else {
                cell.monthLabel.textColor = UIColor(hex: "929292")
            }
            
            return cell
        }
            
        else if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersTableViewCell
            for view in cell.subviews{
                if view.tag >= 100{
                    view.removeFromSuperview()
                }
            }
            for _ in finalListOfOrders {
                noOrders.alpha = 0
                let order = finalListOfOrders[indexPath.row]
                cell.orderTime.text = order.orderTime
                cell.salonName.text = order.salonName
                for i in 0..<order.orderName.count{
                    let orderView: UIView = UIView()
                    orderView.tag = i + 100
                    let nameOfOrder = UILabel()
                    nameOfOrder.text = order.orderName[i]
                    let priceOfOrder = UILabel()
                    priceOfOrder.text = order.orderPrice[i]
                    
                    
                    
                    let image = UIImageView()
                    
                    image.frame = CGRect(x: 10, y: 15, width: 16, height: 16)
                    priceOfOrder.frame = CGRect(x: Int(orderView.frame.width - 50), y: 8, width: 50, height:32)
                    
                    image.image = imagesForType[order.orderType[i]]!

                    orderView.addSubview(image)
                    orderView.addSubview(nameOfOrder)
                    orderView.addSubview(priceOfOrder)
                    cell.addSubview(orderView)
                    
                    orderView.frame.size = CGSize(width: cell.contentView.frame.width - 15, height: 20)

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
            let order = finalListOfOrders[indexPath.row]
            return CGFloat((order.orderName.count * 25) + 50)
        }else{
            return 75
        }
    }
    
    func getOrdersOfSomeDate(reference: String){
        finalListOfOrders.removeAll()
        if self.view.frame.height < 600 {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
        } else {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 18)
        }
        if reference != "" {
            for i in listOfOrders {
                if i.orderDate == reference {
                    finalListOfOrders.append(i)
                } else if i.orderDate != reference {
                    noOrders.alpha = 1
                }
            }
            ordersTableView.reloadData()
        }
    }
    
    func getOrders() {
        APIManager.sharedInstance.orderSearchActivitiesInCalendar(from: from, till: till) { (json) in
            for data in json.array! {
                var order: Order = Order()
                var placeId = Int()
                var dateOfOrder = String()
                var date = String()
                var time = String()
                var finalPlaceId = Int()
    
                placeId = data["place"].int!
                dateOfOrder = data["time"].string!
                date = Animations.sharedInstance.convertDateToDateString(UTCTime: dateOfOrder)
                time = Animations.sharedInstance.convertDateToTimeString(UTCTime: dateOfOrder)
                var nameOfSalon = String()
                var nameOfAddress : String = String()
                var nameOfDescription : String = String()
                var nameOfRating : Int = Int()
                var nameOfDistance : String = String()

                for place in data["places"].array!{
                    if place["place"]["id"].int! == placeId{
                        nameOfSalon = place["place"]["name"].string!
                        nameOfAddress = place["place"]["address"].string!
                        nameOfDescription = place["place"]["description"].string!
                        nameOfRating = place["place"]["rating"].int!
                        nameOfDistance = place["distance"].string!
                        finalPlaceId = place["place"]["id"].int!
                    }
                }
                
                for feature in data["features"].array! {
                    order.orderName.append(feature["feature"]["name"].string!)
                    order.orderPrice.append(String(feature["price"].int!))
                    
                    let x = feature["feature"]["parent"].int!
                    
                    let array = [Int]()
                    order.orderType = Animations.sharedInstance.saveIdOfFeature(id: x, arrayID: array)
                }
                
                
                self.listOfOrders.append(Order(orderDate: date, orderType: order.orderType, orderName: order.orderName, orderPrice: order.orderPrice, orderTime: time, salonName: nameOfSalon))
                self.arrayOfSalonInformations.append(Salon(salonName: nameOfSalon, salonDistance: nameOfDistance, salonAddress: nameOfAddress, salonDescription: nameOfDescription, salonRating: nameOfRating, salonId: finalPlaceId))
            }
            
            OperationQueue.main.addOperation {
                self.daysTableView.reloadData()
                self.getOrdersOfSomeDate(reference: self.todayStr)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
        }
    }
}
