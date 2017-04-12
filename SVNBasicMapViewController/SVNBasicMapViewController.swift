//
//  SVNBasicMapViewController.swift
//  Tester
//
//  Created by Aaron Dean Bikis on 4/11/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit
import MapKit
import SVNModalViewController
import SVNMaterialButton
import CoreLocation
import SVNTheme

public protocol SVNBasicMapViewControllerDelegate: class {
    func SVNBasicMapViewControllerDid(confirm location: CLLocationCoordinate2D)
}

open class SVNBasicMapViewController: SVNModalViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    public weak var delegate: SVNBasicMapViewControllerDelegate!
    
    private lazy var largeButton: SVNMaterialButton  = {
        let button = SVNMaterialButton(layoutInBottomOfContainer: self.view.bounds, color: self.theme.primaryDialogColor)
        button.addTarget(self, action: #selector(SVNBasicMapViewController.confirmLocation(_:)), for: .touchUpInside)
        button.setTitle(self.model.confirmButtonTitle, for: .normal)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView(frame: self.view.bounds)
        map.delegate = self
        return map
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    public var defaultLocationAuthorizationRequestStatus = CLAuthorizationStatus.authorizedWhenInUse
    
    public var shouldTrackUser = true
    
    private var firstLoad = true
    
    public var model: SVNBasicMapViewModel!
    
    public init(theme: SVNTheme?, model: SVNBasicMapViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
        self.model = model == nil ? SVNBasicMapVM() : model!
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, theme: SVNTheme?, model: SVNBasicMapViewModel?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
        self.model = model == nil ? SVNBasicMapVM() : model!
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported use init(theme: model:)")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.largeButton)
        self.addModalSubviews()
        self.requestLocationAuth()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .denied:
            self.requestLocationAuth()
        case .notDetermined:
            self.requestLocationAuth()
        case .restricted:
            self.requestLocationAuth()
        }
    }
    
    private func requestLocationAuth(){
        if defaultLocationAuthorizationRequestStatus == .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.requestAlwaysAuthorization()
    }
    
     public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else { return }
        self.setRegion()
    }
    
    private func setRegion(){
        if firstLoad {
            if shouldTrackUser {
                let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.015, 0.015))
                self.mapView.setRegion(region, animated: true)
                return
            }
            return
        }
        firstLoad = true
    }
    
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.setRegion()
    }
    
    public func confirmLocation(_ sender: Any){
        self.delegate.SVNBasicMapViewControllerDid(confirm: self.mapView.userLocation.coordinate)
    }
}
