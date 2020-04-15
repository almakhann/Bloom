
import UIKit
import Security
import KeychainSwift


class Feature: NSObject {
    var name: String
    let id: Int
    var children: [Child] = []
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}
class Child: NSObject {
    var name: String
    var id: Int
    var children: [SubChild] = []
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}
class SubChild: NSObject {
    var name: String
    let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}



class UserModel {
    
    let keychain = KeychainSwift()
    
    private static var sharedInstance: UserModel = {
        let userModel = UserModel(type: 0, name: "", surname: "", id:  0, token: "", phone: "" , code: "" , password: "", forget: 0, salonType: [Int](), images: [UIImage](), city: "", address: "", location_x: Double(), location_y: Double(),  selectedFeatures: [Int](), description: "", typeOfPage: false)
        
        return userModel
    }()
 
    var type: Int
    var name: String
    var surname: String
    var id: Int
    var placeId: Int = Int()
    var phone: String
    var code: String
    var password: String
    var forget: Int
    var token: String = String()
    var salonType = [Int]()
    var images = [UIImage]()
    var city: String
    var address: String
    var locationX: Double
    var locationY: Double
    var selectedFeatures: [Int] = []
    var description: String
    var typeOfPage: Bool
    
    
    
    // Initialization
    private init(type: Int, name: String,  surname: String, id: Int, token: String,  phone: String, code: String, password: String, forget: Int, salonType: [Int], images: [UIImage], city: String, address: String, location_x: Double, location_y: Double, selectedFeatures: [Int], description: String, typeOfPage: Bool) {
        self.type = type
        self.name = name
        self.surname = surname
        self.id = id
        self.phone = phone
        self.code = code
        self.password = password
        self.forget = forget
        self.token = token
        self.salonType = salonType
        self.images = images
        self.city = city
        self.address = address
        self.locationX = location_x
        self.locationY = location_y
        self.selectedFeatures = selectedFeatures
        self.description = description
        self.typeOfPage = typeOfPage
    }
    

    
    func saveToken(token: String){
        keychain.set(token, forKey: "token")
    }
    
    func getToken() -> String{
        var keychain = String()
        if let token = self.keychain.get("token"){
            keychain = token
        }
        return keychain
    }
    
    func saveUser(userDictionary:Dictionary<String, Any>) {
        saveUserDict(dict: userDictionary)
    }
    
    func saveUserDict(dict: Dictionary<String, Any>) {
        UserDefaults.standard.set(dict, forKey: "user")
    }
    func saveFeature(dict: Dictionary<String, Any>){
        UserDefaults.standard.set(dict, forKey: "feature")
    }
    func saveAddress(dict: Dictionary<String, Any>){
        UserDefaults.standard.set(dict, forKey: "address")
    }
    func saveFeedbacks(dict: Dictionary<String, Any>){
        UserDefaults.standard.set(dict, forKey: "feedback")
    }
    
    func removeUserDefault() {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "feature")
        UserDefaults.standard.removeObject(forKey: "address")
        UserDefaults.standard.removeObject(forKey: "feedback")
        keychain.delete("token")
    }
    
    var empty = [String: Any]()
    func getDataFromUserDefault() -> [String: Any] {
        let retrieveDict = UserDefaults.standard.dictionary(forKey:"user")
        if(retrieveDict != nil){
            return retrieveDict!
        }
        else{
            return empty
        }
    }
    func getFeature() -> [String: Any] {
        let retrieveDict = UserDefaults.standard.dictionary(forKey: "feature")
        if(retrieveDict != nil){
            return retrieveDict!
        }
        else{
            return empty
        }
    }
    func getAddress() -> [String: Any] {
        let retrieveDict = UserDefaults.standard.dictionary(forKey:"address")
        if(retrieveDict != nil){
            return retrieveDict!
        }
        else{
            return empty
        }
    }
    func getFeedbacks() -> [String: Any] {
        let retrieveDict = UserDefaults.standard.dictionary(forKey:"feedback")
        if(retrieveDict != nil){
            return retrieveDict!
        }
        else{
            return empty
        }
    }
    
    
    
    func checkUserLoggedIn() -> Bool {
        if(getDataFromUserDefault().isEmpty){
            return false
        }
        else{
            return true
        }
    }
    
    var parent = [Feature]()
    var children = [Child]()
    var childrenTypes = [Int]()
    
    var calendarFeature = [Service]()
    var calendarID = Int()
    var adminOrderIndexID = Int()
    
    class func info() -> UserModel {
        return sharedInstance
    }
    
}
