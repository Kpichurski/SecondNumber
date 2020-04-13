//
//  VerificatePinViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 13/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
class VerificatePinViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var pinFourTextField: UITextField!
    @IBOutlet weak var pinThreeTextField: UITextField!
    @IBOutlet weak var pinTwoTextFIeld: UITextField!
    @IBOutlet weak var pinOneTextField: UITextField!
    var email: String?
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        pinOneTextField.keyboardType = UIKeyboardType.numberPad
        pinTwoTextFIeld.keyboardType = UIKeyboardType.numberPad
        pinThreeTextField.keyboardType = UIKeyboardType.numberPad
        pinFourTextField.keyboardType = UIKeyboardType.numberPad

        pinOneTextField.becomeFirstResponder()
        pinOneTextField.delegate = self
        pinOneTextField.addTarget(self, action: #selector(pinsTextFieldIsNotEmpty),
        for: .editingChanged)
        pinTwoTextFIeld.delegate = self
        pinTwoTextFIeld.addTarget(self, action: #selector(pinsTextFieldIsNotEmpty),
        for: .editingChanged)
        pinThreeTextField.delegate = self
        pinThreeTextField.addTarget(self, action: #selector(pinsTextFieldIsNotEmpty),
        for: .editingChanged)
        pinFourTextField.delegate = self
        pinFourTextField.addTarget(self, action: #selector(pinsTextFieldIsNotEmpty),
        for: .editingChanged)
        pinFourTextField.delegate = self
        
        pinOneTextField.addTarget(self, action: #selector(textFieldDidChange),
        for: .editingChanged)
        pinTwoTextFIeld.addTarget(self, action: #selector(textFieldDidChange),
        for: .editingChanged)
        pinThreeTextField.addTarget(self, action: #selector(textFieldDidChange),
        for: .editingChanged)
        pinFourTextField.addTarget(self, action: #selector(textFieldDidChange),
        for: .editingChanged)
        
        
        
        print(email!)
        // Do any additional setup after loading the view.
    }
    

    @objc func pinsTextFieldIsNotEmpty() {

        print(pinOneTextField.text!)
        print(pinTwoTextFIeld.text!)
        print(pinThreeTextField.text!)
        print(pinFourTextField.text!)
        if pinThreeTextField.text?.count != 0 &&
        pinTwoTextFIeld.text?.count != 0 &&
        pinThreeTextField.text?.count != 0 &&
        pinFourTextField.text?.count != 0{

            db.collection("pins").document(email!).getDocument { (data, error) in
                if error != nil {
                    print(error)
                }
                else
                {
                    var pin = self.wholePin()
                    if data!.get("pin") as? String == pin
                    {
                        self.transitionToHome()
                    }
                    else{
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "Wrong PIN!"
                        self.pinFourTextField.text = ""
                        self.pinOneTextField.text = ""
                        self.pinTwoTextFIeld.text = ""
                        self.pinThreeTextField.text = ""
                        self.pinOneTextField.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    func wholePin() -> String {
        return pinOneTextField.text! + pinTwoTextFIeld.text! + pinThreeTextField.text! + pinFourTextField.text!
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
    }
    @objc func textFieldDidChange(textField: UITextField){
    
        if pinOneTextField.text == "" {
            pinFourTextField.becomeFirstResponder()
        }
        else if pinTwoTextFIeld.text == "" {
            pinTwoTextFIeld.becomeFirstResponder()
        }
        else if pinThreeTextField.text == "" {
            pinThreeTextField.becomeFirstResponder()
        }
        else if pinFourTextField.text == ""  {
            pinFourTextField.becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
        func transitionToHome() {
            let setNewPasswordViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.setNewPasswordViewController) as? SetNewPasswordViewController
        view.window?.rootViewController = setNewPasswordViewController
        view.window?.makeKeyAndVisible()
    }
    
}
