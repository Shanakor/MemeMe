//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 20/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
    
    // MARK: Properties
    
    var image: UIImage?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
