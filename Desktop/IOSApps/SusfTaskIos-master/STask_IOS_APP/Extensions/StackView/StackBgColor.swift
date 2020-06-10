//
//  StackBgColor.swift
//  ImageSlider
//
//  Created by A on 4/15/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import UIKit


extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
