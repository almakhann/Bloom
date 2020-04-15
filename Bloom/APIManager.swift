//
//  APIManager.swift
//  Bloom
//
//  Created by Жарас on 10.06.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import SwiftyJSON
import Alamofire

private let baseURL = "http://bloomserver.northeurope.cloudapp.azure.com/api/"
private var stripeURL = "https://api.stripe.com/v1/charges"

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    var requestTypeList = 0
    enum BackendError: Error {
        case objectSerialization(reason: String)
    }
    
    
    // MARK: REGISTRATION REQUESTS ##################################################################
    
    func  authRegistrationOfUserAndAdmin(name: String, surname: String, phone: String, password: String, city: String, address: String, type: Int, locationX: Double, locationY: Double, onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "auth/register/"
        
        var parameters: Dictionary<String, Any> = [
            "name": name,
            "phone": phone,
            "password": password,
            "city": "\(city)",
            "type": "\(type)",
            "address": "\(address)",
            "location_x": locationX,
            "location_y": locationY
        ]
        
        if type != 1{
            parameters["surname"] = surname
        }
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }

    
    func authGetSMSCode(phone: String, onSuccess: @escaping(JSON) -> Void){
        
        let parameters: Dictionary<String, Any> = ["phone":phone]
        let endPoint = "auth/register_send_code/"
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func authCheckIfSMSCodeIsCorrect(phone: String, code: String, requestSent: @escaping(Int) -> Void){
        let parameters: Dictionary<String, Any> = ["phone": phone, "code": code]
        let endPoint = "auth/register_check_code/"
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: {_ in},
                     onFailure: {_ in})
    }
    
    
    func authLoginOfAdminAndUser(phone: String,password: String, onSuccess: @escaping(JSON) -> Void){
        
        let parameters: Dictionary<String, Any> = ["phone":phone,"password":password]
        let endPoint = "auth/login/"

        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func authGetUserByID(userID: Int, onSuccess: @escaping(JSON) -> Void){
        
        let endPoint = "auth/\(userID)/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func authChangeUser(userID: Int, parameters: Dictionary<String,Any>, onSuccess: @escaping(JSON) -> Void){
        
        let endPoint = "auth/\(userID)/"
        
        let method = HTTPMethod.patch
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    

    func authChangePassword(currentPassword: String,newPassword: String, requestSent: @escaping(Int) -> Void){
        
        let parameters: Dictionary<String, Any> = ["password":newPassword,"password_old":currentPassword]
        
        let endPoint = "auth/password_change/"
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: {_ in},
                     onFailure: {_ in})
    }
    
    func authGetMeByToken(onSuccess: @escaping(JSON) -> Void){
        
        let endPoint = "auth/get_me/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func authCheckIfPhoneIsExist(phone:String, requestSent: @escaping(Int) -> Void){
        
        let endPoint = "auth/check_phone/"
        
        let parameters: Dictionary<String, Any> = ["phone":phone]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: {_ in},
                     onFailure: {_ in})
    }
    
    func authCheckIfEmailIsExist(email: String, onSuccess: @escaping(JSON) -> Void){
        let endPoint = "auth/check_email/"
        
        let parameters: Dictionary<String, Any> = ["email":email]
        
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func authForgotPasswordSendSMSCode(phone: String, onSuccess: @escaping(JSON) -> Void){
        let parameters: Dictionary<String, Any> = ["phone":phone]
        let endPoint = "auth/send_code/"
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func authForgotPasswordCheckSMSCode(phone: String, code: String, onSuccess: @escaping(JSON) -> Void){
        let parameters: Dictionary<String, Any> = ["phone": phone, "code": code]
        let endPoint = "auth/check_code/"
    
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }

    func authForgotPasswordSetNewPassword(phone: String, code: String,password: String, onSuccess: @escaping(JSON) -> Void){
        let parameters: Dictionary<String, Any> = ["phone": phone, "code": code,"password": password]
        let endPoint = "auth/forget_password/"

        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    // MARK: FAQ REQUESTS ########################################################################
    
    
    func faqGetQuestionsAndAnswers(type: Int, onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "faq/?type=\(type)"
        
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    
    // MARK: CHAT REQUESTS ##########################################################################
    
    func chatCreateDialog(partnerID: Int, onSuccess: @escaping(JSON) -> Void){
        let parameters: Dictionary<String, Any> = ["receiver": partnerID]
        let endPoint = "dialog/"
    
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func chatGetAllDialogs(onSuccess: @escaping(JSON) -> Void, requestSent: @escaping(Int) -> Void) {
        let endPoint = "dialog/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: requestSent,
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func chatGetMessagesOfDialog(dialog_id: Int, lastMessageID: Int,onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "message/?dialog=\(dialog_id)&end=\(lastMessageID)"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func chatSendImageMessage(dialog_id: Int,type: Int,context: String,image: UIImage,onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "message/"
        let param: Dictionary<String,Any> = [
            "type": "\(type)",
            "dialog": "\(dialog_id)"
        ]
        
        self.multipartRequestOnAPI(parameters: param, image: image, endPoint: endPoint, onSuccess:  { json in
            onSuccess(json)
        })
        
    }
    
    func chatGetDialogByID(dialog_id: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "dialog/\(dialog_id)/"

        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func getMediaOfSalon(onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "image/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
 // MARK: FEATURE REQUESTS ########################################################################
    
    func getFeature(onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "feature/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func getFeatureByID(featureID: Int,onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "feature/\(featureID)"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
 // MARK: ORDERS REQUESTS ########################################################################   
    
    
    func orderCreateOrder(parameters: Dictionary<String, Any>, onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "orders_user/"
        
        requestTypeList = 1
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func orderGetOrders(onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_place/"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func orderAcceptOrderOfUser(responseID: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_place/accept/"
        
        let parameters: Dictionary<String,Any> = [
            "response": responseID
        ]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func orderGetMyOrders(activeStatus: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_user?status=\(activeStatus)"
        
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func orderAcceptResponseOfAdmin(requestID: Int,salonID: Int, onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "orders_user/acception/"
        
        let parameters: Dictionary<String,Any> = [
            "owner": salonID,
            "request_id": requestID
        ]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func orderSearchActivitiesInCalendar(from: String,till: String, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_user/find_by_calendar/"
        
        let parameters: Dictionary<String,Any> = [
            "date_start": from,
            "date_end": till
        ]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    func orderDeleteCreatedOrderUser(requestID: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_user/\(requestID)/"
        
        let method = HTTPMethod.delete
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func orderDeleteResponsedOrderAdmin(responseID: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "orders_place/\(responseID)/"
        
        let method = HTTPMethod.delete
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func orderChangePrice(featureID: Int, newPrice: Int, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "order_feature/\(featureID)/"
        
        let parameters: Dictionary<String,Any> = [
            "price": newPrice
        ]
        
        let method = HTTPMethod.patch
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    

 // MARK: PLACE REQUESTS ########################################################################

    func placeGetByID(placeID: Int,onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "place/\(placeID)/"
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func placeUploadPhotos(type: Int, placeID: Int,comment: String,images: [UIImage], onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "image/"
        
        for i in 0..<images.count{
            let parameters: Dictionary<String, Any> = [
                "type": "\(type)",
                "place": "\(placeID)",
                "comment": comment
            ]
            multipartRequestOnAPI(parameters: parameters, image: images[i], endPoint: endPoint, onSuccess: {(json) in
                onSuccess(json)})
        }
        
    }
    
    
    func placeChangeInformation(placeID: Int, parameters: Dictionary<String,Any>, onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "place/\(placeID)/"
        if parameters.keys.contains("feature"){
            requestTypeList = 1
        }
        let method = HTTPMethod.patch
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    func placeGetPhotoByID(photoID: Int,onSuccess: @escaping(JSON) -> Void) {
        var endPoint = "image/"
        if photoID >= 0{
            endPoint = "image/\(photoID)"
        }
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    func deletePhotoByID(photoID: Int,onSuccess: @escaping(JSON) -> Void) {
        let endPoint = "image/\(photoID)/"
        let method = HTTPMethod.delete
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
    }
    
    
    
    
    
    
 // MARK: PAYMENT REQUESTS ########################################################################
    
    func paymentGetBalance(onSuccess: @escaping(JSON) -> Void) {
        
        let endPoint = "payment/"
        let method = HTTPMethod.get
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: [:],
                     requestSent: {_ in},
                     onSuccess: onSuccess,
                     onFailure: {_ in})
        
    }
    
    
    func paymentConnectStripeCustomerIDToCurrentUser(customerID: String,requestSent: @escaping(Int) -> Void) {
        
        let endPoint = "payment/attach_customer/"
        
        let parameters: Dictionary<String,Any> = ["customer_id":customerID]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: {_ in},
                     onFailure: {_ in})
        
    }
    
    func paymentDecreaseAmount(amount: Int, requestSent: @escaping(Int) -> Void) {
        
        let endPoint = "payment/decrease/"
        
        let parameters: Dictionary<String,Any> = ["amount":amount]
        
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: {_ in},
                     onFailure: {_ in})
        
    }
    
    func makePayment(parameters: Dictionary<String, Any>, requestSent: @escaping(Int) -> Void, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let endPoint = "payment_history/"
        let method = HTTPMethod.post
        requestOnAPI(endPoint: endPoint,
                     method: method,
                     parameters: parameters,
                     requestSent: requestSent,
                     onSuccess: onSuccess,
                     onFailure: onFailure)
        
    }
    
    func requestOnAPI(endPoint: String, method: HTTPMethod, parameters: Dictionary<String, Any>, requestSent: @escaping(Int) -> Void,
                      onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        var headers: HTTPHeaders = [:]
        let token = UserModel.info().getToken()
        if !token.isEmpty{
            headers = ["Authorization":"Token \(token)"]
//            headers = ["Authorization":"Token e52761460c625725ffb28bc88bef6ccc6a9a1ecc"]
        }
    
        if Animations.sharedInstance.isConnectedToNetwork(){
            if requestTypeList == 1{
                Alamofire.request("\(baseURL)\(endPoint)", method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in                print("------------------------------------------------------")
                    print("url: \(baseURL)\(endPoint), params: \(parameters)")
                    
                    
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        requestSent(statusCode)
                    }
                    
                    if response.result.error != nil{
                        print(response.result.error!)
                        onFailure(response.result.error!)
                    }
                    
                    if let object = response.result.value{
                        let json = JSON(object)
                        //print(json)
                        onSuccess(json)
                    }
                }
                requestTypeList = 0
            }else{
                Alamofire.request("\(baseURL)\(endPoint)", method: method, parameters: parameters, headers: headers).responseJSON { response in                print("------------------------------------------------------")
                    print("url: \(baseURL)\(endPoint), params: \(parameters)")
                    
                    
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        requestSent(statusCode)
                    }
                    
                    if response.result.error != nil{
                        print(response.result.error!)
                        onFailure(response.result.error!)
                    }
                    
                    if let object = response.result.value{
                        let json = JSON(object)
                        onSuccess(json)
                    }
                }
                
            }
        }else{
            print("Проверьте подключен ли интернет")
        }
        
    }
    
    func requestOnStripeAPI(method: HTTPMethod, parameters: Dictionary<String, Any>, requestSent: @escaping(Int) -> Void, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        
        
        let headers: HTTPHeaders = ["Authorization": "Bearer sk_test_IqMZP2B2BBFoFHZwXia4NRHY"]
        
        Alamofire.request("\(stripeURL)", method: method, parameters: parameters, headers: headers)
            .responseJSON { response in
                
                print("------------------------------------------------------")
                print("url: \(stripeURL), params: \(parameters)")
                
                if let statusCode = response.response?.statusCode {
                    requestSent(statusCode)
                }
                
                if response.result.error != nil{
                    print(response.result.error!)
                    onFailure(response.result.error!)
                }
                
                
                if let object = response.result.value{
                    let json = JSON(object)
                    onSuccess(json)
                }
        }
    }
    
    func multipartRequestOnAPI(parameters: Dictionary<String,Any>, image: UIImage, endPoint: String, onSuccess: @escaping(JSON) -> Void) {
        
        let URL = baseURL+endPoint
        
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key,value) in parameters{
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            
        }, to: URL,
           method: .post,
           headers: ["Authorization":"Token \(UserModel.info().getToken())"],
           encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let object = response.result.value{
                        let json = JSON(object)
                        onSuccess(json)
                        return
                    }

                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }

}
