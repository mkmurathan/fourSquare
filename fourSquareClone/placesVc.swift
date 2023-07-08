//
//  placesVc.swift
//  fourSquareClone
//
//  Created by Murathan karagöz on 26.06.2023.
//

import UIKit
import Parse
class placesVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(rightButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.undo, target: self, action: #selector(logOutButton))
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromParse()
    }
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                let alert = UIAlertController(title: "error", message: "issue in data", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                if objects != nil{
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
   
    @objc func rightButton(){
        performSegue(withIdentifier: "uploadVc", sender: self)
    }
   
    @objc func logOutButton(){
        PFUser.logOutInBackground()
        performSegue(withIdentifier: "toSignUpVc", sender: nil)
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
       cell.textLabel?.text = placeNameArray[indexPath.row]
       return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsVc" {
            let destinationVC = segue.destination as! detailsVc
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "detailsVc", sender: nil)
    }
    
    
}
