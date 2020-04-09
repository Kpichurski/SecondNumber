//
//  ViewController.swift
//  CustomLoginDemo
//
//  Created by Kamil P on 07/04/2020.
//  Copyright © 2020 Kamil P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements() {
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(signUpButton)
    }

}

