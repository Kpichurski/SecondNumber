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
    var numberToEditId:String?
    var numberToEditValue:String?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func load(){
        self.numbersArrayId.removeAll()
        self.numbersArrayValue.removeAll()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditNumber" {
            let editNumberPopUp = segue.destination as! EditNumberViewController
            editNumberPopUp.numberToEditId = self.numberToEditId
            editNumberPopUp.numberToEditValue = self.numberToEditValue
            editNumberPopUp.doneSaving = {[weak self] in
                self?.load()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = numbersArrayValue[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .destructive, title: "Edit"){(action, view,
            actionPerformed: (Bool) -> () ) in
            self.numberToEditId = self.numbersArrayId[indexPath.row]
            self.numberToEditValue = self.numbersArrayValue[indexPath.row]
            self.performSegue(withIdentifier: "toEditNumber", sender: nil)
            actionPerformed(true)
        }
         edit.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete"){(action, view, nil ) in
            self.numbersArrayValue.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            self.db.collection("numbers").document(self.numbersArrayId[indexPath.row]).delete { (err) in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                }
            }
        }
            delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return UISwipeActionsConfiguration(actions: [delete])
    }

}
