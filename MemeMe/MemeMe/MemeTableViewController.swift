//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/18/15.
//  Copyright (c) 2015 GE. All rights reserved.
//
import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //set navigation bar title
        self.navigationItem.title = "Sent Memes"
        self.tableView!.reloadData()
    }
    
    //table delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //identify number of rows in table based on number of Memes in array
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //set cell data for each row in table
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath) as! UITableViewCell
        cell.imageView?.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        cell.textLabel?.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].topText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        //set data for view controller
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.savedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        println(detailController.savedMeme.bottomText)
        // Open detailViewController
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
