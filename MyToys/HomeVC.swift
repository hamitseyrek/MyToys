//
//  ViewController.swift
//  MyToys
//
//  Created by Hamit Seyrek on 16.01.2022.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var toysTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // add Add icon
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        // hide keyboard when click in viewcontroller
        let closeKeyboard = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(closeKeyboard)
    }
    
    //hide Keyboard
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    // click Add button
    @objc func addButtonClicked (){
        performSegue(withIdentifier: "toDetailsVCS", sender: nil)
    }
}

