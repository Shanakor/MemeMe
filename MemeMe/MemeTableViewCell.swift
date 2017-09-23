//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 23/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    func setup(with meme:Meme){
        imageView!.image = meme.memedImage
        textLabel!.text = "\(meme.topText) \(meme.bottomText)"
    }
}
