//
//  chatModel.swift
//  Bloom
//
//  Created by Жарас on 25.04.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatData{
    var indexOfDialog: Int!
    var listOfDialogs: [chatDialog] = Array()
    var listOfMessages = [[chatMessage]]()
    
    
    func setContentOfDialog(_ dialog: chatDialog,_ lastMessage: String,_ lastTime: String){
        dialog.lastMessage = lastMessage
        dialog.lastTime = lastTime
    }
    
    func convertToDate(UTCtime: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: UTCtime)
        return String(describing: date)
    }
    
    func getDialog(dialog_id: Int) -> chatDialog{
        var dialogT: chatDialog!
        var count = 0
        for dialog in listOfDialogs{
            if dialog.id == dialog_id{
                dialogT = dialog
                indexOfDialog = count
            }
            count += 1
        }
        return dialogT
    }
    
    func getIndex(dialog_id: Int) -> Int?{
        var index: Int?
        var count = 0
        for dialog in listOfMessages{
            if dialog.count != 0{
                if dialog[0].chat_id == dialog_id{
                    index = count
                }
            }
            count += 1
        }
        return index
    }
    
    func getListOfDialogMessages(dialog_id: Int) -> [chatMessage]{
        for dialog in listOfMessages{
            if dialog.count != 0{
                if dialog[0].chat_id == dialog_id{
                    return dialog
                }
            }else{
                var count = 0
                for dialog in listOfDialogs{
                    if dialog.id == dialog_id{
                        return listOfMessages[count]
                    }
                    count += 1
                }
            }
            
        }
        return [chatMessage]()
    }
    
    func unPackDialogJSON(viewController: ChatPartViewController, dialog: JSON) -> chatDialog{
        if dialog["creator"]["id"].int! == viewController.myId{
            viewController.isUser = true
        }else if dialog["receiver"]["id"].int! == viewController.myId{
            viewController.isUser = false
        }
        let _dialog = chatDialog(dialog["id"].int!,dialog["creator"]["id"].int!,dialog["receiver"]["id"].int!,dialog["created_at"].string!)
        
        if viewController.isUser{
            if let name = dialog["place"]["name"].string{ _dialog.partner_name = name }
            if let surname = dialog["place"]["surname"].string{ _dialog.partner_surname = surname }
        }else{
            if let name = dialog["creator"]["name"].string{ _dialog.partner_name = name }
            if let surname = dialog["creator"]["surname"].string{ _dialog.partner_surname = surname }
        }
        if let lastMessageType =  dialog["last_message"]["type"].int{
            var text = String()
            if lastMessageType == 1{
                text = "Photo"
            }else{
                text = dialog["last_message"]["context"].string!
            }
            let time = dialog["last_message"]["sent_at"].string!
            self.setContentOfDialog(_dialog, text, time)
        }
        if dialog["features"].count != 0{
            for feature in dialog["features"].array!{
                _dialog.services.append(_Service(nameOfService: feature["feature"]["name"].string!, typeOfService: feature["feature"]["id"].int!))
            }
        }
        return _dialog
        
    }
    
}
class chatDialog{
    var id: Int!
    var partner: Int!
    var partner_name = String()
    var partner_surname = String()
    var creator: Int!
    var currentUser: Int!
    var currentUserName = String()
    var currentuserSurname = String()
    var created_at: String?
    var lastMessage: String?
    var lastTime: String?
    var services: [_Service] = []
    
    
    init(_ chatId: Int,_ owner: Int,_ receiver: Int,_ time: String){
        id = chatId
        creator = owner
        partner = receiver
        created_at = time
    }
    
}

class chatMessage{
    var id: Int!
    var chat_id: Int!
    var type: Int!
    var context = String()
    var image = String()
    var sended_at = String()
    var sender: Int!
    var senderName = String()
    
    init(_ messageId: Int,_ chatId: Int,_ typeOfMessage: Int,_ text: String,_ time: String,_ owner: Int){
        id = messageId
        chat_id = chatId
        type = typeOfMessage
        context = text
        sended_at = time
        sender = owner
    }
}

class _Service{
    var name = String()
    var type = String()
    init(nameOfService: String, typeOfService: Int) {
        name = nameOfService
        type = String(typeOfService)
    }
}
