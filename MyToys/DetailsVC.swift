//
//  DetailsVC.swift
//  MyToys
//
//  Created by Hamit Seyrek on 16.01.2022.
//

import UIKit
import PhotosUI
import Photos
import CoreData

class DetailsVC: UIViewController,PHPickerViewControllerDelegate{
    
    @IBOutlet weak var toyImageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var colorText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard when click in viewcontroller
        let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(closeKeyboard)
        
        // select Image Gesture Recognizer
        toyImageView.isUserInteractionEnabled = true
        let selectImage2 = UITapGestureRecognizer(target: self, action: #selector(selectImage1))
        toyImageView.addGestureRecognizer(selectImage2)
        
        
    }
    
    //hide Keyboard
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    // select Image
    var myPicker : PHPickerViewController?
    @objc func selectImage1(){
        print("buradayım")
        var config = PHPickerConfiguration()
        
        config.filter = .images
        self.myPicker = PHPickerViewController(configuration: config)
        self.myPicker!.delegate = self
        present(self.myPicker!, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        // unpack the selected items
        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if  error != nil {
                        return
                    } else if let picture = image as? UIImage {
                        DispatchQueue.main.sync {
                               self.toyImageView.image = picture
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newToy = NSEntityDescription.insertNewObject(forEntityName: "Toys", into: context)
        
        //Attributes
        newToy.setValue(nameText.text!, forKey: "name")
        if let age = Int(ageText.text!){
            newToy.setValue(age, forKey: "age")
        }
        newToy.setValue(typeText.text!, forKey: "type")
        newToy.setValue(colorText.text!, forKey: "color")
        newToy.setValue(UUID(), forKey: "id")
        if let data = toyImageView.image?.jpegData(compressionQuality: 0.5) {
            newToy.setValue(data, forKey: "image")
        }
        
        //save to CoreData
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        self.navigationController?.popViewController(animated: true)
    }
}
