//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Arslan Saeed on 10/1/18.
//  Copyright © 2018 Arslan Saeed. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var photosView: UITableView!
    
    var posts: [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosView.delegate = self
        photosView.dataSource = self
        photosView.rowHeight = 350
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
     
                
        let responseDictionary = dataDictionary["response"] as! [String: Any]
                
        self.posts = responseDictionary["posts"] as! [[String: Any]]
                
        self.photosView.reloadData()
                
            }
        }
        
        task.resume()
        
    }


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return posts.count
    }
    

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
      //  cell.textLabel?.text = "This is row \(indexPath.row)"
        let post = posts[indexPath.row]
        
        
        if let photos = post["photos"] as? [[String: Any]] {
        
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)

            cell.photoView.af_setImage(withURL: url!)
        }
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = photosView.indexPath(for: cell)!
        
        let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String: Any]] {
            
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            vc.url = url
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
