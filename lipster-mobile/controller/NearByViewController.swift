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

class NearByViewController: UIViewController   {
    
    var pinView : MKAnnotationView!
    
    var index = 1
    var stores = [Store]()
    func createStoreArray() -> [Store] {
        let store1 : Store = Store(storeLogoImage: UIImage(named: "Sephora_black_logo")!, storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok" ,storeLatitude : 37.755084 , storeLongitude : -122.416200 , storePhoneNumber : "062-875-9836")
        let store2 : Store = Store(storeLogoImage: UIImage(named: "Sephora_black_logo")!, storeName: "Sephora ", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700" , storeLatitude : 37.755435 , storeLongitude : -122.400100 , storePhoneNumber : "062-875-9836")
        let store3 : Store = Store(storeLogoImage: UIImage(named: "nopic")!, storeName: "Etudess House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150" , storeLatitude : 37.746833 , storeLongitude : -122.416412, storePhoneNumber : "062-875-9836")
        let store4 : Store = Store(storeLogoImage: UIImage(named: "nopic")!, storeName: "Etude House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150" , storeLatitude : 37.778836 , storeLongitude : -122.416411, storePhoneNumber : "062-875-9836")
        
        return [store1 , store2 , store3 , store4]
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    let padding: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.minimumLineSpacing = 10
        mapCollectionView.delegate = self
        self.stores = self.createStoreArray()
        
        mapCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
       
        self.locationManager.requestWhenInUseAuthorization()
        initCoreLocationDelegate()
        initMapViewDelegate()
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
     //   mapCollectionView.scrollToItem(at:  , at: .top, animated: false)
    }
}

extension NearByViewController : UICollectionViewDelegate , UICollectionViewDataSource  {
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(stores.count - 1, index))
        return safeIndex
    }
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
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        print("click")
        if let annotationTitle = view.annotation?.title
        {
            let i = stores.firstIndex(where: { $0.name == annotationTitle })
            mapCollectionView.scrollToItem(at: IndexPath(item: i!, section: 0), at: .centeredHorizontally, animated: true)
            print("User tapped on annotation with title: \(annotationTitle!)")
//              mapCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        for (index, store) in stores.enumerated() {
            let coor = CLLocation(latitude: store.latitude, longitude: store.longitude).coordinate
            let storeAnnotation = MKPointAnnotation()
            
            storeAnnotation.coordinate = coor
            storeAnnotation.title = "\(store.name)"
            
            mapView.addAnnotation(storeAnnotation)
        }
        
//        //mapCollectionView.tag = 1
//        if storeAnnotation.title {
//        } else {
//            mapCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//
//        }
        
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
        pinView.tag = index
        index += 1
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

