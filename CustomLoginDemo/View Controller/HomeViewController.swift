//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 07/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class HomeViewController: UIViewController {


    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var yourNumber: UILabel!
    @IBOutlet weak var numerTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var editModeTextField: UILabel!
    var numbersArray:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButtonLogout(logOutButton)
        Utilities.styleTextField(numerTextField)
        Utilities.styleFilledButton(generateButton)
        numerTextField.isUserInteractionEnabled = false
        let db = Firestore.firestore()
        db.collection("numbers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    self.numbersArray.append(document.data().first!.value as? String ?? "")
                    
                   //
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func generateButtonTapped(_ sender: Any) {
                generateNumber()
    }
    func generateNumber(){
        let random = Int.random(in: 0...numbersArray.count - 1)
        self.numerTextField.text = numbersArray[random]
    }
    @IBAction func switchTapped(_ sender: Any) {
    }
    @IBAction func logOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print("log out")
            try! Auth.auth().signOut()
            transitionToSignUp()
    }
        else {
            
        }
    }
    func transitionToSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpViewController) as? ViewController
        view.window?.rootViewController = signUpViewController
        view.window?.makeKeyAndVisible()
    }
}
