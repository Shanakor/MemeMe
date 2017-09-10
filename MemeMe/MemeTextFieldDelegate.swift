//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 10/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate{
    private let defaultText: String
    
    init(defaultText: String) {
        self.defaultText = defaultText
        
        super.init()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == defaultText{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
