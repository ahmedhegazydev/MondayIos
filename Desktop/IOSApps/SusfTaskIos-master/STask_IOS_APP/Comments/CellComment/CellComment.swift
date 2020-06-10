
import UIKit
import SwiftyAvatar

protocol ProtocolCommentOptions {
    func onAttachClicked(comment: Comment?)
    func onReplyClicked(comment: Comment?)
    func onLblCommentClicked(comment: Comment?)
    
}

@available(iOS 13.0, *)
class CellComment: UITableViewCell {
    
    var comment: Comment?
    var delegateCommentOptions: ProtocolCommentOptions?
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var ivAttach: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //assertionFailure(<#T##message: String##String#>)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.ivAttach.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAttach)))
        self.ivAttach.isUserInteractionEnabled = true;
        
        
        self.labelComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowAllComment)))
        self.labelComment.isUserInteractionEnabled = true;
        
    }
    
    @objc func handleAttach(){
        print("clicked")
        delegateCommentOptions?.onAttachClicked(comment: self.comment)
    }
    
    @objc func handleShowAllComment(){
        print("clicked")
        delegateCommentOptions?.onLblCommentClicked(comment: self.comment)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func btnReply(_ sender: UIButton) {
        print("btnReply")
        delegateCommentOptions?.onReplyClicked(comment: self.comment)
    }
    
    
    func setComment(comment: Comment?){
        self.comment = comment
    }
    
}
