

import UIKit
//import WJXOverlappedImagesView


//protocol DelegateGroupTaskCell {
//
//    func showStartDate(task: TaskH?)
//    func showEndDate(task: TaskH?)
//    func showDueDate(task: TaskH?)
//    func showUsers(task: TaskH?)
//    func showComments(task: TaskH?)
//    func showAttachments(task: TaskH?)
//}

@available(iOS 13.0, *)
class GroupTaskCell: UITableViewCell {
    
    @IBOutlet weak var topViewStatusColor: UIProgressView!
    var delegate: DelegateGroupTaskCell?
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var ivShowStartDate: UIImageView!
    @IBOutlet weak var ivShowDueDate: UIImageView!
    @IBOutlet weak var ivShowShowEnd: UIImageView!
    @IBOutlet weak var ivShowUsers: UIImageView!
    @IBOutlet weak var lblTaskStatus: UILabel!
    var task: TaskH?
    @IBOutlet weak var lblTaskDate: UILabel!
    
    @IBOutlet weak var progress: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivShowStartDate?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showStartDate)))
        self.ivShowStartDate.isUserInteractionEnabled = true
        self.ivShowDueDate?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDueDate)))
          self.ivShowDueDate.isUserInteractionEnabled = true
        
        self.ivShowShowEnd?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAddDate(_:))))
          self.ivShowShowEnd.isUserInteractionEnabled = true
        
        self.ivShowUsers?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUsers)))
        self.ivShowUsers.isUserInteractionEnabled = true
        
    }
    
    @objc func showStartDate(_ sender: UITapGestureRecognizer?){
        delegate?.showStartDate(task: self.task)
        self.lblTaskDate.text = Utils.pureDate(dateBefore: self.task!.startDate)

    }
    
    @objc func showUsers(_ sender: UITapGestureRecognizer?){
           
           delegate?.showUsers(task: self.task)
       }
    
    @objc func showDueDate(_ sender: UITapGestureRecognizer?){
        delegate?.showDueDate(task: self.task)
        self.lblTaskDate.text = Utils.pureDate(dateBefore: self.task!.dueDate)
        
    }
    @objc func showAddDate(_ sender: UITapGestureRecognizer?){
        delegate?.showAddDate(task: self.task)
        self.lblTaskDate.text = Utils.pureDate(dateBefore: self.task!.addDate)

    }
    
    
    @IBAction func btnComments(_ sender: UIButton) {
        delegate?.showComments(task: self.task)
    }
    
    @IBAction func btnAttachments(_ sender: UIButton) {
        delegate?.showAttachments(task: self.task)
    }
    
    func setTask(task: TaskH?){
        self.task = task
    }
    
}
