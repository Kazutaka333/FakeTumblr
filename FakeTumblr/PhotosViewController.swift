//
//  ViewController.swift
//  FakeTumblr
//
//  Created by Kazutaka Homma on 2/15/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController {

    var posts: [[String: Any]] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // TODO: Get the posts and store in posts property

                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]

                // TODO: Reload the table view
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: cell)!
        vc.imageUrl = getImageUrl(indexPath: indexPath)
    }
    
    func getImageUrl(indexPath : IndexPath) -> URL {
        let post = posts[indexPath.row]
        let photos = post["photos"] as! [[String: Any]]
        // TODO: Get the photo url
        let photo = photos[0]
        // 2.
        let originalSize = photo["original_size"] as! [String: Any]
        // 3.
        let urlString = originalSize["url"] as! String
        // 4.
        let url = URL(string: urlString)!
        return url
    }
}

extension PhotosViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PhotosViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoImageView!.af_setImage(withURL: getImageUrl(indexPath: indexPath))
        return cell
    }
}
