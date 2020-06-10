//
//  ViewAnimator.swift
//  ImageSlider
//
//  Created by A on 4/1/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//
import UIKit


extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
