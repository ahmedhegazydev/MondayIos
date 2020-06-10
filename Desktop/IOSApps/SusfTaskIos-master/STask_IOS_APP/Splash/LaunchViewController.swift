//
//  LaunchViewController.swift
//  SUSF_IOS_APP
//
//  Created by Ahmed ElWa7sh on 5/4/20.
//  Copyright © 2020 Ahmed Hegazy . All rights reserved.
//

import UIKit
import Kingfisher


class LaunchViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePath = "https://mobile.susftask.com/img/tlogo.png"
        //        ImageLoader.image(for: URL(string: imagePath)!) { image in
        //            self.imageView.image = image
        //            self.indicator.isHidden = true
        //            self.indicator.endEditing(true)
        //        }
        
        
        let cache = ImageCache.default
        let cached = cache.isCached(forKey: "my_cache_key")
        let url = URL(string: imagePath)
        let resource = ImageResource(downloadURL: url!, cacheKey: "my_cache_key")
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        self.imageView.kf.indicatorType = .activity
        //ImageCache.default.clearMemoryCache()
        cache.clearMemoryCache()
        self.imageView.kf.setImage(
            //with: url,
            with: resource,
            //placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                //.cacheOriginalImage
                //.cacheMemoryOnly
                //.diskCacheExpiration(.expired),
                //.memoryCacheExpiration(.expired)
                
                //.onlyFromCache
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                let deadLine = DispatchTime.now() + .milliseconds(2500)
                                DispatchQueue.main.asyncAfter(deadline: deadLine) {
                                    self.indicator.isHidden = true;
                                    print("hop")
                                    let main = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "loginVc")
                                    main.modalPresentationStyle = .fullScreen
                                    self.present(main, animated: true) {
                
                                    }
                                }
                break
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
                break
                
            }
        }
        
        
        
    }
    
    
}
