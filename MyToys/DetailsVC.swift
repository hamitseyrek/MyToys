//
//  DetailsVC.swift
//  MyToys
//
//  Created by Hamit Seyrek on 16.01.2022.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var toyImageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var colorText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonClick(_ sender: Any) {
        
    }
}
