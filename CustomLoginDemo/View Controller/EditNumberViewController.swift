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
    
    var db =  Firestore.firestore()
    var doneSaving: (()->())?
    var numberToEditId: String?
    var numberToEditValue:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let numberToEditValue = numberToEditValue{
            numberTextField.text = numberToEditValue
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        
        self.db.collection("numbers").document(self.numberToEditId!).updateData(["number": numberTextField.text])
        { (err) in
            if let err = err {
                print("Error updating document: \(err)")
            }
            else {
                print("Document successfully updated")
            }
           }
        if let doneSaving = doneSaving{
            doneSaving()
        }
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
