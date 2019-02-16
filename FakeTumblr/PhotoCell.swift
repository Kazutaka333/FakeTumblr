//
//  PhotoCell.swift
//  FakeTumblr
//
//  Created by Kazutaka Homma on 2/15/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
