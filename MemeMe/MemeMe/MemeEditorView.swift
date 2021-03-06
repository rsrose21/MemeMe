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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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
        
        //disable actionButton until we have a Meme
        self.actionButton.enabled = false
        
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
    
    // MARK: Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: ImagePicker delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //set selected image and fill size
        self.imagePickerView.image = image
        self.actionButton.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: toolbar button actions
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        self.pickAnImage("camera")
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        self.pickAnImage("album")
    }
    
    // MARK: text field actions
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
    
    // MARK: Meme methods
    @IBAction func shareMeme(sender: AnyObject) {
        let memeImage = generateMemedImage()
        self.saveMeme(memeImage)
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        // When finished, go to the tab bar controller
        activityViewController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.navToTabBarController()
        }
        
        self.presentViewController(activityViewController, animated: true) {
            () -> Void in
        }
    }
    
    func saveMeme(memedImage: UIImage)
    {
        var newMeme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, image: self.imagePickerView.image!, memedImage: memedImage)
        //save generated Meme to shared model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(newMeme)
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
    
    // Navigate the user to the Tab Bar Controller (TableView and CollectionView)
    func navToTabBarController() {
        var tbc:UITabBarController
        tbc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        //dismiss Meme Editor so we don't have multiple instances of modal existing
        self.dismissViewControllerAnimated(true, completion: nil)
        presentViewController(tbc, animated: true, completion: nil)
    }
    
    @IBAction func cancelEdit(sender: AnyObject) {
        //cancel button pressed, dismiss Meme Editor
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

