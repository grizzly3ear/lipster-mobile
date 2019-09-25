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
    
    var pinView : MKAnnotationView!
    
    var stores = [Store]()
    func createStoreArray() -> [Store] {
        let store1 : Store = Store(storeLogoImage: UIImage(named: "Sephora_black_logo")!, storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok" ,storeLatitude : 100.493872 , storeLongitude : 13.652383)
        let store2 : Store = Store(storeLogoImage: UIImage(named: "Sephora_black_logo")!, storeName: "Sephora ", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700" , storeLatitude : 100.493879 , storeLongitude : 13.652389)
        let store3 : Store = Store(storeLogoImage: UIImage(named: "nopic")!, storeName: "Etude House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150" , storeLatitude : 100.493875 , storeLongitude : 13.652385)
        
        return [store1 , store2 , store3]
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    let padding: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stores = self.createStoreArray()
        
        mapCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
       
        self.locationManager.requestWhenInUseAuthorization()
        initCoreLocationDelegate()
        initMapViewDelegate()
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
//        let annotationIcon = CustomePinAnnotation()
//        annotationIcon.pinImage = "pin"
//        mapView.addAnnotation(annotationIcon)
//
        
    }
}

extension NearByViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCollectionViewCell", for: indexPath) as! NearByCollectionViewCell
        
       // cell.image.sd_setImage(with: URL(string: trendCollections[indexPath.item].image ?? ""), placeholderImage: UIImage(named: "nopic")!)
        cell.storeLogoImage.layer.cornerRadius = 8.0
        cell.storeLogoImage.contentMode = .scaleAspectFill
        cell.storeLogoImage.clipsToBounds = true
        cell.layer.cornerRadius = 8
        
        let store = stores[indexPath.item]
        cell.setStore(store: store )
        return cell
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
    //MARK: - MapKit
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "ProfilePinView"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView.canShowCallout = true
        pinView.isDraggable = true
        pinView.image = UIImage(named: "pin_lipstick")
        
        return pinView
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        if newState == MKAnnotationView.DragState.ending {
            if let coordinate = view.annotation?.coordinate {
                //  let coordinate = view.annotation?.coordinate
                print(coordinate.latitude)
            
                view.dragState = MKAnnotationView.DragState.none
                
            }
        }
    }
    
    @objc func mapView(_ rendererFormapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
        
    }

}

