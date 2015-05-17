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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //disable camera button if device does not support it
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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
    //End ImagePicker delegate methods
    
    //helper method to open imagePicker
    func pickAnImage(type: NSString) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if type == "camera" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            //use photo library as source if camera disabled, album selected or the type is unknown
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        println(type)
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //toolbar button actions
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        self.pickAnImage("camera")
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        self.pickAnImage("album")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //helper method to get the keyboard height from the notification’s userInfo dictionary
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //shift view when keyboard displays so we don't obscure the text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            println("adjust keyboard")
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
}

