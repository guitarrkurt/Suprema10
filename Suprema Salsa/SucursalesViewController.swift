//
//  UbicacionViewController.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 08/11/15.
//  Copyright © 2015 miguel mexicano. All rights reserved.
//

import UIKit
import MapKit

class SucursalesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ubicacion: CLLocationCoordinate2D =  CLLocationCoordinate2DMake(34.0219, -118.4814)
    var span : MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapa.delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        if CLLocationCoordinate2DIsValid (ubicacion) {
            mapa.setRegion(MKCoordinateRegion(center: ubicacion, span: span), animated: true)
        }
        
        
        annotation.coordinate = ubicacion
        annotation.title = "Santa Monica, CA"
        annotation.subtitle = "programadores-ios.net"
        mapa.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let reusarId = "anotacion"
        
        var anotacionView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusarId)
        if anotacionView == nil {
            anotacionView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusarId)
            anotacionView!.image = UIImage(named:"mascota")
            anotacionView!.canShowCallout = true
        }
        else {
            
            anotacionView!.annotation = annotation
        }
        
        return anotacionView
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
