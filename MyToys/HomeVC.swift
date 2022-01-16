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
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    @objc func addButtonClicked (){
        performSegue(withIdentifier: "toDetailsVCS", sender: nil)
    }
}

