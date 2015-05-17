//
//  ViewController.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/17/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeEditorView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

