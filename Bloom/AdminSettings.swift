//
//  AdminSettings.swift
//  Bloom
//
//  Created by Serik on 12.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MobileCoreServices
import SDWebImage



class AdminSettings: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet var line1: UIView!
    var line2: UIView = UIView()
    
    
    @IBOutlet weak var numberOfImage: UIButton!
    @IBOutlet weak var collectionOfImages: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    
    var surnameLabel: UILabel = UILabel()
    var surnameTextField: UITextField = UITextField()
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var changePosition: UIButton!
    
    
    @IBOutlet weak var middleStack: UIStackView!
    @IBOutlet weak var bottomStackWithButtons: UIStackView!
    
    @IBOutlet weak var topViewOfDisable: UIView!
    @IBOutlet weak var bottomViewOfDisable: UIView!
    
    @IBOutlet weak var topMarginOfMiddleStack: NSLayoutConstraint!
    @IBOutlet weak var bottomMarginOfBottomStack: NSLayoutConstraint!
    
    @IBOutlet var bottomButtons: [UIButton]!
    
    
    var imagesOfGallery: [UIImage] = []
    var idOfImages: [Int] = []
    var isFreelancer: Bool = true
    var isChecked: Bool = false
    var info = UserModel.info().getDataFromUserDefault()
    
    var name: String!
    var surname: String!
    var id: Int!
    var position: String!
    var sectionOfProfilePressed: Bool = false
    
    let checkedImage = UIImage(named: "checked")!
    let editImage = UIImage(named: "editProfile")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Animations.sharedInstance.setSettingsOfNavigationController(target: self)
        name = info["name"] as! String
        id = info["placeID"] as! Int
        nameTextField.text = name
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        setInterfaceSettings()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        var city = UserModel.info().getAddress()
        position = city["address"] as! String
        addressLabel.text = position
        
        super.viewWillAppear(animated)
        if sectionOfProfilePressed{
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
        getPhotosOfSalon()
        sectionOfProfilePressed = false
        Animations.sharedInstance.showIndicator(viewController: self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if sectionOfProfilePressed{
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesOfGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionOfImages.dequeueReusableCell(withReuseIdentifier: "oneItem", for: indexPath) as! cellOfGalleryCollectionView
        cell.imageItem.image = imagesOfGallery[indexPath.row]
        cell.contentView.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        zoomImages(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 4.4
        let size = CGSize(width: cellWidth, height: cellWidth)
        
        return size
    }
    
    @IBAction func showAllPhotosOfGallery(_ sender: UIButton) {
        sectionOfProfilePressed = true
        let allPhotos = UIStoryboard(name: "UserSettingsPart", bundle: nil).instantiateViewController(withIdentifier: "allPhotosViewController") as! AdminGalleryViewController
        allPhotos.imagesOfGallery = self.imagesOfGallery
        allPhotos.imagesID = self.idOfImages
        self.navigationController?.pushViewController(allPhotos, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func addImageToGallery(_ sender: UIButton) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 1
        var selectedImage = UIImage(){
            didSet {
                imagesOfGallery.insert(selectedImage, at: 0)
                numberOfImage.setTitle("Все фотографии (\(self.imagesOfGallery.count))",for: .normal)
                collectionOfImages.reloadData()
            }
        }
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            manager.requestImage(for: assets.first!, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                selectedImage = result!
            })
            self.addImageToBackend(image: selectedImage)
        }, completion: nil)
    }
    
    @IBAction func changePosition(_ sender: UIButton) {
        sectionOfProfilePressed = true
        UserModel.info().typeOfPage = true
        let map = Bundle.main.loadNibNamed("MapSetAddress", owner: self, options: nil)?.first as! UIViewController
        self.navigationController?.pushViewController(map, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    
    @IBAction func openServices(_ sender: UIButton) {
        sectionOfProfilePressed = true
        UserModel.info().typeOfPage = true
        let services = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChooseSalonCategoryVC") as! ChooseSalonCategoryVC
        self.navigationController?.pushViewController(services, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func openFeedbacks(_ sender: UIButton) {
        sectionOfProfilePressed = true
        let feedbacks = UIStoryboard(name: "UserSettingsPart", bundle: nil).instantiateViewController(withIdentifier: "feedbackTableViewController") as! FeedbacksTableViewController
        self.navigationController?.pushViewController(feedbacks, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func openPayment(_ sender: UIButton) {
        sectionOfProfilePressed = true
        let payment = UIStoryboard(name: "UserSettingsPart", bundle: nil).instantiateViewController(withIdentifier: "payment") as! PaymentViewController
        self.navigationController?.pushViewController(payment, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func showPopupChangePassword(_ sender: Any) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let popOverVC = UIStoryboard(name: "UserSettingsPart", bundle: nil).instantiateViewController(withIdentifier: "popUpChangePass") as! popUpViewChangePassword
        popOverVC.profile = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        sectionOfProfilePressed = true
        self.navigationController?.isNavigationBarHidden = true
        UserModel.info().removeUserDefault()
        let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Registration") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = loginVC
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        if isChecked{
            if nameTextField.text?.characters.count != 0{
//                if isFreelancer{
//                    if surnameTextField.text?.characters.count != 0{
//                        disableBottomButtons(yes: false)
//                        
//                        if nameTextField.text != name || surnameTextField.text != surname{
//                            name = nameTextField.text!
//                            surname = surnameTextField.text!
//                            updateAdminInformation(name: name, surname: surname)
//                        }
//                        
//                        isChecked = !isChecked
//                    }else{
//                        showErrorAlert(errorMessage: "Заполните поля")
//                    }
//                }else{
                    disableBottomButtons(yes: false)
                    if nameTextField.text != name{
                        name = nameTextField.text!
                        updateAdminInformation(name: name)
                    }
                    isChecked = !isChecked
//                }
            }else{
                showErrorAlert(errorMessage: "Заполните поля")
            }
            
        } else {
            disableBottomButtons(yes: true)
            isChecked = !isChecked
        }
        
    }
    
    func zoomImages(index: Int){
        self.navigationController?.isNavigationBarHidden = true
        let zoomViewController: ScrollViewController = ScrollViewController()
        zoomViewController.photos = imagesOfGallery
        zoomViewController.fromMainPage = true
        zoomViewController.currentPageIndex = index
        self.addChildViewController(zoomViewController)
        zoomViewController.view.frame = self.view.frame
        self.view.addSubview(zoomViewController.view)
        zoomViewController.view.alpha = 0
        zoomViewController.didMove(toParentViewController: self)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomViewController.view.alpha = 1
        }, completion: nil)
    }
    
    
    func setInterfaceSettings(){
        if isFreelancer{
//            line2 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 1))
//            line2.backgroundColor = UIColor.lightGray
//            line2.translatesAutoresizingMaskIntoConstraints = false
//            
//            surnameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 17))
//            surnameLabel.text = "Фамилия:"
//            surnameLabel.font = UIFont(name: "Comfortaa-Regular", size: 15)
//            surnameLabel.textColor = #colorLiteral(red: 0.7607843137, green: 0.631372549, blue: 0.3843137255, alpha: 1)
//            
//            surnameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 17))
//            surnameTextField.text = surname
//            surnameTextField.font = UIFont(name: "Comfortaa-Regular", size: 17)
//            surnameTextField.textColor = UIColor.lightGray
//            surnameTextField.isUserInteractionEnabled = false
//            
//            
//            middleStack.insertArrangedSubview(line2, at: 3)
//            middleStack.insertArrangedSubview(surnameTextField, at: 3)
//            middleStack.insertArrangedSubview(surnameLabel, at: 3)
//            
//            
//            middleStack.addConstraint(NSLayoutConstraint(item: line2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1))
//            
//            middleStack.addConstraint(NSLayoutConstraint(item: line2, attribute: .leading, relatedBy: .equal, toItem: middleStack, attribute: .leading, multiplier: 1, constant: 0))
//            
//            middleStack.addConstraint(NSLayoutConstraint(item: surnameLabel, attribute: .leading, relatedBy: .equal, toItem: middleStack, attribute: .leading, multiplier: 1, constant: 10))
//            
//            middleStack.addConstraint(NSLayoutConstraint(item: surnameTextField, attribute: .leading, relatedBy: .equal, toItem: middleStack, attribute: .leading, multiplier: 1, constant: 15))
            
            nameLabel.text = "Имя и фамилия:"
//            if self.view.frame.height < 600{
//                nameLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
//                nameTextField.font = UIFont(name: "Comfortaa-Regular", size: 16)
//                surnameLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
//                surnameTextField.font = UIFont(name: "Comfortaa-Regular", size: 16)
//                positionLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
//                addressLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
//                changePosition.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 12)
//                bottomMarginOfBottomStack.constant = 3
//                topMarginOfMiddleStack.constant = -8
//                
//                middleStack.spacing = 5
//                
//                bottomStackWithButtons.spacing = 1
//            }
//        }else{
//            
        }
        
        if self.view.frame.height < 600{
            nameLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
            positionLabel.font = UIFont(name: "Comfortaa-Regular", size: 16)
            changePosition.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 12)
            bottomStackWithButtons.spacing = 3
            middleStack.spacing = 3
        }
        
        nameTextField.isUserInteractionEnabled = false
        surnameTextField.isUserInteractionEnabled = false
    }
    
    func disableBottomButtons(yes: Bool){
        if yes{
            for button in bottomButtons{
                button.titleLabel?.textColor = UIColor.lightGray
            }
            self.editButton.image = checkedImage
            self.changePosition.alpha = 1
            topViewOfDisable.isHidden = false
            bottomViewOfDisable.isHidden = false
            self.line1.layer.backgroundColor = UIColor.black.cgColor
            self.line2.layer.backgroundColor = UIColor.black.cgColor
            nameTextField.isUserInteractionEnabled = true
            surnameTextField.isUserInteractionEnabled = true
        }else{
            for button in bottomButtons{
                button.titleLabel?.textColor = #colorLiteral(red: 0.007843137255, green: 0.4235294118, blue: 0.3803921569, alpha: 1)
            }
            self.editButton.image = editImage
            self.changePosition.alpha = 0
            topViewOfDisable.isHidden = true
            bottomViewOfDisable.isHidden = true
            self.line1.layer.backgroundColor = UIColor.lightGray.cgColor
            self.line2.layer.backgroundColor = UIColor.lightGray.cgColor
            
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
        }
    }
    
    
    func showErrorAlert(errorMessage: String){
        if let view = self.view.viewWithTag(1000){
            view.removeFromSuperview()
        }
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as!  ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        showErrorAlert.view.tag = 1000
        
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        super.touchesBegan(touches, with:event)
    }
    
    
    func updateAdminInformation(name: String){
        var parameters: Dictionary<String,Any> = [:]
        parameters = [
                "name":name
            ]
        APIManager.sharedInstance.placeChangeInformation(placeID: id, parameters: parameters, onSuccess: {(_) in
            
            var dict = [String: Any]()
            dict = ["name": name, "id": self.info["id"] as! Int, "type": self.info["type"] as! Int, "placeID": self.info["placeID"] as! Int]
            UserModel.info().saveUserDict(dict: dict)
            Animations.sharedInstance.showSuccessView(viewContoller: self)
        })
    }
    
    func getPhotosOfSalon(){
        imagesOfGallery.removeAll()
        let allPhotos = -1
        APIManager.sharedInstance.placeGetPhotoByID(photoID: allPhotos, onSuccess: {(json) in
            if json.count != 0{
                for data in json.array!{
                    let photoURL = "http://bloomserver.northeurope.cloudapp.azure.com/media/"+data["image"].string!
                    self.idOfImages.insert(data["id"].int!, at: 0)
                    if let needImage = self.getImage(name: photoURL.components(separatedBy: "/").last!){
                        if needImage.accessibilityIdentifier == nil{
                            needImage.accessibilityIdentifier = photoURL.components(separatedBy: "/").last!
                        }
                        self.imagesOfGallery.insert(needImage, at: 0)
                        self.numberOfImage.setTitle("Все фотографии (\(self.imagesOfGallery.count))",for: .normal)
                        self.collectionOfImages.reloadData()
                        
                    }else{
                        if let imageURL = URL(string: photoURL){
                            do{
                                let data = try Data(contentsOf: imageURL)
                                if let _ = UIImage(data: data){
                                    let _ = SDWebImageDownloader.shared().downloadImage(with: imageURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                                        if let data = UIImageJPEGRepresentation(image!, 1) {
                                            let name = photoURL.components(separatedBy: "/")
                                            let filename = self.getDocumentsDirectory().appendingPathComponent(name.last!)
                                            try? data.write(to: filename)
                                        }
                                        self.imagesOfGallery.insert(image!, at: 0)
                                        self.collectionOfImages.reloadData()
                                        self.numberOfImage.setTitle("Все фотографии (\(self.imagesOfGallery.count))",for: .normal)
                                    })
                                    
                                }
                            } catch{
                                
                            }
                        }
                    }
                }
                
            }
            OperationQueue.main.addOperation {
                Animations.sharedInstance.hideIndicator(viewController: self)
            }
        })
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
    
    
    func addImageToBackend(image: UIImage){
        var photoURL = String()
        APIManager.sharedInstance.placeUploadPhotos(type: 0, placeID: id, comment: String(), images: [image], onSuccess: {(json) in
            self.idOfImages.insert(json["id"].int!, at: 0)
            photoURL = json["image"].string!
            if let data = UIImageJPEGRepresentation(image, 1) {
                let name = photoURL.components(separatedBy: "/")
                let filename = self.getDocumentsDirectory().appendingPathComponent(name.last!)
                try? data.write(to: filename)
            }
        })
    }
    
}
