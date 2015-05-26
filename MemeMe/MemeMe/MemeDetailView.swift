//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Ryan Rose on 5/19/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailView: UIImageView!
    
    var savedMeme: Meme!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailView.image = savedMeme.memedImage
    }
    
    
}
