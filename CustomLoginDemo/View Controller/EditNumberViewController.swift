//
//  EditNumberViewController.swift
//  CustomLoginDemo
//
//  Created by Arek Pichurski on 11/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
class EditNumberViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var genereateButton: UIButton!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    var db =  Firestore.firestore()
    var doneSaving: (()->())?
    
    var numberToEditId: String?
    var numberToEditValue:String?
    var numbersArrayValue:[String] = []
    var numbersArrayId:[String] = []
    var randomId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(genereateButton)
        if let numberToEditValue = numberToEditValue{
            numberTextField.text = numberToEditValue
            mainLabel.text = "Edit number"
            numberTextField.isUserInteractionEnabled = false
        }
        generatedNumbers()
        // Do any additional setup after loading the view.
    }
    
    func generatedNumbers(){
        let db = Firestore.firestore()
        db.collection("numbers").whereField("UserId", isEqualTo: "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.numbersArrayValue.append(document.get("Number") as? String ?? "ERROR")
                    self.numbersArrayId.append(document.documentID)
                    
                }
            }
        }
    }
    
    @IBAction func generateTapped(_ sender: Any) {
        generateNumber()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        
        if numberToEditId != nil && randomId != nil{
            self.db.collection("numbers").document(self.numberToEditId!).updateData(["UserId": ""])
            { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                else {
                    print("Document successfully updated")
                }
            }
        }
        if(self.randomId != nil){
            self.db.collection("numbers").document(numbersArrayId[self.randomId!]).updateData(["UserId": Auth.auth().currentUser?.uid])
            { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                else {
                    print("Document successfully updated")
                }
            }
        }
       
        if let doneSaving = doneSaving{
            doneSaving()
        }
        
        
        dismiss(animated: true)
    }
    
    func generateNumber(){
        randomId = Int.random(in: 0...numbersArrayValue.count - 1)
        self.numberTextField.text = numbersArrayValue[randomId!]
        
    }
    
}
