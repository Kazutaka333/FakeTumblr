//
//  PhotoCell.swift
//  FakeTumblr
//
//  Created by Kazutaka Homma on 2/15/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
