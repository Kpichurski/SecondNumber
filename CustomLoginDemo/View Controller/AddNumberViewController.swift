//
//  AddNumberViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 09/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class AddNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var newNumberTextField: UITextField!
    @IBOutlet weak var addNumberLabel: UILabel!

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var errorTextField: UILabel!
    
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    let refStorage = Storage.storage().reference()
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {

        // create the alert
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                let refImageBackground = refStorage.child(self.currentUser?.uid ?? "")
                refImageBackground.getData(maxSize: 1 * 1024 * 1024){ (data, error) in
                    if error != nil {
                        print("Image doesn't exist in storage")
                    }
                    else {
                        self.backgroundView.image = UIImage(data: data!)
                    }
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(newNumberTextField)
        Utilities.styleFilledButton(addButton)
        newNumberTextField.keyboardType = UIKeyboardType.numberPad
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.borderColor = UIColor.black.cgColor

        
        self.backgroundView.layer.cornerRadius = self.backgroundView.frame.size.width / 2
        backgroundView.clipsToBounds = true
        self.newNumberTextField.delegate = self

        
        
        //self.backgroundView.image =
        // Do any additional setup after loading the view.
    }
    //hide keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addButtonTapped(_ sender: Any) {
        db.collection("numbers").addDocument(data: [
            "Number": newNumberTextField.text ?? "nil",
            "IsActive": true,
            "IsOccupied": false
        ]) { err in
            if err != nil {
                self.displayAlert("Error adding number")
            } else {
                self.displayAlert("Number added")
            }
        }
    }
    
    func displayAlert(_ alertText:String?){
        newNumberTextField.text = ""
        let alert = UIAlertController(title: "Success", message: alertText!, preferredStyle: UIAlertController.Style.alert)

          // add an action (button)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

          // show the alert
          self.present(alert, animated: true, completion: nil)
    }
}
