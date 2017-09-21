//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 21/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: Constants
    
    fileprivate struct Identifiers{
        static let cell = "MemeCollectionViewCell"
        static let showDetailMemeViewControllerSegue = "ShowDetailFromCVC"
    }
    
    private let maxItemsInRow: CGFloat = 3
    private let minimumSpacing: CGFloat = 2
    
    // MARK: Properties
    
    fileprivate var memes: [Meme]!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMemes()
        configureFlowLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemes), name: NSNotification.Name(rawValue: AppDelegate.reloadMemesNotificationKey), object: nil)
    }
    
    private func configureFlowLayout(){
        flowLayout.minimumInteritemSpacing = minimumSpacing
        flowLayout.minimumLineSpacing = minimumSpacing
        
        let dimension = (view.frame.width - 2 * minimumSpacing) / maxItemsInRow
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    private func initMemes(){
        self.memes = (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @objc private func reloadMemes(){
        initMemes()
        collectionView!.reloadData()
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeCreationViewController(_ sender: Any) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: AppDelegate.memeCreationViewControllerIdentifier)
        
        // Embed ViewController in NavigationController, so the NavigationBar is shown.
        let navController = UINavigationController(rootViewController: viewController)
        
        navigationController!.present(navController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Identifiers.showDetailMemeViewControllerSegue{
            guard let indexPaths = collectionView!.indexPathsForSelectedItems else{
                return
            }
            
            let destController = segue.destination as! DetailMemeViewController
            let meme = memes[indexPaths[0].row]
            destController.image = meme.memedImage
        }
    }
}

// MARK: Extension for CollectionView Delegates
extension SentMemesCollectionViewController{
    
    // MARK: DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.cell, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView.image = meme.memedImage
        
        return cell
    }
}
