//
//  ViewController.swift
//  Searching Locations
//
//  Created by Felipe Ignacio Zapata Riffo on 11-08-21.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation
class ViewController: UIViewController, SearchViewControllerDelegate {
    
    
    
    let mapView = MKMapView()
    let panel = FloatingPanelController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
         
        let searchVC = Searching_Locations.SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame =  view.bounds
        
        title =  "Search Location"
        
    }

 
    
    func SearchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        guard let coordinates = coordinates else {
            return
        }
        panel.move(to: .tip, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates,
                                             span: MKCoordinateSpan(latitudeDelta: 0.5,
                                                                    longitudeDelta: 0.5)),
                          animated: true)
//        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
    }
}

