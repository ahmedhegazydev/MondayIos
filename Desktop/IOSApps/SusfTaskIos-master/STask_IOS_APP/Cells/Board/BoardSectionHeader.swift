//
//  MyExpandableTableViewSectionHeader.swift
//  LUExpandableTableViewExample
//
//  Created by Laurentiu Ungur on 24/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit
import LUExpandableTableView
import TextImageButton

@available(iOS 13.0, *)
final class BoardSectionHeader: LUExpandableTableViewSectionHeader {
    // MARK: - Properties
    
//    @IBOutlet weak var expandCollapseButton: UIButton!
//       @IBOutlet weak var expandCollapseButton: UIImageView!
        @IBOutlet weak var expandCollapseButton: TextImageButton!
            @IBOutlet weak var iconLocker: TextImageButton!
    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var labelColor: UILabel!
     @IBOutlet weak var labelColor: UIView!
    
    override var isExpanded: Bool {
        didSet {
            debugPrint("change icon")
            // Change the title of the button when section header expand/collapse
    
            //expandCollapseButton?.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
            if isExpanded {
                print("true")
               //arrow.up.circle
               ////chevron.up.circle
//                self.expandCollapseButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
                self.expandCollapseButton.setImage(UIImage(named: "expand"), for: .normal)
            }else{
                print("false")
                //chevron.down.circle
               
//                self.expandCollapseButton.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
                self.expandCollapseButton.setImage(UIImage(named: "expand"), for: .normal)
            }
            
            
        }
    }
    
    // MARK: - Base Class Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel)))
        label?.isUserInteractionEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction func expandCollapse(_ sender: UIButton) {
        //debugPrint("expand clicked")
        // Send the message to his delegate that shold expand or collapse
        delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
    }
    
    // MARK: - Private Functions
    
    @objc private func didTapOnLabel(_ sender: UIGestureRecognizer) {
        //debugPrint("Label clicked")
        // Send the message to his delegate that was selected
//        delegate?.expandableSectionHeader(self, wasSelectedAtSection: section)
        
            delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
        
    }
}
