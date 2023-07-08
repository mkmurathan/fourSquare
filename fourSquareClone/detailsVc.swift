//
//  detailsVc.swift
//  fourSquareClone
//
//  Created by Murathan karagöz on 27.06.2023.
//

import UIKit
import MapKit
import Parse
class detailsVc: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailsİmage: UIImageView!
    
    @IBOutlet weak var detailsName: UILabel!
    
    @IBOutlet weak var detailsType: UILabel!
    
    @IBOutlet weak var detailsLove: UILabel!
    
    @IBOutlet weak var detailsMap: MKMapView!
    
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDataFromParse()
        detailsMap.delegate = self
    }
    
    
    
    
    
    func getDataFromParse(){
        let query = PFQuery(className: "places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            
            if error != nil{
                
                
            }else{
                if objects != nil{
                    let chosenPlaceObject = objects![0]
                    
                    if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                        self.detailsName.text = placeName
                    }
                    if let placetype = chosenPlaceObject.object(forKey: "type") as? String{
                        self.detailsType.text = placetype
                    }
                    if let placelove = chosenPlaceObject.object(forKey: "love") as? String{
                        self.detailsLove.text = placelove
                    }
                    
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                        if let placeLatitudeDouble = Double(placeLatitude){
                            self.chosenLatitude = placeLatitudeDouble
                        }
                    }
                   
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                        if let placeLongitudeDouble = Double(placeLongitude){
                            self.chosenLongitude = placeLongitudeDouble
                        }
                    }
                    
                    if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                        imageData.getDataInBackground { data, error in
                            if error == nil{
                                self.detailsİmage.image = UIImage(data: data!)
                            }
                        }
                    }
                   
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: location, span: span)
                    
                    self.detailsMap.setRegion(region, animated: true)
                    
                    let anotation = MKPointAnnotation()
                    anotation.coordinate = location
                    anotation.title = self.detailsName.text!
                    anotation.subtitle = self.detailsType.text!
                    self.detailsMap.addAnnotation(anotation)
                    
                }
            }
        }
    }

    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reUserId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reUserId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reUserId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapİtem = MKMapItem(placemark: mkPlacemark)
                        mapİtem.name = self.detailsName.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapİtem.openInMaps(launchOptions : launchOptions)
                        
                    }
                }
            }
            
        }
    }
    
    
    

}
