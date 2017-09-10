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
    
    fileprivate struct DefaultTexts{
        static let top = "TOP"
        static let bottom = "BOTTOM"
    }
    
    private let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 2.0]
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    // MARK: Properties
    private var imagePicker: UIImagePickerController!
    
    // MARK: Initialisation
    override func viewDidLoad() {
        initUIImagePickerController()
        initTextViews()
    }
    
    private func initUIImagePickerController(){
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
    }
    
    private func initTextViews(){
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = DefaultTexts.top
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = DefaultTexts.bottom
        bottomTextField.delegate = self
    }
    
    // MARK: IBActions
    @IBAction func presentImagePickerController(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: Delegate for picking an image from the photo library
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

// MARK: Delegate for TextViews
extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == DefaultTexts.bottom || textField.text == DefaultTexts.top{
            textField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    
        return false
    }
}
