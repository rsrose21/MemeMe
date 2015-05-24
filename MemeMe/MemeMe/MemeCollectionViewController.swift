//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/19/15.
//  Copyright (c) 2015 GE. All rights reserved.
//
import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView!.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        println(meme)
        println(meme[indexPath.item].topText)
        //set the image
        cell.memeImage.image = meme[indexPath.item].memedImage!
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        //set data for view controller
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.savedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        println(detailController.savedMeme.bottomText)
        // Open detailViewController
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}

