//
//  NearByViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 10/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearByViewController: UIViewController {

    @IBOutlet weak var storeLogoImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storehours: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    
    func setStore(store: Store) {
        //storeLogoImage.sd_setImage(with: URL(string: store.storeLogoImage), placeholderImage: UIImage(named: "nopic"))
        storeLogoImage.image = store.storeLogoImage
        storeName.text = store.storeName
        storehours.text = store.storeHours
        storeAddress.text = store.storeAddress
    }
    
    var stores = [Store]()
    func createStoreArray() -> [Store] {
        let store1 : Store = Store(storeLogoImage: UIImage(named: "nopic")!, storeName: "Sephora CentralPlaza Pinklao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700")
        let store2 : Store = Store(storeLogoImage: UIImage(named: "nopic")!, storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok")
        
        
        return [store1 , store2]
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stores = self.createStoreArray()
        
        self.locationManager.requestWhenInUseAuthorization()
        initCoreLocationDelegate()
        initMapViewDelegate()
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
}

extension NearByViewController: CLLocationManagerDelegate {
    func initCoreLocationDelegate() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension NearByViewController: MKMapViewDelegate {
    func initMapViewDelegate() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Beauty Buffet"
        mapView.addAnnotation(annotation)
    }
}
