//
//  MapViewController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/3.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.showsTraffic = true
        mapView.showsCompass = true
        mapView.showsScale = true
        
        //地址轉換座標後標記在地圖上
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(restaurant.location) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                //取得第一個地點標記
                let placemark = placemarks[0]
                //加上標記
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //顯示標記
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        //Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
//        annotationView?.glyphText = "  "
        annotationView?.markerTintColor = UIColor.orange
        annotationView?.glyphImage = UIImage(systemName: "arrowtriangle.down.circle")
        
        return annotationView
    }
}
