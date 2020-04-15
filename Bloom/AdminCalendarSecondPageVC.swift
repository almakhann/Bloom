//
//  AdminCalendarSecondPageVC.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/22/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AdminCalendarSecondPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Admin Second Page(Times and Orders)
    @IBOutlet weak var timesTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var titleDay: UILabel!
    @IBOutlet weak var titleDayOfWeek: UILabel!
    @IBOutlet weak var noOrdersView: UIView!
    @IBOutlet weak var noOrdersLabel: UILabel!
    
    var simpleDay : String = ""
    var simpleDayOfWeek : String = ""
    
    //Admin Second Page(Calendar)
    @IBOutlet weak var calendarShowView: UIView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var acceptButton: UIButton!
    
    var testCalendar = Calendar.current
    var selectedDate: Date! = Date() {
        didSet {
            setDate()
        }
    }
    var selected:Date = Date() {
        didSet {
            calendarView.selectDates([selected])
        }
    }
    var currentDate: Date! = Date() {
        didSet {
            setDate()
        }
    }
    
    let formatter = DateFormatter()
    var alertIsHere: Bool = false
    var secondOrdersList : [OrderAdminCalendar] = []
    var finalSecondOrdersList : [OrderAdminCalendar] = []
    var times = [String]()
    var secondOrderArray : [OrderAdminCalendar] = []
    var reference : String = ""
    var today : Int = Int()
    var todayStr : String = String()
    var firstTime : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Animations.sharedInstance.showIndicator(viewController: self)
        
        setDate()
        currentDate = Date()
        
        calendarView.scrollToDate(currentDate)
        calendarView.selectDates([currentDate])
        
        getOrdersCalendar()
        
        calendarShowView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        acceptButton.tintColor = UIColor(hex: "C2A162")
        self.navigationController?.isNavigationBarHidden = true
        ordersTableView.register(UINib(nibName: "AdminSecondPageOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCell")
        
        titleDay.textColor = UIColor(hex: "929292")
        titleDay.font = UIFont(name: "Comfortaa-Regular", size: 20)
        titleDayOfWeek.textColor = UIColor(hex: "C2A162")
        titleDayOfWeek.font = UIFont(name: "Comfortaa-Regular", size: 14)
        
        setupCalendarView()
        dayWhenDidLoad()
        
        let now = NSDate()
        let dateFormatterForDay = DateFormatter()
        dateFormatterForDay.dateFormat = "dd MMM"
        dateFormatterForDay.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterForDay.locale = Locale(identifier: "ru_KZ")
        let todayString = dateFormatterForDay.string(from: now as Date)
        todayStr = todayString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getOrdersOfSomeDateTime(reference: todayStr)
        if times.count != 0 {
            getOrdersOfSomeDate(reference: times[0])
        }
        dayWhenDidLoad()
    }
    
    func dayWhenDidLoad() {
        let date = NSDate()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru_KZ")
        titleDay.text = formatter.string(from: date as Date)
        formatter.dateFormat = "EEEE"
        titleDayOfWeek.text = formatter.string(from: date as Date)
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
    }
    
    func setDate() {
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        let today = testCalendar.dateComponents([.day, .month, .year], from: currentDate)
        let dateFromCalendar = testCalendar.dateComponents([.day, .month, .year], from: cellState.date)
        guard let validCell = view as? AdminCalendar else { return }
        if validCell.isSelected{
            validCell.dayLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
            validCell.dayLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dayLabel.textColor = UIColor(hex: "797979")
                if dateFromCalendar == today{
                    validCell.dayLabel.font = UIFont(name: "Comfortaa-Bold", size: 18)
                    validCell.dayLabel.textColor = UIColor(hex: "026C61")
                }
            } else if cellState.dateBelongsTo != .thisMonth{
                validCell.dayLabel.textColor = UIColor(hex: "CCCCCC")
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? AdminCalendar else { return }
        if validCell.isSelected{
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarButtonPressed(_ sender: UIButton) {
        if !alertIsHere{
            alertIsHere = true
            
        }else{
            alertIsHere = false
        }
        if !alertIsHere{
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.calendarShowView.alpha = 0
                self.calendarShowView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: nil)
        } else if alertIsHere{
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.calendarShowView.alpha = 1
                self.calendarShowView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.calendarShowView.alpha = 0
            self.calendarShowView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) in
            
            self.titleDay.text = self.simpleDay
            self.titleDayOfWeek.text = self.simpleDayOfWeek
            self.getOrdersOfSomeDateTime(reference: self.simpleDay)
            if self.times.count > 0 {
                self.getOrdersOfSomeDate(reference: self.times[0])
            }
        }
        alertIsHere = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return times.count
        }
        else {
            return finalSecondOrdersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! AdminTimesTableViewCell
            cell.timeLabel.text = times[indexPath.row]
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            cell.selectionStyle = .default
            return cell
        }
         else if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! AdminSecondPageOrderTableViewCell
            for view in cell.subviews {
                if view.tag >= 100 {
                    view.removeFromSuperview()
                }
            }
            for _ in finalSecondOrdersList {
                noOrdersView.alpha = 0
                let order = finalSecondOrdersList[indexPath.row]
                cell.nameAndPhoneLabel.text = order.userName + ", " + order.userPhone
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
                    
                    orderView.frame.size = CGSize(width: cell.contentView.frame.width - 15, height: 16)
                    imageView.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
                    priceOfOrder.frame = CGRect(x: Int(orderView.frame.width - 50), y: 3, width: 50, height:32)
                    nameOfOrder.frame = CGRect(x: 30, y: 3, width: 10+orderView.frame.width-priceOfOrder.frame.width, height:32)
                    priceOfOrder.baselineAdjustment = .alignCenters
                    priceOfOrder.numberOfLines = 0
                    priceOfOrder.textAlignment = .right
                    nameOfOrder.baselineAdjustment = .alignCenters
                    nameOfOrder.numberOfLines = 0
                    
                    orderView.center.x = cell.contentView.center.x
                    orderView.frame.origin = CGPoint(x: 5, y: i*25)
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
            return cell
        }
        ordersTableView.reloadData()
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 2 {
            let order = finalSecondOrdersList[indexPath.row]
            return CGFloat((order.orderName.count * 20) + 45)
        }else{
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            reference = times[indexPath.row]
            getOrdersOfSomeDate(reference: reference)
        }
    }
    
    func getOrdersOfSomeDate(reference: String) {
        noOrdersView.alpha = 0
        finalSecondOrdersList.removeAll()
        if self.view.frame.height < 600 {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 18)
        } else {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        }
        if reference != "" {
            for i in secondOrdersList {
                if reference == i.orderTime {
                    finalSecondOrdersList.append(i)
                    noOrdersView.alpha = 0
                } else if i.orderDate != reference {
                    noOrdersView.alpha = 1
                }
            }
            ordersTableView.reloadData()
        }
    }
    
    
    func getOrdersOfSomeDateTime(reference: String) {
        noOrdersView.alpha = 0
        if self.view.frame.height < 600 {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 18)
        } else {
            noOrdersLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        }
        times.removeAll()
        if reference != "" {
            for i in secondOrdersList {
                if reference == i.orderDate {
                    times.append(i.orderTime)
                    noOrdersView.alpha = 0
                } else if i.orderDate != reference {
                    noOrdersView.alpha = 1
                }
            }
            timesTableView.reloadData()
        }
    }
    
    func getOrdersCalendar() {
        APIManager.sharedInstance.orderSearchActivitiesInCalendar(from: "2017-07-01", till: "2017-08-01") { (json) in
            for data in json.array! {
                var order: OrderAdminCalendar = OrderAdminCalendar()
                var placeId = Int()
                var dateOfOrder = String()
                var date = String()
                var time = String()
                
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
                    }
                }
                for feature in data["features"].array! {
                    order.orderName.append(feature["feature"]["name"].string!)
                    order.orderPrice.append(String(feature["price"].int!))
                    order.orderType.append(feature["feature"]["id"].int!)
                }
                
                let userName = data["owner"]["name"].string!
                let userPhone = data["owner"]["phone"].string!
                
                self.times.append(time)
                self.secondOrdersList.append(OrderAdminCalendar(orderDate: date, orderType: order.orderType, orderName: order.orderName, orderPrice: order.orderPrice, orderTime: time, userName: userName, userPhone: userPhone))
            }
            OperationQueue.main.addOperation {
                self.timesTableView.reloadData()
                self.ordersTableView.reloadData()
                self.getOrdersOfSomeDateTime(reference: self.todayStr)
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
        }
    }
}

extension AdminCalendarSecondPageVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2018 02 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}


extension AdminCalendarSecondPageVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! AdminCalendar
        cell.dayLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = Calendar.current.timeZone
        simpleDay = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEEE"
        simpleDayOfWeek = dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date!)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date!)
    }
}
