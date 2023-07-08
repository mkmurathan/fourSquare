//
//  MapView.swift
//  fourSquareClone
//
//  Created by Murathan karagöz on 27.06.2023.
//

import UIKit
import MapKit
import Parse

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var choosenLatitude = ""
    var choosenLongitude = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "back", style: UIBarButtonItem.Style.done, target: self, action: #selector(backButtonClicked))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = placeClass.sharedİnstance.placeName
            annotation.subtitle = placeClass.sharedİnstance.placeType
            
            self.mapView.addAnnotation(annotation)
           
            placeClass.sharedİnstance.placeLatitude = String(coordinates.latitude)
            placeClass.sharedİnstance.placeLongitude = String(coordinates.longitude)
        }
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    @objc func backButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    

    @objc func saveButtonClicked(){
        
        let placeClass = placeClass.sharedİnstance
        
        let object = PFObject(className: "places")
       
        object["name"] = placeClass.placeName
        object["type"] = placeClass.placeType
        object["love"] = placeClass.placeLove
        object["latitude"] = placeClass.placeLatitude
        object["longitude"] = placeClass.placeLongitude
        
        if let imageData = placeClass.placeİmage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
            
            
        object.saveInBackground { success, error in
            if error != nil {
                let alert = UIAlertController(title: "error", message: "is not save this data", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "backTableVc", sender: nil)
            }
        }
            
            
            
    }
    
   

}
