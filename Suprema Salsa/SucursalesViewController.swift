//
//  UbicacionViewController.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 08/11/15.
//  Copyright © 2015 miguel mexicano. All rights reserved.
//

import UIKit
import MapKit
class Sucursal: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
class SucursalesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ubicacion: CLLocationCoordinate2D =  CLLocationCoordinate2DMake(34.0219, -118.4814)
    var span : MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Slide Out Menu
        if(self.revealViewController() != nil){
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 19.008896, longitude: -98.248442)
        centerMapOnLocation(initialLocation)
        
        let LaPaz = Sucursal(title: "La Suprema Salsa Sucursal La Paz", coordinate: CLLocationCoordinate2D(latitude: 19.058896, longitude: -98.232442), info: "La Suprema Salsa La Paz")
        
        let LaVista = Sucursal(title: "La Suprema Salsa Sucursal La Vista", coordinate: CLLocationCoordinate2D(latitude: 19.013366, longitude: -98.258463), info: "La Suprema Salsa Sucursal La Vista")
        
        let ZocaloPuebla = Sucursal(title: "La Suprema Salsa Sucursal Zocalo Puebla", coordinate: CLLocationCoordinate2D(latitude: 19.043548, longitude: -98.197194), info: "La Suprema Salsa Sucursal Zocalo Puebla")
        
        let UDLA = Sucursal(title: "La Suprema Salsa Sucursal UDLA", coordinate: CLLocationCoordinate2D(latitude: 19.051156, longitude: -98.283516), info: "La Suprema Salsa Sucursal UDLA")
        
        let LomasDeAngelopolis = Sucursal(title: "La Suprema Salsa Sucursal Lomas De Angelopolis", coordinate: CLLocationCoordinate2D(latitude: 19.000197, longitude: -98.261075), info: "La Suprema Salsa Sucursal Lomas De Angelopolis")
        
        mapView.addAnnotations([LaPaz, LaVista, ZocaloPuebla, UDLA, LomasDeAngelopolis])
    }
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        regionRadius * 10.0, regionRadius * 10.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "Sucursal"
        
        // 2
        if annotation.isKindOfClass(Sucursal.self) {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let sucursal = view.annotation as! Sucursal
        let placeName = sucursal.title
        let placeInfo = sucursal.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        
        
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

}
