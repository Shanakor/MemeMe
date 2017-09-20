//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 15/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {
    
    // MARK: Constants
    
    fileprivate struct Identifiers{
        static let cell = "MemeTableViewCell"
        static let memeCreationViewController = "MemeCreationViewController"
    }
    
    // MARK: Properties
    
    fileprivate var memes: [Meme]!
    
    // MARK: Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if memes.count == 0{
            presentMemeCreationViewController(animated: false)
        }
    }
    
    private func presentMemeCreationViewController(animated: Bool){
        let viewController = storyboard!.instantiateViewController(withIdentifier: Identifiers.memeCreationViewController)
        
        // Embed ViewController in NavigationController, so the NavigationBar is shown.
        let navController = UINavigationController(rootViewController: viewController)
        
        navigationController!.present(navController, animated: animated, completion: nil)
    }
}

extension SentMemesTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cell)!
        
        cell.imageView!.image = meme.memedImage
        cell.textLabel!.text = "\(meme.topText), \(meme.bottomText)"
        
        return cell
    }
}
