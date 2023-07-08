//
//  ViewController.swift
//  fourSquareClone
//
//  Created by Murathan karagöz on 22.06.2023.
//

import UIKit
import Parse

class signUpVc: UIViewController {
    
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    
    func makeAlert(titleİnput : String, massageİnput : String){
        let alert = UIAlertController(title: titleİnput, message: massageİnput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
            let parseObject = PFObject(className: "cars")
            parseObject ["name"] = ""
            parseObject ["model"] = ""
            parseObject.saveInBackground { (success, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "error not found")
                }else{
                    print("uploaded")
                }
            }
        
        
      
        let query = PFQuery(className: "cars")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription ?? "error not found")
            }else{
                print(objects)
            }
        }
        */
        
        
        
    }

    @IBAction func signClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                
                if error != nil{
                    self.makeAlert(titleİnput: "ok", massageİnput: "username/password !!!!!")
                }else{
                    self.performSegue(withIdentifier: "toPlacesVc", sender: nil)
                    
                }
            }
            
            
            
        }
    }
    
    

    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleİnput: "ok", massageİnput: error?.localizedDescription ?? "error?!")
                }else{
                    self.performSegue(withIdentifier: "toPlacesVc", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleİnput: "error", massageİnput: "username / password is emtp please enter !!")
        }
        
    }
    
    
    
    
    
}

