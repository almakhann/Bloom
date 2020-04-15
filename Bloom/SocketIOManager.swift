//
//  ChatMessengerClient.swift
//  Bloom
//
//  Created by Жарас on 01.07.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import SocketIO
import UserNotifications


class SocketIOManager: NSObject{
    static let sharedInstance = SocketIOManager()
    let token = UserModel.info().getToken()
    
    var socket: SocketIOClient!
    let URLaddress: String = "http://bloomserver.northeurope.cloudapp.azure.com:4000"
    
    override init() {
        super.init()
    }
    
    func startSocketConnection(){
        if !token.isEmpty{
            socket = SocketIOClient(socketURL: NSURL(string: URLaddress)!, config: [
                "reconnects": true,
                "reconnectAttempts": 1,
                "reconnectWait": 1,
                "connectParams": ["token":token]])
            socket.connect()
            
            socket.on("Message.New") {data, ack in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageCreated"), object: nil, userInfo: data[0]  as! Dictionary<String, Any>)
                self.sendNotification(title: "Bloom", body: "Новое сообщение", identifier: "gotMessage")
            }
            
            socket.on("PlaceOrder.Submitted") {data, ack in
                if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                    print(name,typeDict)
                }
            }
            
            socket.on("Feedback.Notified") { data, ack in
                if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                    print(name,typeDict)
                }
            }
            socket.on("Feedback.Notified") { data, ack in
                if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                    print(name,typeDict)
                }
            }
            socket.on("Price.Changed") { data, ack in
                if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                    print(name,typeDict)
                }
            }
            
            socket.on("Price.Changed") { data, ack in
                if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                    print(name,typeDict)
                }
            }
            
            socket.on("Message.Sent") { data, ack in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ownMessage"), object: nil, userInfo: data[0]  as! Dictionary<String, Any>)
            }
        }else{
            return
        }
    }
    
    func sendNotification(title: String, body: String, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func closeConnection() {
        if socket != nil{
            socket.disconnect()
        }
    }
    
    
    func sendMessage(type: Int, dialogId: Int, context: String){
        socket.emit("message", [
            "type":type,
            "dialog":dialogId,
            "context": context
            ])
    }
    
}
