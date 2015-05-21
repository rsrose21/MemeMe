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
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        cell.topLabel.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item].topText
        cell.bottomLabel.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item].bottomText
        cell.memeImageView.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item].image!
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
    
    func setCell(cell: MemeCollectionCell, topText:String, bottomText:String, backgroundImage:UIImage)
    {
        cell.topLabel.text = topText
        cell.bottomLabel.text = bottomText
        cell.memeImageView.image = backgroundImage
    }
    
}

