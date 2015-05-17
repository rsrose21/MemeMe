//
//  ViewController.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/17/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeEditorView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        //maintain proportions for image display in UIImageView
        self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
    }

    //ImagePicker delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //set selected image and fill size
        self.imagePickerView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

}

