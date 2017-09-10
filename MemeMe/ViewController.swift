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
    private enum SourceTypes: Int{
        case camera = 0, savedPhotosAlbum
    }
    
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
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!

    // MARK: Properties
    private var savedPhotosImagePicker: UIImagePickerController!
    private var cameraImagePicker: UIImagePickerController?
    
    // MARK: System Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIImagePickerControllers()
    }
    
    private func initUIImagePickerControllers(){
        savedPhotosImagePicker = UIImagePickerController()
        savedPhotosImagePicker.sourceType = .savedPhotosAlbum
        savedPhotosImagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraImagePicker = UIImagePickerController()
            cameraImagePicker?.sourceType = .camera
            cameraImagePicker?.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTextViews()
        initBarButtonItems()
        
        subscribeToKeyboardNotifications()
    }
    
    private func initBarButtonItems(){
        cameraBarButton.isEnabled = (cameraImagePicker != nil)
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
        guard let button = sender as? UIBarButtonItem else{
            return
        }
        
        if button.tag == SourceTypes.savedPhotosAlbum.rawValue{
            present(savedPhotosImagePicker, animated: true, completion: nil)
        }
        else if button.tag == SourceTypes.camera.rawValue && cameraImagePicker != nil{
            present(cameraImagePicker!, animated: true, completion: nil)
        }
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
