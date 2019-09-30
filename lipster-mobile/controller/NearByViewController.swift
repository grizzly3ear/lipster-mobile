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
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

class NearByViewController: UIViewController   {
    
    var pinView : MKAnnotationView!
    
    var index = 1
    var stores = [Store]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myCoorButton: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    let padding: CGFloat = 20.0
    
    let storeDataPipe = Signal<[Store], NoError>.pipe()
    var storeDataObserver: Signal<[Store], NoError>.Observer?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.minimumLineSpacing = 10
        mapCollectionView.delegate = self
        initReactiveStoreData()
        fetchData()
        
        mapCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
       
        self.locationManager.requestWhenInUseAuthorization()
        initCoreLocationDelegate()
        initMapViewDelegate()
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        myCoorButton.layer.cornerRadius = 5.0
        myCoorButton.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 2, scale: true)
    }
    
    @IBAction func findMyCoor(_ sender: Any) {
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    
    func fetchData() {
        StoreRepository.fetchAllStore { (response) in
            self.storeDataPipe.input.send(value: response)
        }
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

        cell.storeLogoImage.layer.cornerRadius = 8.0
        cell.storeLogoImage.contentMode = .scaleAspectFill
        cell.storeLogoImage.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 2.0, scale: true)
        
        let store = stores[indexPath.row]
        print(indexPath.row)
        print(store.name)
        cell.setStore(store: store )
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let store = stores[indexPath.item]
        let coor = CLLocation(latitude: store.latitude, longitude: store.longitude).coordinate
        
        mapView.setCenter(coor, animated: true)
    
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

        if let annotationTitle = view.annotation?.title
        {
            let i = stores.firstIndex(where: { $0.name == annotationTitle })
            mapCollectionView.scrollToItem(at: IndexPath(item: i!, section: 0), at: .centeredHorizontally, animated: true)

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

extension NearByViewController {
    func initReactiveStoreData() {
        storeDataObserver = Signal<[Store], NoError>.Observer(value: { (stores) in
            self.stores = stores
            print(stores)
            self.mapCollectionView.reloadData()
            self.mapCollectionView.setNeedsLayout()
            self.mapCollectionView.layoutIfNeeded()
        })
        storeDataPipe.output.observe(storeDataObserver!)
    }
}
