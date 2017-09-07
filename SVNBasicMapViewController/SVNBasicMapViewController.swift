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
import CoreLocation
import SVNMaterialButton
import SVNTheme

open class SVNBasicMapViewController: SVNModalViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  private lazy var largeButton: SVNMaterialButton  = {
    
    let button = SVNMaterialButton(frame: CGRect(x: SVNMaterialButton.standardPadding, y: self.view.bounds.height - SVNMaterialButton.standardHeight + SVNMaterialButton.bottomPadding,
                                                 width: self.view.bounds.width - SVNMaterialButton.standardPadding * 2, height: SVNMaterialButton.standardHeight), viewModel: self.buttonViewModel)
    button.addTarget(self, action: #selector(SVNBasicMapViewController.confirmLocation(_:)), for: .touchUpInside)
    button.setTitle(self.model.confirmButtonTitle, for: .normal)
    return button
  }()
  
  private lazy var mapView: MKMapView = {
    let map = MKMapView(frame: self.view.bounds)
    map.delegate = self
    map.showsUserLocation = true
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
  
  public var model: SVNBasicMapViewModel
  
  public var buttonViewModel: SVNMaterialButtonViewModel
  
  public var basicMapDidReturn: ((CLLocationCoordinate2D) -> Void)?
  
  public init(theme: SVNTheme?, model: SVNBasicMapViewModel?, buttonViewModel: SVNMaterialButtonViewModel = SVNMaterialButtonViewModel_Default()) {
    self.model = model == nil ? SVNBasicMapVM() : model!
    self.buttonViewModel = buttonViewModel
    super.init(nibName: nil, bundle: nil)
    self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
  }
  
  public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, theme: SVNTheme?, model: SVNBasicMapViewModel?, buttonViewModel: SVNMaterialButtonViewModel = SVNMaterialButtonViewModel_Default()) {
    self.buttonViewModel = buttonViewModel
    self.model = model == nil ? SVNBasicMapVM() : model!
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported use init(theme: model:)")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.mapView)
    self.view.addSubview(self.largeButton)
    self.requestLocationAuth()
    self.addModalSubviews()
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
    self.locationManager.stopUpdatingLocation()
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
    self.basicMapDidReturn?(self.mapView.userLocation.coordinate)
  }
}
