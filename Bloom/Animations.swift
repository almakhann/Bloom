//
//  Animations.swift
//  Bloom
//
//  Created by Жарас on 16.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import SystemConfiguration

class Animations: NSObject {
    static let sharedInstance = Animations()
    var loaderView: UIView!
    var successView: UIView!
    var tabBar: UITabBarController!
    
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        } ) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func convertDateToDateStringToComment(UTCTime: String) -> String {
        let dateString = UTCTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateObj = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let finalDate  = dateFormatter.string(from: dateObj)
        return String(describing: finalDate)
    }
    
    
    func convertDateToDayOfWeek(UTCTime: String) -> String {
        let dateString = UTCTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "dd MMM"
        let dateObj = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "EEEE"
        let finalDate  = dateFormatter.string(from: dateObj)
        return String(describing: finalDate)
    }
    
    func convertDateToDateString(UTCTime: String) -> String {
        let dateString = UTCTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateObj = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd MMM"
        let finalDate  = dateFormatter.string(from: dateObj)
        return String(describing: finalDate)
    }
    
    func convertDateToTimeString(UTCTime: String) -> String {
        let dateString = UTCTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateObj = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "HH.mm"
        let finalDate  = dateFormatter.string(from: dateObj)
        return String(describing: finalDate)
    }
    
    func convertDateToTitleTimeString(UTCTime: String) -> String {
        let dateString = UTCTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_KZ")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "dd MMM"
        let dateObj = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd MMMM"
        let finalDate  = dateFormatter.string(from: dateObj)
        return String(describing: finalDate)
    }
    
    
    func saveIdOfFeature(id: Int, arrayID: [Int]) -> [Int]{
        var array = arrayID
        if(!array.contains(id)){
            if 0 < id && 14 > id{
                if(!array.contains(1)){
                    array.append(1)
                }
            }
            if 13 < id &&  37 > id{
                if(!arrayID.contains(14)){
                    array.append(14)
                }
            }
            if 36 < id &&  56 > id{
                if(!array.contains(37)){
                    array.append(37)
                }
            }
            if 55 < id{
                if(!array.contains(56)){
                    array.append(56)
                }
            }
        }
        return array
    }


    
    func setTabBarVisible(target: UIViewController, visible:Bool, animated:Bool) {
        if (tabBarIsVisible(target: target) == visible) { return }
        
        let frame = target.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.15 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBar.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    
    func tabBarIsVisible(target: UIViewController) ->Bool {
        return (self.tabBar.tabBar.frame.origin.y) < UIScreen.main.bounds.height
    }
    
    
    
    func setSettingsOfNavigationController(target: UIViewController){
        target.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1)
        target.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Comfortaa-Bold", size: 18)!, NSForegroundColorAttributeName:UIColor.white]
    }
    
    func showIndicator(viewController: UIViewController){
        loaderView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width/2.5), height: Int(UIScreen.main.bounds.height/5.0)))
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = loaderView.center
        activityIndicator.startAnimating()
        viewController.view.isUserInteractionEnabled = false
        loaderView.center = viewController.view.center
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loaderView.layer.cornerRadius = 15
        
        loaderView.addSubview(activityIndicator)
        viewController.view.addSubview(loaderView)
    }
    func hideIndicator(viewController: UIViewController){
        loaderView.removeFromSuperview()
        viewController.view.isUserInteractionEnabled = true
    }
    
    func showSuccessView(viewContoller: UIViewController){
        if successView != nil{
            successView.removeFromSuperview()
        }
        successView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width/2.5), height: Int(UIScreen.main.bounds.height/5.0)))
        successView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        successView.layer.cornerRadius = 15
        
        let successImage = UIImageView()
        successImage.frame.size = CGSize(width: Int(successView.frame.width/3), height: Int(successView.frame.height/3))
        successImage.image = UIImage(named: "check-1")
        successImage.contentMode = .scaleAspectFill
        successImage.center = successView.center
        successView.addSubview(successImage)
        successView.center.x = viewContoller.view.center.x
        successView.center.y = -viewContoller.view.frame.height
        viewContoller.view.addSubview(successView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.successView.center.y = viewContoller.view.center.y - 35
        })
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.animate(withDuration: 0.3, animations: {
                self.successView.center.y = -viewContoller.view.frame.height
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.successView.removeFromSuperview()
                }
            })
        }
    }
    
    func createAndGetTabBar() -> UITabBarController{
        let dict = UserModel.info().getDataFromUserDefault()
        let type = dict["type"] as! Int
        
        
        tabBar = Bundle.main.loadNibNamed("TabBarMenu", owner: self, options: nil)?.first as? UITabBarController
        tabBar?.tabBar.tintColor = #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1)
        
        var calendar = UIViewController()
        let storyboard = UIStoryboard(name: "CalendarPart", bundle: nil)
        if type != 0 {
           calendar = storyboard.instantiateViewController(withIdentifier: "AdminCalendarSecondPageVC") as UIViewController
        }
        else{
            calendar = storyboard.instantiateViewController(withIdentifier: "CalendarPartViewController") as UIViewController
        }
        
//        calendar = storyboard.instantiateViewController(withIdentifier: "AdminCalendarMainPageVC") as UIViewController
        
        calendar.tabBarItem.image = UIImage(named: "calendarMenu")
        calendar.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        
        
        let storyboard1 = UIStoryboard(name: "ChatPart", bundle: nil)
        let chat = storyboard1.instantiateViewController(withIdentifier: "ChatPartViewController") as UIViewController
        //        if let chatController = chat.viewControllers.first as? ChatPartViewController{
        //            chatController.addObserverOfSockets()
        //        }
        
        chat.tabBarItem.image = UIImage(named: "chat")
        chat.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        let storyboard2 = UIStoryboard(name: "FaqPart", bundle: nil)
        let faq = storyboard2.instantiateViewController(withIdentifier: "FaqPartViewController") as UIViewController
        faq.tabBarItem.image = UIImage(named: "faq")
        faq.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        var map = UIViewController()
        let storyboard3 = UIStoryboard(name: "MapPart", bundle: nil)
        if type != 0{
            map = storyboard.instantiateViewController(withIdentifier: "AdminCalendarMainPageVC") as UIViewController
        }
        else{
            map = storyboard3.instantiateViewController(withIdentifier: "MapPartViewController") as UIViewController
        }
        map.tabBarItem.image = UIImage(named: "mainButtonYellow")
        map.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        
        let storyboard4 = UIStoryboard(name: "UserSettingsPart", bundle: nil)
        var userSettings: UIViewController!
        if type == 0{
            userSettings = storyboard4.instantiateViewController(withIdentifier: "UserSettings")
        }else{
            var adminViewController: AdminSettings!
            let adminNavigationController = storyboard4.instantiateViewController(withIdentifier: "AdminSettings") as! UINavigationController
            adminViewController = adminNavigationController.viewControllers.first as! AdminSettings
            if type == 1{
                adminViewController.isFreelancer = false
            }else{
                adminViewController.isFreelancer = true
            }
            userSettings = adminNavigationController
        }
        userSettings.tabBarItem.image = UIImage(named: "userProfile")
        userSettings.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        tabBar?.viewControllers = [userSettings,calendar,map,chat,faq]
        tabBar?.selectedIndex = 2;
        
        return tabBar!
    }
    
    
    
}




extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}


//How to use extension
//let image = UIImage(named: "your_image_name")
//testImage.image =  image?.maskWithColor(color: UIColor.blue)



class ErrorAlertShow: UIViewController {
    
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorMessege: UILabel!
    
    var errorMessageLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.errorView.center.y = -self.view.frame.height
        
        showError(message: errorMessageLabel)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.hideError()
        }
    }
    
    
    func showError(message: String)
    {
        errorMessege.text = message
        UIView.animate(withDuration: 0.3, animations: {
            self.errorView.center.y = self.view.center.y - 35
        });
    }
    
    func hideError()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.errorView.center.y = -self.view.frame.height
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first != nil){
            hideError()
        }
        super.touchesBegan(touches, with: event)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

