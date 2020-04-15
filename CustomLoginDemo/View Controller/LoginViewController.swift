//
//  LoginViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 07/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setUpElements()
        // Do any additional setup after loading the view.
    }
    //hide keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(forgotPasswordButton)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setButtonOnLoading(){
        self.loginButton.loadingIndicator(true)
        self.loginButton.setTitle("", for: .normal)
    }
    func setButtonOffLoading(_ login:String){
        self.loginButton.loadingIndicator(false)
        self.loginButton.setTitle(login, for: .normal)
    }
    @IBAction func loginTapped(_ sender: Any) {
        setButtonOnLoading()
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                self.setButtonOffLoading("Login")
            }
            else {
                let initialViewController = self.storyboard?.instantiateViewController(identifier:"TabBarVC") as! UIViewController
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        //signIn()
    }
    func singIn(){

    }
    @IBAction func forgtoPasswordTapped(_ sender: Any) {
    }
}
