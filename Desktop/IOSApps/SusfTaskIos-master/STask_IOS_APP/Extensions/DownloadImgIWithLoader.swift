//
//  DownloadImgIWithLoader.swift
//  ImageSlider
//
//  Created by Ahmed ElWa7sh on 4/23/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()
@available(iOS 13.0, *)
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.color = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
