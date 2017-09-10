//
//  ViewController.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 10/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Constants
    private let sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Properties
    private var imagePicker: UIImagePickerController!
    
    // MARK: Initialisation
    override func viewDidLoad() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    // MARK: IBActions
    @IBAction func presentImagePickerController(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: Delegate for picking an image from the photo library.
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: {
            self.imageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
