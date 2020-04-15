//
//  Animations.swift
//  Bloom
//
//  Created by Жарас on 16.06.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import UIKit

class Animations: NSObject {
    static let sharedInstance = Animations()
    
    
    func setTabBarVisible(target: UIViewController, visible:Bool, animated:Bool) {
        if (tabBarIsVisible(target: target) == visible) { return }
        
        let frame = target.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                target.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    
    func tabBarIsVisible(target: UIViewController) ->Bool {
        return (target.tabBarController?.tabBar.frame.origin.y)! < UIScreen.main.bounds.height
    }
    
    
    func setSettingsOfNavigationController(target: UIViewController){
        target.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1)
        target.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Comfortaa-Bold", size: 18)!, NSForegroundColorAttributeName:UIColor.white]
    }
    
    
    
}
