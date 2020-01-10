//
//  ViewController.swift
//  Day3
//
//  Created by Mac on 2020-01-10.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import  MapKit
class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager()
    
    let places = Place.getPlaces()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapview.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        addAnnotation()
        addPlayLine()
        addPolygon()
    }
    func addAnnotation()  {
        mapview.delegate = self
        mapview.addAnnotations(places)
        let overlays = places.map { (MKCircle(center: $0.coordinate, radius: 1000)) }
        mapview.addOverlays(overlays)
    }
    func addPlayLine(){
        let locations = places.map { $0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapview.addOverlay(polyline)
    }
    
    func  addPolygon()  {
        var locations = places.map { $0.coordinate }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        mapview.addOverlay(polygon)
    }
}

extension ViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation{
            return nil
            
        }else {
            
            let annotationView = mapview.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)


            return annotationView
        }
    }
    // this function is needed tp add overlays
    
    func mapView(_ mapView: MKMapView, rendererFor overlay : MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle{
        let rendere = MKCircleRenderer(overlay: overlay)
        rendere.fillColor = UIColor.black.withAlphaComponent(0.5)
        rendere.strokeColor = UIColor.green
        rendere.lineWidth = 2
        return rendere
    }
        else if overlay is MKPolyline{
            let rendere  = MKPolylineRenderer(overlay: overlay)
            rendere.strokeColor = UIColor.blue
            rendere.lineWidth = 3
            return rendere
        }
        else if overlay is MKPolygon{
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
        let alertController = UIAlertController(title: "Welcome to \(title)", message: "You've selected \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
