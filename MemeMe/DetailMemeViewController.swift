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
    
    var meme: Meme!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController!.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController!.tabBar.isHidden = false
    }
    
    // MARK: IBActions
    
    @IBAction func showCreateMemesViewController(_ sender: Any) {
        let navController = CreateMemeViewController.createNavigationController(with: meme, storyboard: self.storyboard!)
        
        navigationController!.present(navController, animated: true, completion: {
            // Workaround, because for some reason the containingImageHelperView is calculated wrongly
            // otherwise.
            let createMemeViewController = self.navigationController!.visibleViewController as! CreateMemeViewController
            
            createMemeViewController.imageView.image = self.meme.originalImage
            createMemeViewController.configureUIAfterImageSet()
        })
    }
}
