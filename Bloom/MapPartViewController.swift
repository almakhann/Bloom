//
//  MapViewController.swift
//  Bloom
//
//  Created by Vadim on 11.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import SocketIO
import UserNotifications

class MapPartViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var searchLocationButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var setDistanceView: UIView!
    
    @IBOutlet weak var findMyLocationImageView: UIImageView!
    @IBOutlet weak var chooseNewAdressImageView: UIImageView!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var setDistanceCancelButton: UIButton!
    @IBOutlet weak var setDistanceOkButton: UIButton!
    @IBOutlet weak var findMyLocationButton: UIButton!
    @IBOutlet weak var chooseNewAdressButton: UIButton!
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBOutlet weak var sendOrderButton: UIButton!
    @IBOutlet weak var calendarSettingsView: UIView!
    @IBOutlet weak var calendarViewDoneButton: UIButton!
    @IBOutlet weak var calendarViewCancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var deleteOrderButton: UIButton!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var locationAcceptButton: UIButton!
    
    
    @IBOutlet weak var salonInformationView: UIView!
    
    @IBOutlet weak var fiveStarImageView: UIImageView!
    @IBOutlet weak var fourStarImageView: UIImageView!
    @IBOutlet weak var threeStarImageView: UIImageView!
    @IBOutlet weak var twoStarImageView: UIImageView!
    @IBOutlet weak var oneStarImageView: UIImageView!
    
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var salonDistanceLabel: UILabel!
    @IBOutlet weak var salonAdressLabel: UILabel!
    @IBOutlet weak var salonInformationLabel: UILabel!
    
    var markerIndex = 0
    
    var showCategory = 1
    
    var searchButtonPressed = 0
    
    var choosenDate = ""
    var orderLocation = 0
    
    var orderCreated = 0
    
    var previusMarker = -1
    
    var showCalendar = 1
    var showSelectLocation = 1
    
    var chooseNewAdressCount = 0
    
    var listButtonPressed = 0
    
    var categoryAlreadyShown = 0 // 0 - not selecting categories 1 - selecting but tabbing in tab bar
    
    var searchChooseLocation = 0 //if 1 - user on search location menu, variable is created to hide collection view on top
    
    var requestIdDeleteOrder = 0
    
    var parameters: Dictionary<String,Any> = [
        "radius": 10,
        "features":[
            [
                "feature": 2,
                "price": 1000
            ],
            [
                "feature": 3,
                "price": 1000
            ],
            [
                "feature": 3,
                "price": 1000
            ]
        ],
        "location_x": "43.231202",
        "location_y": "76.920436",
        "time": "2017-07-26 17:58:00"
    ]
    
    var choosenLocationLatitude: CLLocationDegrees = 43.231202
    var choosenLocationLongitude: CLLocationDegrees = 76.920436
    
    var choosenLocation = 0 //0 - current location by default, 1 - choosen location by user
    var choosenRadius = 2 //2 - radius by default, 1 - minimum
    var tempRadius = 2
    
    var order = SendOrder()
    
    var salonInfo = Marker()
    
    var markers: [Marker] = []
    
    var circle: GMSCircle!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var disabledGreyColor = UIColor(red: 160/255, green: 159/255, blue: 159/255, alpha: 1)
    var darkGreyColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    var blackViewBackgroundColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 0.25)
    var selectedOrangeColor = UIColor(red: 194/255, green: 161/255, blue: 98/255, alpha: 1)
    
    
    //var locationSelected = Location.searchLocationTextField
    //firstCollectionView variables
    let firstCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.tag = 1
        return cv
    }()
    
    let cellId2 = "cellId2"
    
    var itemToShow = ""
    var count = -1
    var firstImageName = ""
    var secondLabelName = ""
    // end first collection view
    
    //second collection view
    let secondCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.tag = 2
        return cv
    }()
    
    let cellId3 = "cellId3"
    // end second collection view
    
    //third collection view
    let thirdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.tag = 3
        return cv
    }()
    
    let cellId4 = "cellId4"
    // end third collection view
    
    //MainCollectionView variables
    
    let transparentView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0, alpha: 0)
        cv.tag = 0
        return cv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("   <", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 33)
        button.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        
        return button
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 18)
        button.layer.cornerRadius = 3
        return button
    }()
    
    let cellId = "cellId"
    
    var count1 = 0
    
    var imagesNames: [String] = ["eyeMakeUp", "Scissors-1", "bodyCare", "nails"]
    
    var parentCategory : [Feature] = []
    var childCategory: [Child] = []
    var subchildCategory: [SubChild] = []
    
    var features : [Features] = []
    
    var ordersCount = 0
    
    var lastIndex = 0
    var firstIndex = 0
    // end main collection view
    
//    //change price view
//    
//    let changePriceView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.isHidden = true
//        return view
//    }()
//    
//    let headerPriceLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
//        label.text = "Укажите новую цену для услуг"
//        label.numberOfLines = 2
//        return label
//    }()
//    
//    let priceChangeCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.white
//        cv.tag = 4
//        return cv
//    }()
//    
//    let tryAgainButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Повторить еще раз", for: .normal)
//        button.backgroundColor = UIColor.darkGray
//        button.titleLabel?.textColor = UIColor.white
//        return button
//    }()
//    
//    let cancelChangePriceButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Отменить заказ", for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.backgroundColor = UIColor.gray
//        button.titleLabel?.textColor = UIColor.white
//        return button
//    }()
//    
//    let acceptChangePriceButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor.orange
//        button.setTitle("Подтвердить", for: .normal)
//        button.titleLabel?.textColor = UIColor.white
//        return button
//    }()
//    
//    //end change price view
    
    
    @IBOutlet weak var refreshView: UIView!
    
    var cellId5 = "cellId5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hi")
        
        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        firstCollectionView.register(OrderCell.self, forCellWithReuseIdentifier: cellId2)
        
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        self.secondCollectionView.register(OrderCell.self, forCellWithReuseIdentifier: cellId3)
        
        thirdCollectionView.dataSource = self
        thirdCollectionView.delegate = self
        self.thirdCollectionView.register(OrderCell.self, forCellWithReuseIdentifier: cellId4)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.delegate = self
        

        
//        createOrderViewModel.delegate = self
        
        blackView.backgroundColor = blackViewBackgroundColor
        blackView.isHidden = true
        calendarSettingsView.backgroundColor = UIColor.white
        calendarSettingsView.isHidden = true
        setDistanceView.backgroundColor = UIColor.white
        setDistanceView.isHidden = true
        radiusLabel.layer.cornerRadius = 3
        radiusLabel.layer.borderWidth = 2
        searchButton.isEnabled = false
        searchButton.backgroundColor = darkGreyColor
        
        setDistanceOkButton.layer.cornerRadius = 3
        setDistanceCancelButton.layer.cornerRadius = 3
        refreshButton.isHidden = true
        
        listButton.isHidden = true
        listButton.backgroundColor = darkGreyColor
        
        deleteOrderButton.layer.cornerRadius = 3.45
        addButton.layer.cornerRadius = 3.45
        locationButton.layer.cornerRadius = 3.45
        sendOrderButton.layer.cornerRadius = 3.45
        listButton.layer.cornerRadius = 3.45
        refreshButton.layer.cornerRadius = 3.45
        hideButtons()
        
        searchLocationTextField.isHidden = true
        searchLocationButton.isHidden = true
        
        locationAcceptButton.isHidden = true
        
        salonInformationView.backgroundColor = UIColor.white
        salonInformationView.isHidden = true
        
        datePicker.timeZone = NSTimeZone.local
        
        //getCategory()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        placesClient = GMSPlacesClient.shared()
        
        //        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 15)
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.231202, longitude: 76.920436, zoom: 15)
        
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        self.circle = GMSCircle(position: camera.target, radius: 0)
        self.circle.map = mapView
        self.circle.fillColor = UIColor(white: 0, alpha: 0.5)
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        priceTextField.delegate = self
        priceTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        priceTextField.attributedPlaceholder = NSAttributedString(string: "Укажите цену", attributes: [NSForegroundColorAttributeName : UIColor.white])
        priceTextField.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        priceTextField.textAlignment = .center
        priceTextField.textColor = UIColor.white
        priceTextField.font = UIFont(name: "Comfortaa", size: 16)
        priceTextField.isHidden = true
        priceTextField.layer.cornerRadius = 3
        priceTextField.layer.masksToBounds = true
        
        priceTextField.isHidden = true
        transparentView.isHidden = true
        mapView.addSubview(transparentView)
        transparentView.addSubview(cancelButton)
        transparentView.addSubview(collectionView)
        transparentView.addSubview(okButton)
        //transparentView.addSubview(priceTextField)
        
        transparentView.alpha = 1
        transparentView.backgroundColor = UIColor.clear
        
        transparentView.frame = CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height - 50)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.frame = CGRect(x: -45, y: (mapView.frame.height - 90 - 50) / 2, width: 90, height: 90)
        cancelButton.layer.cornerRadius = 45
        priceTextField.frame = CGRect(x: ((transparentView.frame.width - 150 - 60 - 10) / 2), y: ((transparentView.frame.height - 60) / 2), width: 150, height: 60)
        okButton.frame = CGRect(x: ((transparentView.frame.width - 150 - 60 - 10) / 2) + 150 + 10, y: ((transparentView.frame.height - 60) / 2), width: 60, height: 60)
        okButton.addTarget(self, action: #selector(handleDismissSecond), for: .touchUpInside)
        okButton.backgroundColor = UIColor(red: 194/255, green: 161/255, blue: 98/255, alpha: 1)
        self.view.insertSubview(transparentView, belowSubview: priceTextField)
        self.view.insertSubview(mapView, belowSubview: sendOrderButton)
        
        mapView.addSubview(refreshView)
        refreshView.isHidden = true

//        mapView.addSubview(changePriceView)
//        changePriceView.addSubview(headerPriceLabel)
//        changePriceView.addSubview(priceChangeCollectionView)
//        changePriceView.addSubview(tryAgainButton)
//        changePriceView.addSubview(cancelChangePriceButton)
//        changePriceView.addSubview(acceptChangePriceButton)
//        
//        changePriceView.frame = CGRect(x: 10, y: 40, width: 300, height: 500)
//        headerPriceLabel.frame = CGRect(x: 10, y: 40, width: 300, height: 60)
        
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == "0") && (textField.text?.characters.count == 0) {
            return false
        }
        
        if (textField.text?.characters.count == 6) {
            let char = string.cString(using: String.Encoding.utf8)
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                return true
            } else {
                return false
            }
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    func showButtons() {
        //show buttons after first order created
        searchButton.isHidden = false
        deleteOrderButton.isHidden = false
        addButton.isHidden = false
        locationButton.isHidden = false
        sendOrderButton.isHidden = false
    }
    
    func hideButtons() {
        //hide buttons before order created
        searchButton.isHidden = true
        deleteOrderButton.isHidden = true
        addButton.isHidden = true
        locationButton.isHidden = true
        sendOrderButton.isHidden = true
    }
    
    @IBAction func sendOrderButtonPressed(_ sender: UIButton) {
        blackView.isHidden = false
        calendarSettingsView.isHidden = false
        datePicker.minimumDate = Date()
    }
    
    @IBAction func minusRadiusButtonPressed(_ sender: UIButton) {
        if (tempRadius > 1) {
            tempRadius -= 1
            radiusLabel.text = "\(tempRadius) км"
        }
    }
    
    @IBAction func plusRadiusButtonPressed(_ sender: UIButton) {
        tempRadius += 1
        radiusLabel.text = "\(tempRadius) км"
    }
    
    @IBAction func calendarViewSelectButtonPressed(_ sender: UIButton) {
        calendarSettingsView.isHidden = true
        sendOrderButton.backgroundColor = selectedOrangeColor
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        choosenDate = selectedDate
        
        print(choosenDate)
        
        if (orderLocation == 1) {
            searchButton.isEnabled = true
            searchButton.backgroundColor = selectedOrangeColor
        }
        
        if (orderCreated == 1 && showSelectLocation == 1) {
            setDistanceView.isHidden = false
            showSelectLocation = 0
        } else {
            blackView.isHidden = true
            showSelectLocation = 0
        }
    }
    
    @IBAction func calendarViewCancelButtonPressed(_ sender: UIButton) {
        blackView.isHidden = true
        calendarSettingsView.isHidden = true
        showCalendar = 0
        showSelectLocation = 0
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        blackView.isHidden = false
        tempRadius = choosenRadius
        radiusLabel.text = "\(tempRadius) км"
        setDistanceView.isHidden = false
    }
    
    @IBAction func findMyLocationButtonPressed(_ sender: UIButton) {
        chooseNewAdressImageView.image = UIImage(named: "off")
        findMyLocationImageView.image = UIImage(named: "on")
        choosenLocation = 0
    }
    
    @IBAction func chooseNewAdressButtonPressed(_ sender: UIButton) {
        chooseNewAdressImageView.image = UIImage(named: "on")
        findMyLocationImageView.image = UIImage(named: "off")
        choosenLocation = 1
    }
    
    @IBAction func searchLocationButtonPressed(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    //choosing location using search
    @IBAction func locationAcceptButtonPressed(_ sender: UIButton) {
        self.searchLocationTextField.isHidden = true
        self.searchLocationButton.isHidden = true
        self.locationAcceptButton.isHidden = true
        
        choosenRadius = tempRadius
        orderLocation = 1
        
        if (choosenDate != "") {
            searchButton.isEnabled = true
            searchButton.backgroundColor = selectedOrangeColor
        }
        
        chooseNewAdressCount = 0
        
        showButtons()
        showTopOrders()
        
        self.searchChooseLocation = 0
        
        mapView.clear()
        self.circle.map = mapView
    }
    
    @IBAction func setDistanceCancelButtonPressed(_ sender: UIButton) {
        blackView.isHidden = true
        setDistanceView.isHidden = true
    }
    
    
    @IBAction func setDistanceOkButtonPressed(_ sender: UIButton) {
        blackView.isHidden = true
        setDistanceView.isHidden = true
        locationButton.backgroundColor = selectedOrangeColor
        //my location, set to location
        if (choosenLocation == 0) {
            //            choosenLocationLatitude = (self.locationManager.location?.coordinate.latitude)!
            //            choosenLocationLongitude = (self.locationManager.location?.coordinate.longitude)!
            choosenRadius = tempRadius
            orderLocation = 1
            
            if (choosenDate != "") {
                searchButton.isEnabled = true
                searchButton.backgroundColor = selectedOrangeColor
            }
            
            choosenLocationLatitude = 43.231202
            choosenLocationLongitude = 76.920436
            
            let camera = GMSCameraPosition.camera(withLatitude: choosenLocationLatitude, longitude: choosenLocationLongitude, zoom: 15)
            self.circle.position = CLLocationCoordinate2D(latitude: choosenLocationLatitude, longitude: choosenLocationLongitude)
            self.circle.radius = Double(choosenRadius * 1000)
            self.mapView.animate(to: camera)
            
        } else { //location on map
            searchLocationTextField.isHidden = false
            searchLocationButton.isHidden = false
            locationAcceptButton.isHidden = false
            locationAcceptButton.isEnabled = false
            locationAcceptButton.backgroundColor = disabledGreyColor
            hideButtons()
            hideTopOrders()
            chooseNewAdressCount = 1
            self.circle.map = mapView
            circle.radius = 0
            self.searchChooseLocation = 1
        }
    }
    
    
    @IBAction func salonCalncelPressed(_ sender: UIButton) {
        salonInformationView.isHidden = true
        Animations.sharedInstance.setTabBarVisible(target: self, visible: true, animated: false)
    }
    
    @IBAction func salonMoreButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MapPart", bundle: nil)
        let salonProfile = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        salonProfile.distanceImg = UIImage(named: "distance")
        salonProfile.distanceLbl = String(salonInfo.distance)
        salonProfile.streetImg = UIImage(named: "Point")
        salonProfile.streetLbl = salonInfo.salonAddress
        salonProfile.salonName = salonInfo.salonName
        salonProfile.salonRating = salonInfo.salonRating
        salonProfile.salonDescription = salonInfo.salonDescription
        
        self.navigationController?.pushViewController(salonProfile, animated: true)
    }
    
    @IBAction func deleteOrderButtonPressed(_ sender: UIButton) {
        if (searchButtonPressed == 0) {
            removeAllOrders()
        } else if (searchButtonPressed == 1) {
            //delete order from back
            removeAllOrders()
        }
    }
    
    func removeAllOrders() {
        searchButtonPressed = 0
        
        hideFirstOrder(count: 0)
        
        mapView.clear()
        self.circle.map = mapView
        circle.radius = 0
        
        sendOrderButton.backgroundColor = darkGreyColor
        locationButton.backgroundColor = darkGreyColor
        orderLocation = 0
        choosenDate = ""
        tempRadius = 2
        choosenRadius = 2
        searchButton.backgroundColor = darkGreyColor
        searchButton.isEnabled = false
        
        radiusLabel.text = "\(tempRadius) км"
        
        showCategory = 1
        
        showCalendar = 1
        showSelectLocation = 1
        
        if (ordersCount == 2) {
            hideSecondOrder(count: 0)
        }
        if (ordersCount == 3) {
            hideSecondOrder(count: 0)
            hideThirdOrder(count: 0)
            addButton.isEnabled = true
            addButton.backgroundColor = darkGreyColor
        }
        
        ordersCount = 0
        features = []
        
        hideButtons()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchButtonPressed = 1
        searchButton.isEnabled = false
        searchButton.backgroundColor = disabledGreyColor
        let choosenLocationLongitudeString = String(format: "%f", choosenLocationLongitude)
        let choosenLocationLatitudeString = String(format: "%f", choosenLocationLatitude)
        self.order = SendOrder(radius: choosenRadius, locationX: choosenLocationLatitudeString, locationY: choosenLocationLongitudeString, time: choosenDate)
        self.order.features = features
        
        sendOrderButton.isHidden = true
        locationButton.isHidden = true
        
        deleteOrderButton.isHidden = true
        
        addButton.isHidden = true
        
//        SocketIOManager.sharedInstance.establishConnection()
//        SocketIOManager.sharedInstance.sendTestMessage()
//        SocketIOManager.sharedInstance.startSocketListener()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getTest(_:)), name: NSNotification.Name(rawValue: "placeOrderTest"), object: nil)
//        
        sendOrder()
    }
    
    func getTest(_ notification: NSNotification) {
        print("Test")
    }
    
    @IBAction func listButtonPressed(_ sender: UIButton) {
        let view = ListSegueTable.instanceFromNib() as! ListSegueTable
        view.frame = self.mapView.frame
        view.massiveOfSalons = self.markers
        view.superVC = self
        view.setupTableView()
        view.alpha = 0
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.showHideTransitionViews], animations: {
            view.alpha = 1
        })
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        //refreshView.isHidden = false
        addButton.isHidden = false
        refreshButton.isHidden = true
        deleteOrderButton.isHidden = false
        sendOrderButton.isHidden = false
        locationButton.isHidden = false
        
        deleteOrderFromBackend(id: requestIdDeleteOrder)
        
        mapView.clear()
        self.circle.map = mapView
        circle.radius = 0
        
        markers = []
        markerIndex = 0
        
        tempRadius = 2
        choosenRadius = 2
        sendOrderButton.backgroundColor = darkGreyColor
        locationButton.backgroundColor = darkGreyColor
        orderLocation = 0
        choosenDate = ""
        searchButton.backgroundColor = darkGreyColor
        searchButton.isEnabled = false
        searchButton.isHidden = false
        listButton.isHidden = true
    }
    
    func deleteOrderFromBackend(id: Int) {
        APIManager.sharedInstance.orderDeleteCreatedOrderUser(requestID: id) { (json) in
            print("Deleted")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        categoryAlreadyShown = 1
        showMainCategory()
        hideButtons()
    }
    
    func socketLike() {
        for item in markers {
            if (0 == item.marker.userData as? Int) {
                salonNameLabel.text = item.salonName
                salonDistanceLabel.text = String(item.distance)
                salonAdressLabel.text = item.salonAddress
                salonInformationLabel.text = item.salonDescription
                
                
                if (item.status == 1) {
                    item.marker.icon = UIImage(named: "Item_On_Map")
                    item.status = 0
                } else
                    if (item.status == 0) {
                        item.status = 1
                        item.marker.icon = UIImage(named: "pointGreen")
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        circle.position = position.target
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
//    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
//        circle.position = position.target
//    }
    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: Error!) {
//        print("didFailWithError \(error)")
//    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //marker.icon = UIImage(named: "Point")
        
        Animations.sharedInstance.setTabBarVisible(target: self, visible: false, animated: false)
        salonInformationView.isHidden = false
        
        for item in markers {
            if (marker.userData as? Int == item.marker.userData as? Int) {
                salonInfo = Marker()
                salonNameLabel.text = item.salonName
                salonDistanceLabel.text = String(item.distance)
                salonAdressLabel.text = item.salonAddress
                salonInformationLabel.text = item.salonDescription
                setRating(rating: item.salonRating)
                if (item.status == 1) {
                    item.marker.icon = UIImage(named: "Point")
                }
                salonInfo = item
                break
            }
        }
        
        return true;
    }
    
    func setRating(rating: Int) {
        
        if (rating == 1) {
            oneStarImageView.image = UIImage(named: "Star_Yellow")
            twoStarImageView.image = UIImage(named: "Star_Green")
            threeStarImageView.image = UIImage(named: "Star_Green")
            fourStarImageView.image = UIImage(named: "Star_Green")
            fiveStarImageView.image = UIImage(named: "Star_Green")
        } else if (rating == 2) {
            oneStarImageView.image = UIImage(named: "Star_Yellow")
            twoStarImageView.image = UIImage(named: "Star_Yellow")
            threeStarImageView.image = UIImage(named: "Star_Green")
            fourStarImageView.image = UIImage(named: "Star_Green")
            fiveStarImageView.image = UIImage(named: "Star_Green")
        } else if (rating == 3) {
            oneStarImageView.image = UIImage(named: "Star_Yellow")
            twoStarImageView.image = UIImage(named: "Star_Yellow")
            threeStarImageView.image = UIImage(named: "Star_Yellow")
            fourStarImageView.image = UIImage(named: "Star_Green")
            fiveStarImageView.image = UIImage(named: "Star_Green")
        } else if (rating == 4) {
            oneStarImageView.image = UIImage(named: "Star_Yellow")
            twoStarImageView.image = UIImage(named: "Star_Yellow")
            threeStarImageView.image = UIImage(named: "Star_Yellow")
            fourStarImageView.image = UIImage(named: "Star_Yellow")
            fiveStarImageView.image = UIImage(named: "Star_Green")
        } else if (rating == 5) {
            oneStarImageView.image = UIImage(named: "Star_Yellow")
            twoStarImageView.image = UIImage(named: "Star_Yellow")
            threeStarImageView.image = UIImage(named: "Star_Yellow")
            fourStarImageView.image = UIImage(named: "Star_Yellow")
            fiveStarImageView.image = UIImage(named: "Star_Yellow")
        } else {
            oneStarImageView.image = UIImage(named: "Star_Green")
            twoStarImageView.image = UIImage(named: "Star_Green")
            threeStarImageView.image = UIImage(named: "Star_Green")
            fourStarImageView.image = UIImage(named: "Star_Green")
            fiveStarImageView.image = UIImage(named: "Star_Green")
        }
    }
    
    func createMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees, imageName: String) {
        let markerLocation = CLLocationCoordinate2DMake(latitude, longitude )
        let marker = GMSMarker(position: markerLocation)
        marker.map = mapView
        marker.userData = markerIndex
        marker.icon = UIImage(named: imageName)
        markerIndex += 1
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print(tabBarIndex)
        if (tabBarIndex == 2) && (categoryAlreadyShown == 0) && (ordersCount == 0) {
            showMainCategory()
            categoryAlreadyShown = 1
        } else if (tabBarIndex == 2) && (categoryAlreadyShown == 1) {
            cancelOrderButtonPressed()
            categoryAlreadyShown = 0
        }
    }
    
    func sendOrder() {
        if (order.features.count == 3) {
            parameters = [
                "radius": order.radius,
                "features":[
                    [
                        "feature": order.features[0].feature,
                        "price": order.features[0].price
                    ],
                    [
                        "feature": order.features[1].feature,
                        "price": order.features[1].price
                    ],
                    [
                        "feature": order.features[2].feature,
                        "price": order.features[2].price
                    ]
                ],
                //                "location_x": "43.231202",
                //                "location_y": "76.920436",
                "location_x": order.locationX,
                "location_y": order.locationY,
                "time": order.time
            ]
        } else  if (order.features.count == 2) {
            parameters = [
                "radius": order.radius,
                "features":[
                    [
                        "feature": order.features[0].feature,
                        "price": order.features[0].price
                    ],
                    [
                        "feature": order.features[1].feature,
                        "price": order.features[1].price
                    ]
                ],
                //                "location_x": "43.231202",
                //                "location_y": "76.920436",
                "location_x": order.locationX,
                "location_y": order.locationY,
                "time": order.time
            ]
        } else if (order.features.count == 1) {
            parameters = [
                "radius": order.radius,
                "features":[
                    [
                        "feature": order.features[0].feature,
                        "price": order.features[0].price
                    ]
                ],
                //                "location_x": "43.231202",
                //                "location_y": "76.920436",
                "location_x": order.locationX,
                "location_y": order.locationY,
                "time": order.time
            ]
        }
        APIManager.sharedInstance.orderCreateOrder(parameters: parameters, onSuccess: {(json) in
            print("Json")
            print(json)
            if json.count != 0 {
                let salons = json["places"]
                print("count != 0")
                
                if ((json["status"] == "0") || (json["status"] == "400")) {
                        let alert = UIAlertController(title: "Поиск не удался", message: "В выбранном радиусе нет активных салонов", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            
                            self.addButton.isHidden = false
                            self.refreshButton.isHidden = true
                            self.deleteOrderButton.isHidden = false
                            self.sendOrderButton.isHidden = false
                            self.locationButton.isHidden = false
                            
                            self.searchButton.isHidden = false
                            self.listButton.isHidden = true
                            
                            self.mapView.clear() // clear marker if exist with circle radius 0
                            self.circle.map = self.mapView
                            self.circle.radius = 0
                            
                            self.sendOrderButton.backgroundColor = self.darkGreyColor
                            self.locationButton.backgroundColor = self.darkGreyColor
                            self.orderLocation = 0
                            self.choosenDate = ""
                            self.tempRadius = 2
                            self.choosenRadius = 2
                            self.searchButton.backgroundColor = self.darkGreyColor
                            self.searchButton.isEnabled = false
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                } else if (salons.count != 0) {
                    print("COUNT")
                    self.requestIdDeleteOrder = json["id"].int!
                    
                    for salon in salons.array! {
                        let status = salon["status"].int!
                        let id = salon["place"]["id"].int!
                        let salonDescription = salon["place"]["description"].string!
                        let salonName = salon["place"]["name"].string!
                        let salonRating = salon["place"]["rating"].int!
                        let salonAddress = salon["place"]["address"].string!
                        let distance = salon["distance"].string!
                        var newDistance: String = distance
                        if (newDistance.characters.count > 6) {
                            newDistance = String(newDistance.characters.prefix(3)) + " км"
                        }
                        
                        let salonLatitude = String(describing: salon["place"]["location_x"])
                        let salonLongitude = String(describing: salon["place"]["location_y"])
                        
                        let locationX = Double(salonLatitude)
                        let locationY = Double(salonLongitude)
                        
                        if (CLLocationDegrees(salonLatitude) != nil) && (CLLocationDegrees(salonLongitude) != nil) {
                            
                            let markerLocation = CLLocationCoordinate2DMake(locationX!, locationY!)
                            let marker = GMSMarker(position: markerLocation)
                            marker.map = self.mapView
                            marker.userData = self.markerIndex
                            marker.icon = UIImage(named: "Item_On_Map")
                            self.markerIndex += 1
                            
                            self.markers.append(Marker(marker: marker, status: status, id: id, salonDescription: salonDescription, salonName: salonName, salonRating: salonRating,salonAddress: salonAddress, distance: newDistance, locationX: locationX!, locationY: locationY!))
                            print(id)
                        }
                    }
                    self.searchButton.isHidden = true
                    self.listButton.isHidden = false
                    self.refreshButton.isHidden = false
                    self.refreshButton.backgroundColor = self.darkGreyColor
                }
            }
        })
    }
    
    //firstCollectionView
    
    func showFirstOrder(itemToShow : String) {
        count += 1
        
        self.itemToShow = itemToShow
        firstCollectionView.reloadData()
        
        
        mapView.addSubview(firstCollectionView)
        let height: CGFloat = CGFloat(35)
        firstCollectionView.backgroundColor = UIColor.clear
        firstCollectionView.frame = CGRect(x: 0, y: CGFloat(20), width: mapView.frame.width, height: height)
    
    }
    
    func showSecondOrder(itemToShow : String) {
        count += 1
        
        self.itemToShow = itemToShow
        
        secondCollectionView.reloadData()
        
        mapView.addSubview(secondCollectionView)
        let height: CGFloat = CGFloat(35)
        secondCollectionView.backgroundColor = UIColor.clear
        secondCollectionView.frame = CGRect(x: 0, y: CGFloat(65), width: mapView.frame.width, height: height)
    }
    
    func showThirdOrder(itemToShow : String) {
        count += 1
        
        self.itemToShow = itemToShow
        
        thirdCollectionView.reloadData()
        
        mapView.addSubview(thirdCollectionView)
        let height: CGFloat = CGFloat(35)
        thirdCollectionView.backgroundColor = UIColor.clear
        thirdCollectionView.frame = CGRect(x: 0, y: CGFloat(110), width: mapView.frame.width, height: height)
    }
    
    func hideFirstOrder(count: Int) {
        if (firstCollectionView.tag == 1) {
            self.count = count - 1
            if (self.count == -1) {
                self.firstCollectionView.removeFromSuperview()
            } else {
                self.itemToShow = self.firstImageName
                self.firstCollectionView.reloadData()
            }
        }
    }
    
    func hideSecondOrder(count: Int) {
        if (secondCollectionView.tag == 2) {
            self.count = count - 1
            if (self.count == -1) {
                self.secondCollectionView.removeFromSuperview()
            } else {
                self.itemToShow = self.firstImageName
                self.secondCollectionView.reloadData()
            }
        }
    }
    
    func hideThirdOrder(count: Int) {
        if (thirdCollectionView.tag == 3) {
            self.count = count - 1
            if (self.count == -1) {
                self.thirdCollectionView.removeFromSuperview()
            } else {
                self.itemToShow = self.firstImageName
                self.thirdCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 0) {
            if (count1 == 0) {
                return parentCategory.count
            } else if (count1 == 1) {
                return childCategory.count
            } else {
                return subchildCategory.count
            }
        } else if (collectionView.tag == 4) {
            return ordersCount
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView.tag == 0) {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else if (collectionView.tag == 4) {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView.tag == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
            
            //cell.contentView.backgroundColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 0.7)
            cell.contentView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
            
            if (count1 == 0) {
                cell.firstCategoryImageView.image = UIImage(named: imagesNames[indexPath.item])
                cell.firstCategoryLabel.text = parentCategory[indexPath.item].name
            } else if (count1 == 1) {
                cell.firstCategoryImageView.image = UIImage(named: "")
                cell.firstCategoryLabel.text = childCategory[indexPath.item].name
            } else {
                cell.firstCategoryImageView.image = UIImage(named: "")
                cell.firstCategoryLabel.text = subchildCategory[indexPath.item].name
            }
            
            return cell
        }
        
        if (collectionView.tag == 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! OrderCell
            
            if (self.count == 0) {
                cell.firstCategoryImageView.image = UIImage(named: self.itemToShow)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                self.firstImageName = self.itemToShow
                cell.firstCategoryImageView.isHidden = false
                cell.secondCategoryLabel.isHidden = true
                cell.thirdCategoryLabel.isHidden = true
                cell.fourthCategoryLabel.isHidden = true
                self.secondLabelName = ""
            }
            
            if (self.count == 1) {
                if (self.secondLabelName != "") {
                    cell.secondCategoryLabel.text = secondLabelName
                } else {
                    cell.secondCategoryLabel.text = itemToShow
                    self.secondLabelName = self.itemToShow
                    cell.secondCategoryLabel.isHidden = false
                }
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                cell.thirdCategoryLabel.isHidden = true
            }
            
            if (self.count == 2) {
                cell.thirdCategoryLabel.text = itemToShow
                cell.thirdCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
            }
            
            if (self.count == 3) {
                cell.fourthCategoryLabel.text = itemToShow + " тг"
                cell.fourthCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.fourthCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                self.count = -1
                self.itemToShow = ""
                self.firstImageName = ""
                self.secondLabelName = ""
            }
            
            return cell
        }
        
        if (collectionView.tag == 2) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! OrderCell
            
            if (self.count == 0) {
                cell.firstCategoryImageView.image = UIImage(named: self.itemToShow)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                self.firstImageName = self.itemToShow
                cell.firstCategoryImageView.isHidden = false
                cell.secondCategoryLabel.isHidden = true
                cell.thirdCategoryLabel.isHidden = true
                cell.fourthCategoryLabel.isHidden = true
                self.secondLabelName = ""
            }
            
            if (self.count == 1) {
                if (self.secondLabelName != "") {
                    cell.secondCategoryLabel.text = secondLabelName
                } else {
                    cell.secondCategoryLabel.text = itemToShow
                    self.secondLabelName = self.itemToShow
                    cell.secondCategoryLabel.isHidden = false
                }
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                cell.thirdCategoryLabel.isHidden = true
            }
            
            if (self.count == 2) {
                cell.thirdCategoryLabel.text = itemToShow
                cell.thirdCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
            }
            
            if (self.count == 3) {
                cell.fourthCategoryLabel.text = itemToShow + " тг"
                cell.fourthCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.fourthCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                self.count = -1
                self.itemToShow = ""
                self.firstImageName = ""
                self.secondLabelName = ""
            }
            
            return cell
        }
        
        if (collectionView.tag == 3) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId4, for: indexPath) as! OrderCell
            if (self.count == 0) {
                cell.firstCategoryImageView.image = UIImage(named: self.itemToShow)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                self.firstImageName = self.itemToShow
                cell.firstCategoryImageView.isHidden = false
                cell.secondCategoryLabel.isHidden = true
                cell.thirdCategoryLabel.isHidden = true
                cell.fourthCategoryLabel.isHidden = true
                self.secondLabelName = ""
            }
            if (self.count == 1) {
                if (self.secondLabelName != "") {
                    cell.secondCategoryLabel.text = secondLabelName
                } else {
                    cell.secondCategoryLabel.text = itemToShow
                    self.secondLabelName = self.itemToShow
                    cell.secondCategoryLabel.isHidden = false
                }
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
                cell.thirdCategoryLabel.isHidden = true
            }
            if (self.count == 2) {
                cell.thirdCategoryLabel.text = itemToShow
                cell.thirdCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
            }
            if (self.count == 3) {
                cell.fourthCategoryLabel.text = itemToShow + " тг"
                cell.fourthCategoryLabel.isHidden = false
                cell.thirdCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.secondCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.firstCategoryImageView.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                cell.fourthCategoryLabel.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                self.count = -1
                self.itemToShow = ""
                self.firstImageName = ""
                self.secondLabelName = ""
            }
            return cell
        }
        
        if (collectionView.tag == 4) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PriceCell
            
            //cell.contentView.backgroundColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 0.7)
            cell.contentView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        return cell
    }
    
    func showMainCategory() {
        if (count1 == 0) {
            parentCategory = UserModel.info().parent
            cancelButton.isHidden = true
        }
        var height: CGFloat = 0
        
        if (count1 == 0) {
            height = CGFloat(parentCategory.count * 55)
        } else if (count1 == 1) {
            height = CGFloat(childCategory.count * 55)
        } else if (count1 == 2) {
            height = CGFloat(subchildCategory.count * 55)
        }
        
        if (height >= 385) {
            height = 385
        }
        
        let width: CGFloat = mapView.frame.width - 90 - 20
        let y = mapView.frame.height - height - 50
        let x = mapView.frame.width - width - 45 - 10
        
        //            collectionView.frame = CGRect(x: x, y: window.frame.height, width: width, height: height)
        collectionView.frame = CGRect(x: x, y: y, width: width, height: height) //comment this if animations return
        //            UIView.animate(withDuration: 0.5, animations: {
        self.collectionView.frame = CGRect(x: x, y: y, width: width, height: height)
        transparentView.isHidden = false
        collectionView.reloadData()
    }
    
    func cancelOrderButtonPressed() {
        self.cancelButton.isHidden = true
        
        count1 = 0
        self.transparentView.isHidden = true
        
        //        UIView.animate(withDuration: 0.5) {
        if let window = UIApplication.shared.keyWindow {
            self.collectionView.frame = CGRect(x: window.frame.width/2 - self.collectionView.frame.width/2, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
        //        }
        
        priceTextField.isHidden = true
        okButton.isHidden = true
        
        if (self.ordersCount == 0) {
            hideFirstOrder(count: 0)
        } else if (self.ordersCount == 1) {
            hideSecondOrder(count: 0)
        } else if (self.ordersCount == 2) {
            hideThirdOrder(count: 0)
        }
        
        orderCreatedInCreateOrderVM(orderCreated: ordersCount)
    }
    
    func cancelButtonPressed() {
        self.count1 = self.count1 - 1
        
        if (count1 == 1) {
            childCategory = UserModel.info().parent[firstIndex].children
        }
        
        if (count1 == 2) {
            self.priceTextField.resignFirstResponder()
            self.priceTextField.text = ""
            self.priceTextField.isHidden = true
            self.okButton.isHidden = true
        }
        
        //        UIView.animate(withDuration: 0.5, animations: {
        if let window = UIApplication.shared.keyWindow {
            self.collectionView.frame = CGRect(x: window.frame.width/2 - self.collectionView.frame.width/2, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
        //        }) { (completed: Bool) in
        if (self.ordersCount == 0) {
            hideFirstOrder(count: self.count)
        } else if (self.ordersCount == 1) {
            hideSecondOrder(count: self.count)
        } else if (self.ordersCount == 2) {
            hideThirdOrder(count: self.count)
        }
        self.showMainCategory()
        //        }
    }
    
    func selectPrice() {
        priceTextField.isHidden = false
        okButton.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleDismissSecond()
        return true
    }
    
    func handleDismissSecond() {
        if (priceTextField.text != "") {
            priceTextField.resignFirstResponder()
            self.count1 = 0
            self.transparentView.isHidden = true
            
            self.cancelButton.isHidden = true
            
            if (self.ordersCount == 0) {
                showFirstOrder(itemToShow: self.priceTextField.text!)
            }
            else if (self.ordersCount == 1) {
                showSecondOrder(itemToShow: self.priceTextField.text!)
            } else {
                showThirdOrder(itemToShow: self.priceTextField.text!)
            }
            
            self.features.append(Features(feature: self.subchildCategory[self.lastIndex].id, price: Int(self.priceTextField.text!)!))
            
            self.priceTextField.text = ""
            self.ordersCount += 1
            
            orderCreatedInCreateOrderVM(orderCreated: ordersCount)
            
            priceTextField.isHidden = true
            okButton.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.tag == 0) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = UIColor(red: 194/255, green: 161/255, blue: 98/255, alpha: 0.7)
            
            //        UIView.animate(withDuration: 0.5, animations: {
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: window.frame.width/2 - self.collectionView.frame.width/2, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            //        }) { (completed: Bool) in
            
            self.cancelButton.isHidden = false
            
            if (self.ordersCount == 0) {
                if (self.count1 == 0) {
                    showFirstOrder(itemToShow: imagesNames[indexPath.item])
                    self.firstIndex = indexPath.item
                    childCategory = parentCategory[indexPath.item].children
                } else if (self.count1 == 1) {
                    showFirstOrder(itemToShow: self.childCategory[indexPath.item].name)
                    subchildCategory = childCategory[indexPath.item].children
                } else if (self.count1 == 2) {
                    showFirstOrder(itemToShow: self.subchildCategory[indexPath.item].name)
                }
            }
            else if (self.ordersCount == 1) {
                if (self.count1 == 0) {
                    showSecondOrder(itemToShow: imagesNames[indexPath.item])
                    self.firstIndex = indexPath.item
                    childCategory = parentCategory[indexPath.item].children
                } else if (self.count1 == 1) {
                    showSecondOrder(itemToShow: self.childCategory[indexPath.item].name)
                    subchildCategory = childCategory[indexPath.item].children
                } else if (self.count1 == 2) {
                    showSecondOrder(itemToShow: self.subchildCategory[indexPath.item].name)
                }
            } else {
                if (self.count1 == 0) {
                    showThirdOrder(itemToShow: imagesNames[indexPath.item])
                    self.firstIndex = indexPath.item
                    childCategory = parentCategory[indexPath.item].children
                } else if (self.count1 == 1) {
                    showThirdOrder(itemToShow: self.childCategory[indexPath.item].name)
                    subchildCategory = childCategory[indexPath.item].children
                } else if (self.count1 == 2) {
                    showThirdOrder(itemToShow: self.subchildCategory[indexPath.item].name)
                }
            }
            
            self.count1 += 1
            
            if (count1 < 3) {
                self.showMainCategory()
            } else {
                self.lastIndex = indexPath.item
                self.selectPrice()
            }
            //        }
        }
    }
    
    //end mainCollectionView
    
    func orderCreatedInCreateOrderVM(orderCreated: Int) {
        self.orderCreated = orderCreated
        if (orderCreated == 0) {
            showCategory = 1
        }
        
        if (orderCreated == 1) && (showCalendar == 1) {
            blackView.isHidden = false
            calendarSettingsView.isHidden = false
            datePicker.minimumDate = Date()
            showCalendar = 0
        }
        if (orderCreated != 0) {
            showButtons()
        }
        if (orderCreated == 3) {
            addButton.isEnabled = false
            addButton.backgroundColor = disabledGreyColor
        }
        
        categoryAlreadyShown = 0
    }
    
    func hideTopOrders() {
        if (ordersCount == 1) {
            firstCollectionView.isHidden = true
        } else if (ordersCount == 2) {
            firstCollectionView.isHidden = true
            secondCollectionView.isHidden = true
        } else if (ordersCount == 3) {
            firstCollectionView.isHidden = true
            secondCollectionView.isHidden = true
            thirdCollectionView.isHidden = true
        }
    }
    
    func showTopOrders() {
        if (ordersCount == 1) {
            firstCollectionView.isHidden = false
        } else if (ordersCount == 2) {
            firstCollectionView.isHidden = false
            secondCollectionView.isHidden = false
        } else if (ordersCount == 3) {
            firstCollectionView.isHidden = false
            secondCollectionView.isHidden = false
            thirdCollectionView.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension MapPartViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        viewController.tableCellBackgroundColor = UIColor.clear
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        
        searchLocationTextField.text = ""//"\(place.coordinate.latitude), \(place.coordinate.longitude)"
        //locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.choosenLocationLatitude = place.coordinate.latitude
        self.choosenLocationLongitude = place.coordinate.longitude
        
        self.locationAcceptButton.isEnabled = true
        self.locationAcceptButton.backgroundColor = darkGreyColor
        self.hideTopOrders()
        self.mapView.clear()
        self.mapView.camera = camera
        self.createMarker(latitude: choosenLocationLatitude, longitude: choosenLocationLongitude, imageName: "Item_On_Map")
        self.circle.map = mapView
        self.circle.position = CLLocationCoordinate2D(latitude: choosenLocationLatitude, longitude: choosenLocationLongitude)
        self.circle.radius = Double(tempRadius * 1000)
        UIView.animate(withDuration: 1, animations: {
            self.dismiss(animated: true, completion: nil)
            
        })
        //self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
        searchLocationTextField.isHidden = true
        searchLocationButton.isHidden = true
        locationAcceptButton.isHidden = true
        showButtons()
        showTopOrders()
        
        if (orderLocation == 1) {
            circle.radius = Double(choosenRadius * 1000)
        } else {
            locationButton.backgroundColor = darkGreyColor
        }
        
        searchChooseLocation = 0
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}
