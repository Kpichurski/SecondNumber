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
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    let cellId = "CheckNumberListItem"
    var numbersArrayId = [String]()
    var numbersArrayValue = [String]()
    var db =  Firestore.firestore()
    var numberToEditId:String?
    var numberToEditValue:String?
    var currentUserId = Auth.auth().currentUser?.uid
    @IBOutlet weak var navigationButtons: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        db = Firestore.firestore()
        db.collection("numbers")
            .whereField("IsActive", isEqualTo: true)
            //.whereField("IsOccupied", isEqualTo: false)
            .whereField("UserId", isEqualTo: self.currentUserId ?? "")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.numbersArrayId.removeAll()
                    self.numbersArrayValue.removeAll()
                    for document in querySnapshot!.documents {
                        self.numbersArrayValue.append(document.get("Number") as! String)
                        self.numbersArrayId.append(document.documentID)
                    }
                    self.tableView.reloadData()
                    self.changeAddNavigationButtonState()
                 }
                print(self.numbersArrayValue)
                         self.tableView.reloadData()
                }
                
                
        }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //var numberToMove = numbersArrayValue[sourceIndexPath.row]
        //numberToMove.insert(numberToMove, at: IndexPath.row)
        //swap(&numbersArrayValue[sourceIndexPath.row], &numbersArrayValue[destinationIndexPath.row])
        //tableView.reloadData()
    }
    @IBAction func editTapped(_ sender: Any) {
        if(tableView.isEditing == true)
        {
            tableView.isEditing = false
            editButton.title = "Edit"
            addButton.isEnabled = true
        }
        else {
            tableView.isEditing = true
            editButton.title = "Done"
            addButton.isEnabled = false
        }
        
    }
    func changeAddNavigationButtonState(){
        
        if(numbersArrayValue.count > 2){
            addButton.isEnabled = false
        }
        else {
          addButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.numbersArrayId.count)
        return self.numbersArrayValue.count
        
    }
    
    @IBAction func addTapped(_ sender: Any){
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
        
        if segue.identifier == "toAddNumber" {
            let editNumberPopUp = segue.destination as! EditNumberViewController
            editNumberPopUp.doneSaving = {[weak self] in
                self?.load()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        load()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = numbersArrayValue[indexPath.row]
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "dot_green")
        imageView.frame = CGRect(x:7,y:18,width:5,height:5)
        cell.addSubview(imageView)
//        cell.imageView?.image = #imageLiteral(resourceName: "dot_green")
//
//        cell.imageView?.frame = CGRect(x:5,y:5,width:5,height:5)
//        cell.addSubview(<#T##view: UIView##UIView#>)
//        cell.imageView?.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//        UIViewAutoresizingFlexibleWidth;

//        let highlightedImage = UIImage(named: "dot_red")
//        cell.imageView?.highlightedImage = highlightedImage
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
        edit.image = UIImage(named: "edit.png")
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete"){(action, view, nil ) in
            self.numbersArrayValue.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            self.changeAddNavigationButtonState()
            self.db.collection("numbers").document(self.numbersArrayId[indexPath.row]).updateData(["UserId": ""]) { (err) in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                }
            }
        }
        delete.image = UIImage(named: "delete.png")
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
