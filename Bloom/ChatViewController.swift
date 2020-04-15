//
//  ChatViewController.swift
//  Bloom
//
//  Created by Жарас on 25.04.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

class ChatViewController: UIViewController, WebSocketDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableOfDialogs: UITableView!
    var isUser: Bool = true
    var data: ChatData = ChatData()
    var socket: WebSocket!
    override func viewDidLoad() {
        getDialogs()
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMessage(_:)), name: NSNotification.Name(rawValue: "ownMessage"), object: nil)
        connectToServer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDialogs(){
        APIManager.sharedInstance.chatGetAllDialogs(onSuccess: {(json) in
            print(json)
            if json.count != 0{
                    for dialog in json.array!{
                        if dialog["creator"]["id"].int! == 3{
                            self.isUser = true
                        }else if dialog["receiver"]["id"].int! == 3{
                            self.isUser = false
                        }
                        let _dialog = chatDialog(dialog["id"].int!,dialog["creator"]["id"].int!,dialog["receiver"]["id"].int!,dialog["created_at"].string!)
                        //Data for USER ------------------------------------
                        if self.isUser{
                            if let name = dialog["receiver"]["name"].string{ _dialog.partner_name = name }
                            if let surname = dialog["receiver"]["surname"].string{ _dialog.partner_surname = surname }
                        }else{
                            if let name = dialog["creator"]["name"].string{ _dialog.partner_name = name }
                            if let surname = dialog["creator"]["surname"].string{ _dialog.partner_surname = surname }
                        }
                        
                        
                        //---------------------------------------------
                        APIManager.sharedInstance.chatGetMessagesOfDialog(dialog_id: _dialog.id,onSuccess: { (json) in
                            if json.count != 0{
                                var arrayOfMessages: [chatMessage] = Array()
                                DispatchQueue.global().sync {
                                    for message in json.array!{
                                            let _message = chatMessage(message["id"].int!,message["dialog"]["id"].int!,message["type"].int!,message["context"].string!,message["sent_at"].string!,message["sender"]["id"].int!)
                                            if let image = message["image"].string{
                                                _message.image = "http://backend518.cloudapp.net:1010/media/"+image
                                            }
                                            arrayOfMessages.append(_message)
                                    }
                                    //arrayOfMessages.append(getMessage)
                                }
                                self.data.listOfMessages.append(arrayOfMessages)
                            }
                            
                            DispatchQueue.global().sync {
                                var text = String()
                                if self.data.listOfMessages.last?.last?.type == 1{
                                    text = (self.data.listOfMessages.last?.last?.image.components(separatedBy: "/").last!)!
                                }else{
                                    text = (self.data.listOfMessages.last?.last?.context)!
                                }
                                let time = (self.data.listOfMessages.last?.last?.sended_at)!
                                self.data.setContentOfDialog(_dialog, text, time)
                                
                            }
                            DispatchQueue.global().sync {
                                self.tableOfDialogs.reloadData()
                            }
                            

                        })
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.listOfDialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOfDialogs.dequeueReusableCell(withIdentifier: "cell") as! cellOfDialog
        cell.nameOfPartner.text = String(data.listOfDialogs[indexPath.row].partner_name + " " + data.listOfDialogs[indexPath.row].partner_surname)
        cell.lastMessage.text = data.listOfDialogs[indexPath.row].lastMessage
        cell.setTimeOfLastSended(UTCtime: data.listOfDialogs[indexPath.row].lastTime)
        
        return cell
    }
    
    @IBAction func goBackToDialog(segue:UIStoryboardSegue) {
    }
    
    func connectToServer(){
        let baseURL = "ws://backend518.cloudapp.net:1010/api/stream/?token="
        //let token = UserDefaults.standard.value(forKey: "token") as! String
        let token = "7f64e4bae28a530c22c58997f0ca4c7ea721231f"
        socket = WebSocket(url: URL(string: baseURL + token)!)
        
        self.socket.delegate = self
        self.socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Aaaaaaaaadaaaaaaaaaaaaa")
        
        if let dataFromString = text.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            let json = JSON(data: dataFromString)
            let event = json["event"].string!
            //let status = json["status"].string!
            let dataFromJson = json["data"].dictionaryObject
            if(event == "Message.Created") {
                let messageData = (dataFromJson?["message"] as! Dictionary<String, Any>)
                let dialog_id = messageData["dialog"] as! Int
                
                data.listOfMessages[data.getIndex(dialog_id: dialog_id)].append(chatMessage(messageData["id"] as! Int,dialog_id,messageData["type"] as! Int,messageData["context"] as! String,messageData["sent_at"] as! String,messageData["sender"] as! Int))
                if messageData["type"] as! Int == 1 {
                    data.listOfMessages[data.getIndex(dialog_id: dialog_id)].last?.image = (messageData["image"] as! String)
                    let name = (messageData["image"] as! String).components(separatedBy: "/").last
                    data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),name!,messageData["sent_at"] as! String)
                }else{
                    data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),messageData["context"] as! String,messageData["sent_at"] as! String)
                }
                tableOfDialogs.reloadData()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageCreated"), object: nil, userInfo: messageData)
                
            }else if(event == "Connection.Pending"){
                print("got some text: ","On First Connect",text)
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
    func getMessage(_ notification: NSNotification) {
        let message = notification.userInfo as! Dictionary<String, Any>
        if let type = message["type"] as? Int {
            let dialog_id = message["dialog"] as! Int
            data.listOfMessages[data.getIndex(dialog_id: dialog_id)].append(chatMessage(message["id"] as! Int,dialog_id,type,message["context"] as! String,message["sent_at"] as! String,message["sender"] as! Int))
            if type == 1 {
                data.listOfMessages[data.getIndex(dialog_id: dialog_id)].last?.image = (message["image"] as! String)
                let name = (message["image"] as! String).components(separatedBy: "/").last
                data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),name!,message["sent_at"] as! String)
            }else{
                data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),message["context"] as! String,message["sent_at"] as! String)
            }
            tableOfDialogs.reloadData()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat"{
            let navVc = segue.destination as! UINavigationController
            let destination = navVc.viewControllers.first as! ChattingViewController
            //let destination = navVc.viewControllers.first as! ChattingViewController
            destination.msgs = data.getListOfDialogMessages(dialog_id: data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].id)
            destination.dialog_ID = data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].id
            destination.user_partner.name = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner_name) + " " + String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner_surname)
            destination.dialogProtocol = self
            destination.selectedIndex = self.tableOfDialogs.indexPathForSelectedRow?.row
            if isUser{
                destination.user_me.id = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].creator)
                destination.user_partner.id = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner)
            }else{
                destination.user_me.id = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner)
                destination.user_partner.id = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].creator)
            }
        }
    }
    
}
