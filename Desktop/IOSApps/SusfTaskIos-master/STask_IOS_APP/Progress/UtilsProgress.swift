//
//  UtilsProgress.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import MaterialActivityIndicator
import UIKit


class UtilsProgress {
    
    static func createProgress(view: UIView?, indicator: MaterialActivityIndicatorView?) ->  MaterialActivityIndicatorView?{
        view?.addSubview(indicator!)
        indicator!.translatesAutoresizingMaskIntoConstraints = false
        indicator!.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        indicator?.centerYAnchor.constraint(equalTo: view!.centerYAnchor).isActive = true
        
        return indicator
    }
    
}
