//
//  AddNumberViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 09/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
class AddNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var newNumberTextField: UITextField!
    @IBOutlet weak var addNumberLabel: UILabel!

    @IBOutlet weak var errorTextField: UILabel!
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {

        // create the alert
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(newNumberTextField)
        Utilities.styleFilledButton(addButton)
        newNumberTextField.keyboardType = UIKeyboardType.numberPad
        self.newNumberTextField.delegate = self
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
        let db = Firestore.firestore()

        db.collection("numbers").addDocument(data: [
            "number": newNumberTextField.text ?? "nil"
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
