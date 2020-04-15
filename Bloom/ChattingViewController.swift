//
//  ChattingViewController.swift
//  Bloom
//
//  Created by Жарас on 27.04.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import SDWebImage
import SwiftyJSON
import Alamofire

struct User{
    var id: String
    var name: String
}

class ChattingViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var msgs = [chatMessage]()
    var userMe = User(id: String(),name: String())
    var userPartner = User(id: String(),name: String())
    var picker = UIImagePickerController()
    var dialogID: Int!
    var selectedIndex: Int!
    var dialogProtocol: ChatPartViewController!
    var startingFrame: CGRect?
    var blackBackgroundScrollView: UIScrollView?
    var startingImageView: UIImageView?
    var idOfLastMessage: Int?
    var zoomingImageView: UIImageView!
    
    var currentUser: User {
        return userMe
    }
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        self.navigationItem.titleView?.tintColor = UIColor.white
        self.navigationItem.title = userPartner.name
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMessage(_:)), name: NSNotification.Name(rawValue: "messageCreated"), object: nil)
        
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Comfortaa-Bold", size: 18)!], for: .normal)
        
        self.topContentAdditionalInset = self.navigationController!.navigationBar.frame.height
        
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        picker.delegate = self
        
        getMessages(msgs)
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "Comfortaa-Regular", size: 14)
        
    }
    
    override func viewDidLayoutSubviews() {
        scrollCollectionToRow(row: messages.count-1)
    }
    
    
    override func willMove(toParentViewController parent: UIViewController?)
    {
        super.willMove(toParentViewController: parent)
        if parent == nil
        {
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && messages.count >= 15{
            getMoreMessages()
        }
    }
    
    
    //STANDARD SETTINGS OF COLLECTION VIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    
    
    //NAME AT THE TOP OF MESSAGE-----------------------------------------------------------
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        var messageUserName = message.senderDisplayName
        if message.senderId == currentUser.id{
            messageUserName = currentUser.name
        }
        
        return NSAttributedString(string: messageUserName!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleOfMessage = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if message.senderId == currentUser.id{
            return bubbleOfMessage?.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.7607843137, green: 0.631372549, blue: 0.3843137255, alpha: 1))
        }else{
            return bubbleOfMessage?.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1))
        }
        
        
    }
    
    //SENDING MESSAGE -----------------------------------------------------------------------------------------
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        sendMessageToBackend(dialogId: dialogID, type: 0, context: text, image: UIImage())
        messages.append(message!)
        finishSendingMessage()
    }
    
    
    
    //SENT_AT TIME OF MESSAGE (AT THE BOTTOM OF MESSAGE)-------------------------------------------------------
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let dateformatter = DateFormatter()
        
        
        if Calendar.current.isDateInToday(message.date){
            dateformatter.dateFormat = "HH:mm"
        }else{
            dateformatter.dateFormat = "MMM d, HH:mm"
        }
        let messageDate = dateformatter.string(from: message.date)
        
        
        return NSAttributedString(string: messageDate)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    
    
    //SENDING IMAGE MESSAGE-----------------------------------------------------------------------------------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let img = JSQPhotoMediaItem(image: pic);
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img))
            sendMessageToBackend(dialogId: dialogID, type: 1, context: String(), image: pic)
        }
        dismiss(animated: true, completion: nil);
        collectionView.reloadData()
    }
    
    
    
    
    //FOLLOWING MESSAGE FROM GALERRY---------------------------------------------------------------------------
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        picker.mediaTypes = [kUTTypeImage as String]
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
    //OPENING SENDED MESSAGE IF TAPPED ------------------------------------------------------------------------
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message:JSQMessage = self.messages[indexPath.row]
        if (message.isMediaMessage) {
            let mediaItem: JSQMessageMediaData = message.media
            if mediaItem.isKind(of: JSQPhotoMediaItem.self){
                let photoItem: JSQPhotoMediaItem = mediaItem as! JSQPhotoMediaItem
                photoItem.mediaView().isUserInteractionEnabled = true
                photoItem.mediaView().addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performImageZoom)))
            }
        }
    }
    
    //ZOOM IMAGE IF TAPPED ------------------------------------------------------------------------
    
    func performImageZoom(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            self.startingImageView = imageView
        }
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView?.superview?.convert(startingImageView!.frame, to: nil)
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView?.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.contentMode = .scaleAspectFit
        zoomingImageView.clipsToBounds = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow{
            blackBackgroundScrollView = UIScrollView(frame: keyWindow.frame)
            blackBackgroundScrollView?.backgroundColor = UIColor.black
            blackBackgroundScrollView?.alpha = 0
            blackBackgroundScrollView?.showsVerticalScrollIndicator = false
            blackBackgroundScrollView?.showsHorizontalScrollIndicator = false
            keyWindow.addSubview(blackBackgroundScrollView!)
            
            blackBackgroundScrollView?.minimumZoomScale=1
            blackBackgroundScrollView?.maximumZoomScale=3
            blackBackgroundScrollView?.bounces = false
            blackBackgroundScrollView?.delegate = self
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundScrollView?.alpha = 1
                self.inputToolbar.alpha = 0
                
                self.zoomingImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                
                self.zoomingImageView.center = keyWindow.center
                
                self.blackBackgroundScrollView?.addSubview(self.zoomingImageView)
                
            }, completion: nil)
            
            
        }
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingImageView
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            self.startingImageView?.isHidden = false
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            zoomOutImageView.frame.size.width = self.startingFrame!.width - 8
            zoomOutImageView.frame.size.height = self.startingFrame!.height
            zoomOutImageView.frame.origin = self.startingFrame!.origin
            self.blackBackgroundScrollView?.alpha = 0
            self.inputToolbar.alpha = 1
            
            zoomOutImageView.removeFromSuperview()
        }
    }
    
    
    func getImage(indexPath: IndexPath) -> UIImage? {
        let message = self.messages[indexPath.row]
        if message.isMediaMessage == true {
            let mediaItem = message.media
            if mediaItem is JSQPhotoMediaItem {
                let photoItem = mediaItem as! JSQPhotoMediaItem
                if let test: UIImage = photoItem.image {
                    let image = test
                    return image
                }
            }
        }
        return nil
    }
    
    
    // GET MESSAGE FROM SOCKET ------------------------------------------------------------------------
    func getMessage(_ notification: NSNotification) {
        let message = notification.userInfo as! Dictionary<String, Any>
        let sender = message["sender"] as! Dictionary<String, Any>
        
        if message["dialog"] as! Int == dialogID{
            if let type = message["type"] as? Int {
                let date = convertToDate(date: message["sent_at"] as! String)
                if type == 0{
                    receiveMessage(sender: String(sender["id"] as! Int), senderName: String(), date: date, text: message["context"] as! String, realtime: true)
                }else{
                    receivePhoto(sender: String(sender["id"] as! Int), senderName: String(), date:  date, photoURL: "http://bloomserver.northeurope.cloudapp.azure.com/media/" + (message["image"] as! String), realtime: true)
                }
                collectionView.reloadData()
                scrollCollectionToRow(row: collectionView(self.collectionView, numberOfItemsInSection: 0) - 1)
            }
        }
    }
    //
    
    //LOAD MESSAGES FROM LIST ------------------------------------------------------------------------
    
    func getMessages(_ listOfMassages: [chatMessage]){
        for massage in listOfMassages.reversed(){
            let date = self.convertToDate(date: massage.sended_at)
            if massage.type == 0{
                self.receiveMessage(sender: String(massage.sender), senderName: massage.senderName, date: date, text: massage.context, realtime: false)
            }else{
                self.receivePhoto(sender: String(massage.sender), senderName: massage.senderName, date: date, photoURL: massage.image, realtime: false)
            }
            self.collectionView.reloadData()
        }
        
    }
    
    //LOAD EARLIER MESSAGES ------------------------------------------------------------------------
    func getMoreMessages(){
        var arrayOfMessages: [chatMessage] = []
        if let lastMessageID = msgs.first?.id{
            if idOfLastMessage == nil || idOfLastMessage != lastMessageID{
                APIManager.sharedInstance.chatGetMessagesOfDialog(dialog_id: dialogID, lastMessageID: lastMessageID,onSuccess: { (json) in
                    if json.count != 0{
                        DispatchQueue.global().sync {
                            for message in json.array!{
                                let _message = chatMessage(message["id"].int!,self.dialogID,message["type"].int!,message["context"].string!,message["sent_at"].string!,message["sender"]["id"].int!)
                                if let image = message["image"].string{
                                    _message.image = "http://bloomserver.northeurope.cloudapp.azure.com/media/"+image
                                }
                                arrayOfMessages.append(_message)
                            }
                        }
                        
                    }
                    DispatchQueue.global().sync {
                        self.getMessages(arrayOfMessages)
                        self.msgs = arrayOfMessages + self.msgs
                        self.scrollCollectionToRow(row: arrayOfMessages.count - 1)
                        self.idOfLastMessage = lastMessageID
                    }
                })
            }
        }
        
    }
    
    func receiveMessage(sender: String,senderName: String,date: Date,text:String, realtime: Bool){
        if realtime{
            messages.append(JSQMessage(senderId: sender,senderDisplayName: senderName, date: date,text: text))
        }else{
            messages.insert(JSQMessage(senderId: sender,senderDisplayName: senderName, date: date,text: text), at: 0)
        }
    }
    func receivePhoto(sender: String, senderName: String, date: Date, photoURL:String, realtime: Bool){
        if photoURL != ""{
            let photo = JSQPhotoMediaItem(image: nil)
            if  sender == self.senderId{
                photo?.appliesMediaViewMaskAsOutgoing = true
            }else{
                photo?.appliesMediaViewMaskAsOutgoing = false
            }
            if let needImage = getImage(name: photoURL.components(separatedBy: "/").last!){
                photo?.image = needImage
            }else{
                DispatchQueue.global().async {
                    if let imageURL = URL(string: photoURL){
                        do{
                            let data = try Data(contentsOf: imageURL)
                            if let _ = UIImage(data: data){
                                DispatchQueue.main.async {
                                    let _ = SDWebImageDownloader.shared().downloadImage(with: imageURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                                        if let data = UIImageJPEGRepresentation(image!, 1) {
                                            let name = photoURL.components(separatedBy: "/")
                                            let filename = self.getDocumentsDirectory().appendingPathComponent(name.last!)
                                            try? data.write(to: filename)
                                        }
                                        photo?.image = image;
                                        self.collectionView.reloadData()
                                    })
                                }
                            }
                        } catch{
                            
                        }
                    }
                }
            }
            if realtime{
                messages.append(JSQMessage(senderId: sender, senderDisplayName: senderName, date: date, media: photo))
            }else{
                messages.insert(JSQMessage(senderId: sender, senderDisplayName: senderName, date: date, media: photo), at: 0)
            }
        }
    }
    
    func sendMessageToBackend(dialogId: Int, type: Int, context: String, image: UIImage){
        var messageData: Dictionary<String,Any> = [:]
        var photoURL = String()
        if type == 1{
            APIManager.sharedInstance.chatSendImageMessage(dialog_id: dialogId, type: type, context: String(), image: image, onSuccess: { (json) in
                messageData = json.dictionaryObject!
                photoURL = messageData["image"] as! String
                if let data = UIImageJPEGRepresentation(image, 1) {
                    let name = photoURL.components(separatedBy: "/")
                    let filename = self.getDocumentsDirectory().appendingPathComponent(name.last!)
                    try? data.write(to: filename)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ownMessage"), object: nil, userInfo: messageData)
            })
        }else{
            SocketIOManager.sharedInstance.sendMessage(type: type, dialogId: dialogId, context: context)
        }
    }
    
    func convertToDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateToReturn = dateFormatter.date(from: date)
        return dateToReturn!
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(name: String) -> UIImage?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: paths).appendingPathComponent(name)
        let image = UIImage(contentsOfFile: url.path)
        return image
    }
    
    func scrollCollectionToRow(row: Int){
        let indexPath: NSIndexPath = NSIndexPath.init(item: row, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: false)
    }
}
