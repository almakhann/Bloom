//
//  ChatViewController.swift
//  Bloom
//
//  Created by Жарас on 25.04.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO
import UserNotifications

class ChatPartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelOfEmptyChatDialog: UILabel!
    @IBOutlet weak var tableOfDialogs: UITableView!
    var requestStatus: Int!
    var isUser: Bool = Bool()
    var data: ChatData = ChatData()
    var myId: Int = 0
    var unReadDialogs: [Int] = []
    
    
    override func viewDidLoad() {
        getDialogs()
        getUnreadListOfDialogs()
        super.viewDidLoad()
        
        addObserverOfSockets()
        
        if let id = UserModel.info().getDataFromUserDefault()["id"] as? Int{
            self.myId = id
        }
        
        Animations.sharedInstance.showIndicator(viewController: self)
        
        self.tableOfDialogs.tableFooterView = UIView(frame: CGRect.zero)
        
        let button = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = button
        
        Animations.sharedInstance.setSettingsOfNavigationController(target: self)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addObserverOfSockets(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMessage(_:)), name: NSNotification.Name(rawValue: "messageCreated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMessage(_:)), name: NSNotification.Name(rawValue: "ownMessage"), object: nil)
    }
    
    @IBAction func showAlertOfServices(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "ChatPart", bundle: nil).instantiateViewController(withIdentifier: "servicesAlert") as! PopUpServicesViewController
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableOfDialogs)
        if let indexPath = self.tableOfDialogs.indexPathForRow(at: buttonPosition){
            let services = data.listOfDialogs[indexPath.row].services
            popOverVC.setService(servicesOfDialog: services)
        }
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    
    
    func getDialogs(){
        var count = 0
        APIManager.sharedInstance.chatGetAllDialogs(onSuccess: {(json) in
            if self.requestStatus == 200{
                if json.count != 0{
                    if let dialogsCount = json.array?.count{
                        for dialog in json.array!{
                            let _dialog = self.data.unPackDialogJSON(viewController: self, dialog: dialog)
                            if let lastMessageID = dialog["last_message"]["id"].int{
                                APIManager.sharedInstance.chatGetMessagesOfDialog(dialog_id: _dialog.id, lastMessageID: lastMessageID,onSuccess: { (json) in
                                    count+=1
                                    if json.count != 0{
                                        var arrayOfMessages: [chatMessage] = Array()
                                        for message in json.array!{
                                            let _message = chatMessage(message["id"].int!,_dialog.id,message["type"].int!,message["context"].string!,message["sent_at"].string!,message["sender"]["id"].int!)
                                            if let image = message["image"].string{
                                                _message.image = "http://bloomserver.northeurope.cloudapp.azure.com/media/"+image
                                                
                                            }
                                            arrayOfMessages.append(_message)
                                        }
                                        self.data.listOfMessages.append(arrayOfMessages)
                                    }
                                    self.data.listOfDialogs.append(_dialog)
                                    self.tableOfDialogs.reloadData()
                                    
                                    
                                    if count == dialogsCount{
                                        if dialogsCount != 0{
                                            self.labelOfEmptyChatDialog.isHidden = true
                                        }
                                        Animations.sharedInstance.hideIndicator(viewController: self)
                                    }
                                    
                                })
                            }
                        }
                    }
                }else{
                    self.labelOfEmptyChatDialog.isHidden = false
                    Animations.sharedInstance.hideIndicator(viewController: self)
                }
            }
        }, requestSent: {(status) in self.requestStatus = status})
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.listOfDialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOfDialogs.dequeueReusableCell(withIdentifier: "dialog") as! cellOfDialog
        
        let dialog = data.listOfDialogs[indexPath.row]
        
        cell.nameOfPartner.text = String(dialog.partner_name + " " + dialog.partner_surname)
        
        
        let services = dialog.services
        cell.buttonOfServices.isEnabled = true
        
        if services.count > 0{
            cell.buttonOfServices.setTitle("\(services.count) услуги", for: .normal)
        }else{
            cell.buttonOfServices.setTitle("Нет услуги", for: .normal)
            cell.buttonOfServices.isEnabled = false
        }
        
        if let lastSendedTime = dialog.lastTime{
            cell.setTimeOfLastSended(UTCtime: lastSendedTime)
        }
        
        cell.lastMessage.text = dialog.lastMessage
        cell.lastMessage.textColor = #colorLiteral(red: 0.5607843137, green: 0.5568627451, blue: 0.5803921569, alpha: 1)
        cell.lastTime.isHidden = false
        
        if unReadDialogs.contains(dialog.id){
            if indexPath.row == data.getIndex(dialog_id: dialog.id)!{
                cell.lastMessage.text = "У вас новое сообщение"
                cell.lastMessage.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                cell.lastTime.isHidden = true
            }
        }
        
        
        return cell
    }
    
    
    func getMessage(_ notification: NSNotification) {
        let message = notification.userInfo as! Dictionary<String, Any>
        let sender = message["sender"] as! Dictionary<String, Any>
        
        if let type = message["type"] as? Int {
            
            let message_id = message["id"] as! Int
            let dialog_id = message["dialog"] as! Int
            let messageContext = message["context"] as! String
            let messageSendedTime = message["sent_at"] as! String
            let messageSenderId = sender["id"] as! Int
            
            if let index = data.getIndex(dialog_id: dialog_id){
                data.listOfMessages[index].append(chatMessage(message_id,dialog_id,type,messageContext,messageSendedTime,messageSenderId))
                
                if type == 1 {
                    data.listOfMessages[index].last?.image = (message["image"] as! String)
                    data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),"Photo",messageSendedTime)
                }else{
                    data.setContentOfDialog(data.getDialog(dialog_id: dialog_id),messageContext,messageSendedTime)
                }
                
                if index != 0{
                    self.tableOfDialogs.beginUpdates()
                    
                    self.tableOfDialogs.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
                    self.data.listOfMessages.insert(self.data.listOfMessages.remove(at: index), at: 0)
                    self.data.listOfDialogs.insert(self.data.listOfDialogs.remove(at: index), at: 0)
                    
                    self.tableOfDialogs.endUpdates()
                    
                }
            }else{
                print("THERE IS NO SUCH DIALOG")
                APIManager.sharedInstance.chatGetDialogByID(dialog_id: dialog_id, onSuccess: {(json) in
                    let _dialog = self.data.unPackDialogJSON(viewController: self, dialog: json)
                    
                    self.data.listOfDialogs.insert(_dialog, at: 0)
                    
                    var arrayOfMessages: [chatMessage] = Array()
                    
                    arrayOfMessages.append(chatMessage(message_id,dialog_id,type,messageContext,messageSendedTime,messageSenderId))
                    
                    if type == 1 {
                        arrayOfMessages.last?.image = ("http://bloomserver.northeurope.cloudapp.azure.com/media/"+(message["image"] as! String))
                        self.data.setContentOfDialog(self.data.getDialog(dialog_id: dialog_id),"Photo",messageSendedTime)
                    }else{
                        self.data.setContentOfDialog(self.data.getDialog(dialog_id: dialog_id),messageContext,messageSendedTime)
                    }
                    
                    self.data.listOfMessages.insert(arrayOfMessages, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableOfDialogs.insertRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
                })
            }
            addToUnreadList(dialogId: dialog_id)
            self.labelOfEmptyChatDialog.isHidden = true
            self.tableOfDialogs.reloadRows(at: tableOfDialogs.indexPathsForVisibleRows!, with: .automatic)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat"{
            let destination = segue.destination as! ChattingViewController
            destination.dialogProtocol = self
            
            
            let dialogID = data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].id!
            let partnerName = data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner_name
            //            let partnerSurname = data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner_surname
            let partnerID = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].partner)
            let ownerID = String(data.listOfDialogs[(self.tableOfDialogs.indexPathForSelectedRow?.row)!].creator)
            
            destination.msgs = data.getListOfDialogMessages(dialog_id: dialogID)
            destination.dialogID = dialogID
            destination.userPartner.name = partnerName // + " " + partnerSurname
            destination.selectedIndex = self.tableOfDialogs.indexPathForSelectedRow?.row
            if isUser{
                destination.userMe.id = ownerID
                destination.userPartner.id = partnerID
            }else{
                destination.userMe.id = partnerID
                destination.userPartner.id = ownerID
            }
            
            removeFromUnreadList(dialogId: dialogID)
            
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
    }
    
    
    func getUnreadListOfDialogs(){
        if let list = UserDefaults.standard.object(forKey: "unreadDialog") as? [Int] {
            unReadDialogs = list
        }
    }
    
    func updateUnreadDialogsInUserDefault(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"unreadDialog")
        defaults.set(unReadDialogs, forKey: "unreadDialog")
        defaults.synchronize()
    }
    
    func removeFromUnreadList(dialogId: Int){
        var count = 0
        if unReadDialogs.contains(dialogId){
            for dialog in unReadDialogs{
                if dialog == dialogId{
                    unReadDialogs.remove(at: count)
                    updateUnreadDialogsInUserDefault()
                    tableOfDialogs.reloadData()
                }else{
                    count+=1
                }
            }
        }
    }
    
    func addToUnreadList(dialogId: Int){
        if !unReadDialogs.contains(dialogId){
            if let row = self.tableOfDialogs.indexPathForSelectedRow?.row{
                if data.listOfDialogs[row].id != dialogId{
                    unReadDialogs.append(dialogId)
                    updateUnreadDialogsInUserDefault()
                    tableOfDialogs.reloadData()
                }
            }else{
                unReadDialogs.append(dialogId)
                updateUnreadDialogsInUserDefault()
                tableOfDialogs.reloadData()
            }
        }
    }
    
}
