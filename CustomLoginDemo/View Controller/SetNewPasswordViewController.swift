//
//  SetNewPasswordViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 14/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SetNewPasswordViewController: UIViewController {


    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    var email:String?
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email!)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleTextField(newPasswordTextField)
        Utilities.styleFilledButton(submitButton)
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
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func setButtonOnLoading(){
        self.submitButton.loadingIndicator(true)
        self.submitButton.setTitle("", for: .normal)
    }
    func setButtonOffLoading(_ newPassword:String){
        self.submitButton.loadingIndicator(false)
        self.submitButton.setTitle(newPassword, for: .normal)
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        setButtonOnLoading();
        if newPasswordTextField.text == nil ||
            confirmPasswordTextField.text == nil &&
            newPasswordTextField.text != confirmPasswordTextField.text
            
        {
            setButtonOffLoading("Submit")
            errorLabel.alpha = 1
            errorLabel.text = "Passwor are not the same!"
        }
//        else if Utilities.isPasswordValid(newPasswordTextField.text ?? "") &&
//            Utilities.isPasswordValid(confirmPasswordTextField.text ?? "") {
//            print(newPasswordTextField.text)
//            print(confirmPasswordTextField.text)
//            errorLabel.alpha = 1
//            errorLabel.text = "Password is too weak."
//        }
        else{
            let newPassword = newPasswordTextField.text
            db.collection("users").document(email!).getDocument { (data, error) in
                if error != nil {
                    
                }
                else {
                    let pass = data?.get("password") as? String
                    Auth.auth().signIn(withEmail: self.email!, password: pass!) { (result, error) in
                        if error != nil {
                            self.setButtonOffLoading("Submit")
                            print("Error in sign in")
                        }
                        else {
                            Auth.auth().currentUser?.updatePassword(to: newPassword!, completion: { (error) in
                                if error != nil {
                                    self.setButtonOffLoading("Submit")
                                    print("Error changing password")
                                }
                                else {
                                    self.transitionToHome()
                                }
                            })
                        }
                    }
                }
            }
           
        }
    }
}
