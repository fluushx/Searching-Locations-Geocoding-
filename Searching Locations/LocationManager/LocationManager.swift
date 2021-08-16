//
//  LocationManager.swift
//  Searching Locations
//
//  Created by Felipe Ignacio Zapata Riffo on 13-08-21.
//

import Foundation
import CoreLocation

struct Location {
    let title:String
    let coordinates:CLLocationCoordinate2D?
}

class LocationManager:NSObject {
     static let shared = LocationManager()
    
   
    
    public func findLocation(with query:String, complation: @escaping (([Location]) -> Void)){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query, completionHandler: { places, error in
            guard let places = places, error == nil else {
                return
             complation([])
            }
            let models: [Location] = places.compactMap({ places in
                var name = ""
                if let locationName = places.name{
                    name += locationName
                }
                if let adminRegion = places.administrativeArea{
                    name += ", \(adminRegion)"
                }
                if let locality = places.locality{
                    name += ", \(locality)"
                }
                print("\n \(places)")
                let results = Location(title: name, coordinates: places.location?.coordinate)
                return results
            })
            complation(models)
        })
    }
}
