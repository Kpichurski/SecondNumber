//
//  ListOfNumbersViewController.swift
//  CustomLoginDemo
//
//  Created by Arek Pichurski on 10/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase


class ListOfNumbersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellId = "CheckNumberListItem"
    var numbersArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        //tableView.reloadData()
        
    }
    func load(){
        let db = Firestore.firestore()
         db.collection("numbers").getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                 
                 for document in querySnapshot!.documents {
                     self.numbersArray.append(document.data().first!.value as? String ?? "677-888-999")
                     //print(self.numbersArray)
                    //
                 }
                self.tableView.reloadData()
             }
         }
    }
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.numbersArray.count)
        return self.numbersArray.count
        
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        print(self.numbersArray[indexPath.row])
        cell.textLabel?.text = self.numbersArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            numbersArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }

}
