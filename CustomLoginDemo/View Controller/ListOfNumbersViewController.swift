//
//  ListOfNumbersViewController.swift
//  CustomLoginDemo
//
//  Created by Arek Pichurski on 10/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase


class ListOfNumbersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    let cellId = "CheckNumberListItem"
    var numbersArrayId = [String]()
    var numbersArrayValue = [String]()
    var db =  Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func load(){
         db.collection("numbers").getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                 
                 for document in querySnapshot!.documents {
                    self.numbersArrayValue.append(document.data().first!.value as? String ?? "")
                    self.numbersArrayId.append(document.documentID)
                 }
                }
                self.tableView.reloadData()
             }
         }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.numbersArrayId.count)
        return self.numbersArrayValue.count
        
    }
    override func viewWillAppear(_ animated: Bool) {
        numbersArrayId.removeAll()
        numbersArrayValue.removeAll()
        load()
        self.tableView.reloadData()
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = numbersArrayValue[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            numbersArrayValue.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            db.collection("numbers").document(numbersArrayId[indexPath.row]).delete { (err) in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                }
            }
   
        }
    }

}
