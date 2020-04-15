//
//  AdminGalleryViewController.swift
//  Bloom
//
//  Created by Жарас on 28.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var imagesOfGallery: [UIImage] = []
    var imagesID: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Все фото"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesOfGallery.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "onePhoto", for: indexPath) as! OnePhotoCollectionViewCell
        cell.deleteButton.isHidden = false
        if imagesOfGallery.count == 1{
            cell.deleteButton.isHidden = true
        }
        
        cell.imageViewOfGallery.image = imagesOfGallery[indexPath.row]
        cell.contentView.backgroundColor = UIColor.black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.isNavigationBarHidden = true
        let zoomViewController: ScrollViewController = ScrollViewController()
        zoomViewController.photos = imagesOfGallery
        zoomViewController.currentPageIndex = indexPath.row
        self.addChildViewController(zoomViewController)
        zoomViewController.view.frame = self.view.frame
        self.view.addSubview(zoomViewController.view)
        zoomViewController.view.alpha = 0
        zoomViewController.didMove(toParentViewController: self)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomViewController.view.alpha = 1
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.5
        let size = CGSize(width: cellWidth, height: cellWidth)
        
        return size
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        Animations.sharedInstance.showIndicator(viewController: self)
        let buttonPosition = sender.convert(CGPoint.zero, to: self.imagesCollectionView)
        if let indexPath = self.imagesCollectionView.indexPathForItem(at: buttonPosition){
            removeImageFromDocumentDirectory(itemName: imagesOfGallery[indexPath.row].accessibilityIdentifier!)
            imagesOfGallery.remove(at: indexPath.row)
            deleteFromBackend(id: imagesID[indexPath.row])
            imagesID.remove(at: indexPath.row)
            imagesCollectionView.reloadData()
        }
    }
    
    func removeImageFromDocumentDirectory(itemName:String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func deleteFromBackend(id: Int){
        APIManager.sharedInstance.deletePhotoByID(photoID: id, onSuccess: {(json) in
            Animations.sharedInstance.hideIndicator(viewController: self)
        })
    }
    
}
