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
    @IBOutlet weak var saveButton: UIButton!
    
    //variables
    var selectedToyID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedToyID != nil {
            saveButton.isHidden = true
            //CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
            let idString = selectedToyID?.uuidString
            //query
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        if let age = result.value(forKey: "age") as? Int {
                            ageText.text = String(age)
                        }
                        if let type = result.value(forKey: "type") as? String {
                            typeText.text = type
                        }
                        if let color = result.value(forKey: "color") as? String {
                            colorText.text = color
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            toyImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }catch{
                print("There is an error here!!!")
            }
            
        } else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
        }
        
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
                            self.saveButton.isEnabled = true
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
        
        // send notify that refresh TableView to HomeVC
        //NotificationCenter allows us to share any data between viewController
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
