

import UIKit
//import WJXOverlappedImagesView
import VVCircleProgressBar
import SnapKit
import MBCircularProgressBar

protocol DelegateGroupTaskCell {
    
    func showStartDate(task: TaskH?)
    func showAddDate(task: TaskH?)
    func showDueDate(task: TaskH?)
    func showMeetingTime(task: TaskH?)
    func showShowMeetingUrl(task: TaskH?)
    func showUsers(task: TaskH?)
    func showComments(task: TaskH?)
    func showAttachments(task: TaskH?)
    func onTaskNameClickedForMoreInfo(task: TaskH?)
}

@available(iOS 13.0, *)
class GroupTaskCell2: UITableViewCell {
    
    
    
    @IBOutlet weak var stackBottomSec: UIStackView!
    @IBOutlet weak var taskProgress: MBCircularProgressBarView!
    var delegate: DelegateGroupTaskCell?
    //    @IBOutlet weak var taskProgressContainer: UIView!
    //    var taskProgress: VVCircleProgressBar!
    @IBOutlet weak var ivComments: UIImageView!
    
    @IBOutlet weak var ivAttachments: UIImageView!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var ivUsers: UIImageView!
    var task: TaskH?
    @IBOutlet weak var taskInfo: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    
    
    @IBOutlet weak var ivStartDate: UIImageView!
    
    @IBOutlet weak var ivAddDate: UIImageView!
    
    @IBOutlet weak var ivMeetingTime: UIImageView!
    @IBOutlet weak var ivMeetingUrl: UIImageView!
    @IBOutlet weak var ivDueDate: UIImageView!
    
    @IBOutlet weak var lblTaskInfoMainTitle: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.stackBottomSec.addBackground(color: Utils.hexStringToUIColor(hex: "FAFAFA"))
        
        self.ivUsers?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAllUsers)))
        self.ivUsers.isUserInteractionEnabled = true
        
        self.ivAttachments?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAtachments)))
        self.ivAttachments.isUserInteractionEnabled = true
        
        self.ivStartDate?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAddDate)))
        self.ivStartDate.isUserInteractionEnabled = true
        
        self.ivAddDate?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showStartDate(_:))))
        self.ivAddDate.isUserInteractionEnabled = true
        
        
        self.ivDueDate?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMeetingTime(_:))))
        self.ivDueDate.isUserInteractionEnabled = true
        
        self.ivMeetingUrl?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMeetingUrl)))
        self.ivMeetingUrl.isUserInteractionEnabled = true
        
        self.ivMeetingTime?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDueDate(_:))))
        self.ivMeetingTime.isUserInteractionEnabled = true
        
        self.ivComments?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showComments)))
        self.ivComments.isUserInteractionEnabled = true
        
        
        self.taskName?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowTaskNameForMoreInfo)))
        self.taskName.isUserInteractionEnabled = true
        
    }
   
    @objc func handleShowTaskNameForMoreInfo(_ sender: UITapGestureRecognizer?){
           delegate?.onTaskNameClickedForMoreInfo(task: self.task)
       }
    
    @objc func showAtachments(_ sender: UITapGestureRecognizer?){
        delegate?.showAttachments(task: self.task)
    }
    
    @objc func showAllUsers(_ sender: UITapGestureRecognizer?){
        delegate?.showUsers(task: self.task)
    }
    
    @objc func showComments(_ sender: UITapGestureRecognizer?){
        delegate?.showComments(task: self.task)
    }
    
    @objc func showMeetingTime(_ sender: UITapGestureRecognizer?){
        delegate?.showMeetingTime(task: self.task)
        lblTaskInfoMainTitle.text = "M-Time:"
        
        if task?.meetingTime != nil {
           taskInfo.text = Utils.pureDateTime(dateBefore: task!.meetingTime!)
        } else {
            taskInfo.text = ""
        }
        
        

        
        //taskInfo.text = task?.meetingUrl
        //taskInfo.text = Utils.pureDate(dateBefore: (task?.meetingTime)!)
//        do {
//        taskInfo.text = Utils.pureDateTime(dateBefore: (task?.meetingTime)!)
//        } catch (let err) {
//            print(err.localizedDescription)
//        }
        
    }
    
    @objc func showMeetingUrl(_ sender: UITapGestureRecognizer?){
        delegate?.showShowMeetingUrl(task: self.task)
        lblTaskInfoMainTitle.text = "Meeting Url:"
        taskInfo.text = task?.meetingUrl
        
    }
    
    @objc func showAddDate(_ sender: UITapGestureRecognizer?){
        delegate?.showAddDate(task: self.task)
        lblTaskInfoMainTitle.text = "Add Date:"
//        taskInfo.text = Utils.pureDate(dateBefore: task!.addDate)
        taskInfo.text = Utils.pureDateTime(dateBefore: task!.addDate)
        
        
    }
    
    @objc func showStartDate(_ sender: UITapGestureRecognizer?){
        delegate?.showStartDate(task: self.task)
        lblTaskInfoMainTitle.text = "Start Date:"
//        taskInfo.text = Utils.pureDate(dateBefore: task!.startDate)
        taskInfo.text = Utils.pureDateTime(dateBefore: task!.startDate)

    }
    
    @objc func showDueDate(_ sender: UITapGestureRecognizer?){
        delegate?.showDueDate(task: self.task)
//        lblTaskInfoMainTitle.text = "Due Date:"
         lblTaskInfoMainTitle.text = "Flow Title:"
//        taskInfo.text = Utils.pureDate(dateBefore: task!.dueDate)
        taskInfo.text = task?.flowTitle
        
        
    }
    
    
    func setTask(task: TaskH?){
        self.task = task
    }
    
}
