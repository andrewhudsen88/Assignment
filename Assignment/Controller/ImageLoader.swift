//
//  ImageLoader.swift
//  Assignment
//
//  Created by Andrew Hudsun on 07/07/24.
//

import UIKit


var imageCache : NSCache<AnyObject, AnyObject>? = NSCache()

class ImageLoader: UIImageView {

    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL,_ image:@escaping(UIImage?)->()){

        DispatchQueue.main.async {[weak self] in
            
            // setup activityIndicator...
            self?.activityIndicator.color = .white
            self?.contentMode = .scaleAspectFit
            self?.addSubview(self!.activityIndicator)
            self?.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self?.activityIndicator.centerXAnchor.constraint(equalTo: self!.centerXAnchor).isActive = true
            self?.activityIndicator.centerYAnchor.constraint(equalTo: self!.centerYAnchor).isActive = true
            
            self?.image = nil
            self?.activityIndicator.startAnimating()
            
            // retrieves image if already available in cache
            if let imageFromCache = imageCache?.object(forKey: url as AnyObject) as? UIImage {
                
                self?.image = imageFromCache
                self?.activityIndicator.stopAnimating()
                image(imageFromCache)
                return
            }
        }
        // image does not available in cache.. so retrieving it from url...
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                    })
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        
                        self.image = imageToCache
                        
                        imageCache?.setObject(imageToCache, forKey: url as AnyObject)
                        image(imageToCache)
                    }
                    self.activityIndicator.stopAnimating()
                    return
                })
            }).resume()
        }
    }
}
