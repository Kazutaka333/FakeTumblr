//
//  PhotoDetailsViewController.swift
//  FakeTumblr
//
//  Created by Kazutaka Homma on 2/24/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.af_setImage(withURL: imageUrl)
        }
    }
    var imageUrl : URL!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FullScreenPhotoViewController
        vc.image = photoImageView.image
    }

}
