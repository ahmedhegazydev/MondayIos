
import UIKit
import LUExpandableTableView
import TextImageButton
//import WJXOverlappedImagesView

//protocol DelegateAttachGroupSection {
//    func onGroupSecAttachClicked(task: TasksGroup?)
//}

@available(iOS 13.0, *)
//final class GroupSectionHeader: LUExpandableTableViewSectionHeader {
//class GroupSectionHeader: UITableViewCell {
class GroupSectionHeader: UITableViewHeaderFooterView{

    
//    @IBOutlet weak var collectionLetrreAvatars: UICollectionView!
//
//    
    internal var delegateAttach: DelegateAttachGroupSection?

//    @IBOutlet weak var overlappedImagesView: WJXOverlappedImagesView!
    @IBOutlet weak var expandCollapseButton: TextImageButton!
    @IBOutlet weak var imageViewAttach: UIButton!
    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var labelTaskGroupName: UILabel!
    var task: TasksGroup?
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)

           //fatalError("init(coder:) has not been implemented")
       }
       
       
       override func layoutSubviews() {
           super.layoutSubviews()
           
       }
    
    
//    override var isExpanded: Bool {
//        didSet {
//            debugPrint("change icon")
            
//            if isExpanded {
//                print("true")
//                //arrow.up.circle
//                ////chevron.up.circle
//                self.expandCollapseButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
//
//            }else{
//                print("false")
//                //chevron.down.circle
//
//                self.expandCollapseButton.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
//            }
            
//
//        }
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        label?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel)))
//        label?.isUserInteractionEnabled = true
//
        
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAttach(_:)))
//             self.imageViewAttach.addGestureRecognizer(tapRecognizer)
               
               
              
    }
    
//    @objc func handleAttach(_ sender: UITapGestureRecognizer?){
////           self.view.makeToast("Attach cleicked")
//           print("Attch clicked")
//        self.delegateAttach?.onGroupSecAttachClicked()
//       }
    
    
    
    // MARK: - IBActions
    
//    @IBAction func expandCollapse(_ sender: UIButton) {
//        //debugPrint("expand clicked")
//        // Send the message to his delegate that shold expand or collapse
////        delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
//    }
    
    // MARK: - Private Functions
    
//    @objc private func didTapOnLabel(_ sender: UIGestureRecognizer) {
//        print("ddddddd")
//        delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
//
//
//    }
    
    
    @IBAction func btnAttach(_ sender: UIButton) {
        print("Attch clicked")
        self.delegateAttach?.onGroupSecAttachClicked(task: self.task)
        
    }
    
    
    func seTask(task: TasksGroup?){
        self.task = task
    }
}
