//
//  PhotoNameAboutYourSelfVC.swift
//  Bloom
//
//  Created by Serik on 17.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

import BSImagePicker
import Photos

class PhotoNameAboutYourSelfVC: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate{
    
    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var Image: UIImageView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var nameOfSalon: UITextField!
    @IBOutlet var aboutTextView: UITextView!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var addPhoto: UILabel!
    @IBOutlet var lineX: UIView!
    @IBOutlet var basketToDelete: UIButton!
    @IBOutlet var camera: UIButton!
    @IBOutlet var addPhotoView: UIView!
    @IBOutlet var backView: UIView!
    
    
    var SelectedAssets = [PHAsset]()
    var array = [UIImage]()
    
    var x = CGFloat()
    var y = CGFloat()
    var viewForKeyboardPosition = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.delegate = self
        basketToDelete.isHidden = true
        x = aboutTextView.frame.size.height
        y = aboutTextView.frame.size.height
        
        
        viewForKeyboardPosition = backView.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if(UserModel.info().type == 2){
            nameOfSalon.placeholder = "Ваше имя и фамилия"
            icon.image = UIImage(named: "userProfile")
            aboutTextView.text = "Немного о себе"
        }
        else{
            nameOfSalon.placeholder = "Название салона"
            icon.image = UIImage(named: "barbershop")
            aboutTextView.text = "Немного о салоне"
        }
    }
    //## Keyboard Function
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y == viewForKeyboardPosition{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y -= keyboardSize.height * 0.3
                })
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.backView.frame.origin.y != 0{
                UIView.animate(withDuration: 1, animations: {
                    self.backView.frame.origin.y += keyboardSize.height * 0.3
                })
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == self.nameOfSalon {
            aboutTextView.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    

   //## CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionCell
        cell.image.image = array[indexPath.row]
        cell.frame.size = CGSize(width: cell.image.frame.size.width, height: cell.image.frame.size.height)
        return cell
    }
    
    //to send index which pressed
    var index = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            Image.image = array[indexPath.row]
            index = indexPath.row
    }

    
    
   // to Delete photos
    @IBAction func deleteBtn(_ sender: UIButton) {
        if(array.count != 0){
            deletePhoto(index: index)
            CollectionView.reloadData()
            if array.count == 0{
                deleteBtn.isHidden = true
                camera.isHidden = false
                addPhotoView.isHidden = true
                addPhoto.isHidden = false
                Image.image = UIImage()
                Image.backgroundColor = UIColor.gray
            }
        }
    }
    func deletePhoto(index: Int){
        array.remove(at: index)
        SelectedAssets.remove(at: index)
        if array.count > 0{
            if index == array.count{
                Image.image = array[index-1]
                self.index = index-1
            }else{
                Image.image = array[index]
            }
        }
    }
    

    //## TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        aboutTextView.text = nil
        UIView.animate(withDuration: 0.3, animations: {
        
            if(self.x == 0 && self.aboutTextView.frame.size.height == self.y){
                self.aboutTextView.frame.size.height += self.y
                self.lineX.frame.origin.y += self.y
            }
            else{
                self.aboutTextView.frame.size.height += self.x
                self.lineX.frame.origin.y += self.x
            }

        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(aboutTextView.text.isEmpty){
            UIView.animate(withDuration: 0.3, animations: {
                self.aboutTextView.frame.size.height -= self.aboutTextView.frame.size.height / 2
                self.lineX.frame.origin.y -= self.aboutTextView.frame.size.height
            }, completion: nil)
            
            if(UserModel.info().type == 2){
                aboutTextView.text = "Немного о себе"
            }
            else{
                aboutTextView.text = "Немного о салоне"
            }
        }
        else{
            x = 0
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            send()
            return false
        }
        return true
    }


    //## Selected images
    @IBAction func showImagePickerWithSelectedAssets(_ sender: UIButton) {
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        var evenAssetIds = [String]()
 
        allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
            for i in 0..<self.SelectedAssets.count{
                let assets = self.SelectedAssets[i]
                if(asset == assets){
                    evenAssetIds.append(asset.localIdentifier)
                }
            }
        })
        
        let evenAssets = PHAsset.fetchAssets(withLocalIdentifiers: evenAssetIds, options: nil)
        
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 10
        vc.defaultSelections = evenAssets
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            self.SelectedAssets.removeAll()
            self.array.removeAll()
            //self.CollectionView.reloadData()
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            self.getAllImages()
        }, completion: nil)
    }

    
    //## Add images for first time
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 10
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            self.getAllImages()
 
        }, completion: nil)
    }
    
    func showHide(){
        self.Image.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        self.Image.image = array[0]
        self.basketToDelete.isHidden = false
        self.camera.isHidden = true
        self.addPhotoView.isHidden = false
        self.addPhoto.isHidden = true
    }

    //## to convert image from asset
    func getAllImages() -> Void {
        print("get all images method called here")
        if self.SelectedAssets.count != 0{
            for i in 0..<self.SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
               manager.requestImage(for: self.SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.array.append(thumbnail)
            }
        }
        DispatchQueue.main.async {
            () -> Void in
            self.showHide()
            self.CollectionView.reloadData()
            self.Image.image = self.array[0]
        }
    }
    
   
    
    
    // ## BACK BUTTON PRESSED
    @IBAction func backButtonPressed(_ sender: UIButton) {
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(2)
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    
    // NEXT BUTTON PRESSED
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        send()
    }
    func send(){
        nameOfSalon.resignFirstResponder()
        aboutTextView.resignFirstResponder()
        
        if(nameOfSalon.text != "" && aboutTextView.text != "Немного о себе" && aboutTextView.text != "Немного о салоне"){
            if(array.count != 0){
               
                UserModel.info().name = nameOfSalon.text!

                UserModel.info().description = aboutTextView.text
                UserModel.info().images = array
                print(array.count)
                let map = Bundle.main.loadNibNamed("MapSetAddress", owner: self, options: nil)?.first as! UIViewController
                self.navigationController?.pushViewController(map, animated: true)
            }
            else{
                showErrorAlert(errorMessage: "Add Photo")
            }
        }
        else{
            showErrorAlert(errorMessage: "Заполните поле")
        }
        
    }
    
    //#### Function Show Error Alert
    func showErrorAlert(errorMessage: String){
        let showErrorAlert = UIStoryboard(name: "ErrorAlert", bundle: nil).instantiateViewController(withIdentifier: "ErrorAlert") as! ErrorAlertShow
        showErrorAlert.errorMessageLabel = errorMessage
        self.addChildViewController(showErrorAlert)
        showErrorAlert.view.frame = self.view.frame
        self.view.addSubview(showErrorAlert.view)
        showErrorAlert.didMove(toParentViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameOfSalon.resignFirstResponder()
        aboutTextView.resignFirstResponder()
    }
}
