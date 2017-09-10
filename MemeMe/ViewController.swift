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
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -2.0]
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    // MARK: Properties
    private var imagePicker: UIImagePickerController!
    
    // MARK: System Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIImagePickerController()
    }
    
    private func initUIImagePickerController(){
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTextViews()
        subscribeToKeyboardNotifications()
    }
    
    private func initTextViews(){
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = DefaultTexts.top
        topTextField.delegate = MemeTextFieldDelegate(defaultText: DefaultTexts.top)
        topTextField.textAlignment = .center

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = DefaultTexts.bottom
        bottomTextField.delegate = MemeTextFieldDelegate(defaultText: DefaultTexts.bottom)
        bottomTextField.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: IBActions
    @IBAction func presentImagePickerController(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Keyboard helper methods
    private func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification){
        if view.frame.origin.y == 0{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
}

// MARK: Delegate for picking an image from the photo library
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
