//
//  ImageController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 11/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
class ImageController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var importImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let currentUser = Auth.auth().currentUser
    let dbStorageRef = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(importImage)
        importImage.titleLabel?.text = "Import"
        importImage.titleLabel?.textAlignment = .center
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
    @IBAction func importButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self

        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            // after is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            let upload = image.pngData()
            let imageStorage = dbStorageRef.child(currentUser?.uid ?? "")
            
            imageStorage.putData(upload!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                }
            }
        }
        else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
