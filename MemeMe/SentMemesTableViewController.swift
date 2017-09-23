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
        static let showDetailMemeViewControllerSegue = "ShowDetailFromTVC"
    }
    
    private let rowHeight:CGFloat = 90
    
    // MARK: Properties
    
    fileprivate var memes: [Meme]!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMemes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemes), name: NSNotification.Name(rawValue: AppDelegate.reloadMemesNotificationKey), object: nil)
    }
    
    private func initMemes(){
        self.memes = (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @objc private func reloadMemes(){
        initMemes()
        tableView.reloadData()
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
            let destController = segue.destination as! DetailMemeViewController
            let meme = memes[tableView.indexPathForSelectedRow!.row]
            
            destController.image = meme.memedImage
        }
    }
}

extension SentMemesTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cell) as! MemeTableViewCell
        
        cell.setup(with: meme)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
