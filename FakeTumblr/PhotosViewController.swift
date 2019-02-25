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

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadIndicatorView: UIActivityIndicatorView!
    var posts: [[String: Any]] = []
    var isDownloading: Bool = false {
        didSet {
            if isDownloading {
                downloadIndicatorView.startAnimating()
            } else {
                downloadIndicatorView.stopAnimating()
            }
        }
    }
    var nextUrl: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Network request snippet
        downloadMorePosts()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: cell)!
        vc.imageUrl = getImageUrl(indexPath: indexPath)
    }
    
    func downloadMorePosts() {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let completionHandler : (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                let links = responseDictionary["_links"] as! [String: Any]
                let next = links["next"] as! [String: Any]
                let href = next["href"] as! String
                self.nextUrl = URL(string: "https://api.tumblr.com" + href + "&api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
                self.posts.append(contentsOf: responseDictionary["posts"] as! [[String: Any]])
                self.tableView.reloadData()
                self.isDownloading = false
            }
        }
        
        var task: URLSessionDataTask
        // second time or later
        if posts.count > 0 {
            guard let url = nextUrl else {
                isDownloading = false
                return
            }
            task = session.dataTask(with: url, completionHandler: completionHandler)
        // first time downloading
        } else {
            let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
            task = session.dataTask(with: url, completionHandler: completionHandler)
        }
        task.resume()
    
    }
    
    func getImageUrl(indexPath : IndexPath) -> URL {
        let post = posts[indexPath.section]
        let photos = post["photos"] as! [[String: Any]]
        let photo = photos[0]
        let originalSize = photo["original_size"] as! [String: Any]
        let urlString = originalSize["url"] as! String
        let url = URL(string: urlString)!
        return url
    }
    
    func parseDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        return dateFormatter.date(from: string)
    }
}

extension PhotosViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension PhotosViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoImageView!.af_setImage(withURL: getImageUrl(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        headerView.backgroundColor = UIColor.white
        
        // configure profile image view
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = profileView.frame.width/2
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        
        // configure date
        let dateLabel = UILabel(frame: CGRect(x: 48, y: 10, width: view.frame.width-50, height: 30))
        let dateString = posts[section]["date"] as! String
        let date = parseDate(string: dateString)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM dd, yyyy, h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let formattedDateString = formatter.string(from: Date())
        dateLabel.text = formattedDateString
        
        headerView.addSubview(profileView)
        headerView.addSubview(dateLabel)
        
        return headerView
    }

}

extension PhotosViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDownloading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                isDownloading = true
                downloadMorePosts()
            }
        }
    }
}
