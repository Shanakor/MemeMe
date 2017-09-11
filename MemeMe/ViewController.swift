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
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // MARK: Properties
    private var savedPhotosImagePicker: UIImagePickerController!
    private var cameraImagePicker: UIImagePickerController?
    
    // MARK: System Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIImagePickerControllers()
        initTextViews()

        shareButton.isEnabled = false
        cameraBarButton.isEnabled = (cameraImagePicker != nil)
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
    
    private func initTextViews(){
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.text = DefaultTexts.top
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.text = DefaultTexts.bottom
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
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
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = generateMeme()
        
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
                self.dismiss(animated: true, completion: nil)
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func generateMeme() -> Meme{
        let topText = topTextField.text == nil ? "" : topTextField.text!
        let bottomText = topTextField.text == nil ? "" : bottomTextField.text!
        
        return Meme(topText: topText, bottomText: bottomText, originalImage: self.imageView.image!, memedImage: generateMemedImage())
    }
    
    private func generateMemedImage() -> UIImage {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        toolBar.isHidden = true
        
        // Render view to an image
        // Parameter 0.0 is required, so the generated meme is not blurry.
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        toolBar.isHidden = false
        
        return memedImage
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
        if bottomTextField.isFirstResponder{
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
        self.shareButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Delegate for the UITextFields
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
