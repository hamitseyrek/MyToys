//
//  ViewController.swift
//  MyToys
//
//  Created by Hamit Seyrek on 16.01.2022.
//

import UIKit
import CoreData

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toysTableView: UITableView!
    
    //variables
    var nameArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for TableView
        toysTableView.delegate = self
        toysTableView.dataSource = self
        getData()
        // add Add icon
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @objc func getData() {
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
        fetchRequest.returnsObjectsAsFaults = false // use cache
        do {
           let results =  try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.toysTableView.reloadData()
            }
        }catch{
            print("There is an error")
        }
        
    }
    
    // click Add button
    @objc func addButtonClicked (){
        performSegue(withIdentifier: "toDetailsVCS", sender: nil)
    }
    
    // Tableview operations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = nameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

