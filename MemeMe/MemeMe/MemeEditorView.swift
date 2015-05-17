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
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        //default text properties
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor(red:1, green:1, blue:1, alpha:1),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        //apply text attributes
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        
        //center text
        self.topText.textAlignment = NSTextAlignment.Center;
        self.bottomText.textAlignment = NSTextAlignment.Center;
        
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
    
    //text field actions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //return view to original position when keyboard is dismissed
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Meme methods
    @IBAction func shareMeme(sender: AnyObject) {
        let memeImage = generateMemedImage()
        self.saveMeme(memeImage)
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true) { () -> Void in
        }
    }
    
    func saveMeme(memedImage: UIImage)
    {
        var newMeme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, image: self.imagePickerView.image!, memedImage: memedImage)
        //save generated Meme to shared model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
        
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage
    {
        // Hide toolbars
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        
        return memedImage
    }
}

