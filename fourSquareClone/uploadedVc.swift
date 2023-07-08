//
//  uploadedVc.swift
//  fourSquareClone
//
//  Created by Murathan karagöz on 27.06.2023.
//

import UIKit

class uploadedVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    @IBOutlet weak var loveText: UITextField!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseİmage))
        image.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        
        if nameText.text != "" && loveText.text != "" && placeTypeText.text != "" && image.image != nil {
           
            let placeClass = placeClass.sharedİnstance
            
            placeClass.placeName = nameText.text!
            placeClass.placeType = placeTypeText.text!
            placeClass.placeLove = loveText.text!
            placeClass.placeİmage = image.image!
            
            performSegue(withIdentifier: "toMapVc", sender: nil)
            
        }else {
            let alert = UIAlertController(title: "error", message: "text are emty", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @objc func chooseİmage (){
      let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
