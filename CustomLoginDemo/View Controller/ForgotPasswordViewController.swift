//
//  ForgotPasswordViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 13/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ForgotPasswordViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sendPinButton: UIButton!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var userUid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        //emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        sendPinButton.isEnabled = false
        sendPinButton.backgroundColor = UIColor.gray
        let imageView = UIImageView()
        errorLabel.isHidden = true
        errorLabel.alpha = 1
        imageView.image = UIImage(named: "email")

        imageView.frame = CGRect(x: 0, y: 16, width: 25, height: 18)
        emailTextField.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 10,y: 0,width: 30,height: 30))
        emailTextField.leftView = leftView
        emailTextField.leftViewMode = .always
        
        Utilities.styleFilledButtonDisabled(sendPinButton)
        Utilities.styleTextField(emailTextField)
        
        // Do any additional setup after loading the view.
    }
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
     }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return (true)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "toSendEmail")
               {
                let svc = segue.destination as! VerificatePinViewController
                svc.email = emailTextField.text
               }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func sendPinTapped(_ sender: Any) {

    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toSendEmail"
        {
                auth.fetchSignInMethods(forEmail: emailTextField.text!) { (data, error) in
                if error != nil || data == nil{
                    self.errorLabel.alpha = 1
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Email don't exist"
                }
                else{
                    self.errorLabel.alpha = 0
                    let pin = Int.random(in: 1000...9999)
                    
                    self.db.collection("pins").document(self.emailTextField.text!).setData(["pin": String(pin)])
                    self.performSegue(withIdentifier: "toSendEmail", sender: self)
                    self.sendEmail(self.emailTextField.text!, String(pin))
                }
               
            }
        }
        return false

    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
    
        if emailTextField.text != nil && Utilities.isValidEmail(emailTextField.text!) {
            self.sendPinButton.isEnabled = true
            Utilities.styleFilledButton(self.sendPinButton)
        }
        else {
            Utilities.styleFilledButtonDisabled(self.sendPinButton)
            self.sendPinButton.isEnabled = false
        }
       }
    func sendEmail(_ email:String, _ pin:String) {
         
         
         let smtpSession = MCOSMTPSession()
         smtpSession.hostname = "smtp.gmail.com"
         smtpSession.username = "pinsecondnumber@gmail.com"
         smtpSession.password = "Haslo1234#"
         smtpSession.port = 465
         smtpSession.authType = MCOAuthType.saslPlain
         smtpSession.connectionType = MCOConnectionType.TLS
         smtpSession.connectionLogger = {(connectionID, type, data) in
             if data != nil {
                 if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                     NSLog("Connectionlogger: \(string)")
                 }
             }
         }
         let builder = MCOMessageBuilder()
         builder.header.to = [MCOAddress(displayName: "Security Code", mailbox: email)]
         builder.header.from = MCOAddress(displayName: "Security Code", mailbox: "pinsecondnumber@gmail.com")
         builder.header.subject = "PIN verification from SecondNumber"
         builder.htmlBody = "This is your PIN: <b>\(pin)</b>"
         
         
         let rfc822Data = builder.data()
         let sendOperation = smtpSession.sendOperation(with: rfc822Data)
         sendOperation?.start { (error) -> Void in
             if (error != nil) {
                 NSLog("Error sending email: \(error)")
                 
                 
             } else {
                 NSLog("Successfully sent email!")
                 
                 
             }
         }
         
     }}
