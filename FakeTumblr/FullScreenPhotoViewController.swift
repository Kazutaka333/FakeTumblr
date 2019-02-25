//
//  FullScreenPhotoViewController.swift
//  FakeTumblr
//
//  Created by Kazutaka Homma on 2/24/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = image
        scrollView.contentSize = image.size
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension FullScreenPhotoViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
