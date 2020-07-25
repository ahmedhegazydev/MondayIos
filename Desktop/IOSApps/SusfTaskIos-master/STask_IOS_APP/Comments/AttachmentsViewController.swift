//
//  AttachmentsViewController.swift
//  ImageSlider
//
//  Created by A on 4/7/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Alamofire
import YPImagePicker
import ImagePicker
import Lightbox
import SwiftyJSON
import Loaf
import CircularProgressBar
import Photos
//import FileKit
import PMAlertController
import AttachmentPicker
import PDFKit
import AttachmentInput
//import Pickle
import FileBrowser
import SSCustomTabbar


@available(iOS 13.0, *)
class AttachmentsViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate{
    
    
    let picker = HSAttachmentPicker()
    @IBOutlet weak var ivAttachNew: UIImageView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelFileNme: UILabel!
    @IBOutlet weak var tableViewAttachments: UITableView!
    let cellReusableId = "CellAttachment"
    var attachments: [Attachment] = []
    //    var attachments: [AttachmentData] = []
    var nestedBoard: NestedBoardH?
    var typeBorTorC: String = ""
    var idBorTorC: String = ""
    let headers: HTTPHeaders = [
        .accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
        .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
        .init(name: "tz", value: TimeZone.current.identifier)
        ,
        
    ]
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Attach y man ")
        
        
        self.tableViewAttachments.register(UINib(nibName: self.cellReusableId, bundle: .main
        ), forCellReuseIdentifier: cellReusableId)
        self.tableViewAttachments.delegate = self
        self.tableViewAttachments.dataSource = self
        tableViewAttachments.refreshControl = self.refresher
        //        var noDeletionArr: [Attachment]? = []
        //        if attachments == nil {
        //            self.attachments = []
        //        }else{
        //            for n  in 0..<self.attachments.count {
        //                print(self.attachments[n].isDelete)
        //                print(self.attachments[n].attachId)
        //                if !self.attachments[n].isDelete! {
        //                    noDeletionArr?.append(self.attachments[n])
        //                }else{
        //
        //                }
        //            }
        //            self.attachments = noDeletionArr!
        //        }
        //        self.attachments.reverse()
        //        self.tableViewAttachments.reloadData()
        
        
        
        ivAttachNew.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAttachNew)))
        
        
        getAllAttachments()
        
    }
    
    
    @objc func handleRefresh(){
        
        getAllAttachments()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabController = self.tabBarController{
            if let tabBar =  tabController as? SSCustomTabBar{
                if tabBar.tag == 2 {
                    let movetoroot = true;
                    if movetoroot {
                        navigationController?.popToRootViewController(animated: true)
                    } else {
                        navigationController?.popViewController(animated: true)
                    }
                    tabBar.tag  = 0
                }
            }
        }
    }
    
    
    func getAllAttachments(){
        
        self.view.makeToastActivity(.center)
        
        //        let parameters: [String: Any] = [
        //            "id": "\(self.idBorTorC)",
        //            "type" : "\(self.typeBorTorC)"
        //    ]
        print("idBorTorC = \(idBorTorC)")
        print("typeBorTorC = \(typeBorTorC)")
        
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_GET_ALL_ATTACHMENTS+"?id=\(idBorTorC)&type=\(typeBorTorC)"
        //http://wayak.org/task/attachgeneral?id=TIC2718393875&type=c
        debugPrint(url)
        AF.request(url,method: .get,
                   headers: headers)
            //.response { response in
            //               .responseJSON { response in
            .responseString{ response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let response):
                    print("oasasa")
                    
                    if let value = response as? String{
                        print("adawe = \(value)")
                        
                        
                        if let model = AttachmentResponse(JSONString: value){
                            print(model.successful )
                            if (model.successful ?? false) {
                                var attData: [Attachment] = []
                                for n in 0..<model.data!.count{
                                    //print(" dpsd = \(model.data![n].byShortName)")
                                    var att: Attachment = Attachment()
                                    let map: AttachmentData = model.data![n]
                                    //                                    att._id = map._id
                                    att.isPrivate = map.isPrivate
                                    att.isDelete = map.isDelete
                                    att.attachId = map.attachId
                                    att.attachName = map.attachName
                                    att.attachKey = map.attachKey
                                    //att.users = map.users
                                    att.byUserName = map.byUserName
                                    att.byShortName = map.byShortName
                                    att.byUserImage = map.byUserImage
                                    att.byFullName = map.byFullName
                                    att.addDate = map.addDate
                                    att.byId = map.byId
                                    
                                    attData.append(att)
                                }
                                self.attachments = attData
                                self.attachments.reverse()
                                self.tableViewAttachments.reloadData()
                                self.refresher.endRefreshing()
                                
                            }else{
                                let swiftyData = JSON(value)
                                let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                                debugPrint("error \(errorMessage)")
                                //UtilsAlert.showError(message: errorMessage)
                                self.view.hideToastActivity()
                            }
                        }
                    }else{
                        print("pwepcmsda")
                    }
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
                
        }
        
        
        
    }
    
    @objc func handleTapAttachNew(){
        btnAttachAndUploadFile(UIButton.init())
    }
    
    
    @IBAction func btnClose(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
            
        }
        
        
    }
    
    
    @IBAction func btnAttachAndUploadFile(_ sender: UIButton) {
        
        //        var config = Configuration()
        //        config.doneButtonTitle = "Finish"
        //        config.noImagesTitle = "Sorry! There are no images here!"
        //        config.recordLocation = false
        //        config.allowVideoSelection = true
        //        let imagePicker = ImagePickerController(configuration: config)
        //        imagePicker.delegate = self
        //        present(imagePicker, animated: true, completion: nil)
        
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            print("fffss pad")
            showActionSheet()
        }else{
            print("fffss phone")
            picker.delegate = self
            picker.showAttachmentMenu()
        }
        
    }
    
    func showActionSheet(){
        let alertController = UIAlertController(title: Constants.APP_NAME, message: "Select", preferredStyle: UIAlertController.Style.alert)
        
        let photo = UIAlertAction(title: "Choose from Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            //                    var config = Configuration()
            //                    config.doneButtonTitle = "Finish"
            //                    config.noImagesTitle = "Sorry! There are no images here!"
            //                    config.recordLocation = false
            //                    config.allowVideoSelection = true
            //                    let imagePicker = ImagePickerController(configuration: config)
            //                    imagePicker.delegate = self
            //            self.present(imagePicker, animated: true, completion: nil)
            
            //            let attachmentInput = AttachmentInput()
            //            attachmentInput.delegate = self
            //            print("photo")
            
            
            let picker = ImagePickerController()
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        })
        
        //        let cam = UIAlertAction(title: "", style: .default, handler: { (alert: UIAlertAction!) -> Void in
        //
        //            let picker = ImagePickerController()
        //            picker.delegate = self
        //            self.present(picker, animated: true, completion: nil)
        //
        //        })
        
        let fileImport = UIAlertAction(title: "Import file From", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let fileBrowser = FileBrowser()
            fileBrowser.didSelectFile = { (file: FBFile?) -> Void in
                print(file!.displayName)
                self.labelFileNme.text = file?.displayName
                if let filePath = file?.filePath {
                    do {
                        let fileData = try Data(contentsOf: filePath as URL)
                        self.beginUpload(nil, fileData, file?.displayName)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
            }
            self.present(fileBrowser, animated: true, completion: nil)
            //            fileBrowser.excludesFileExtensions = ["zip"]
            //            fileBrowser.excludesFilepaths = [secretFile]
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(photo)
        //        alertController.addAction(cam)
        alertController.addAction(fileImport)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        picker.dismiss(animated: true)
        //        guard let image = info[.editedImage] as? UIImage else {
        //            print("No image found")
        //            return
        //        }
        //        beginDownlaod(image)
        //        if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset{
        //            if let fileName = asset.value(forKey: "filename") as? String{
        //                print("gosds \(fileName)")
        //            }
        //        }
        //
        //
        
        
        
    }
    
    
    func attachDelete(indexPath: IndexPath,  pos: Int, attach: Attachment){
        self.view.makeToastActivity(.center)
        var url: String = ""
        var attachId: String  = attach.attachId!
        url = Constants.BASE_URL + Constants.Ends.END_POINT_DEL_ATTACHMENT_GENERAL + self.idBorTorC
        debugPrint("ooosd" + url)
        debugPrint(attachId)
        debugPrint("\(typeBorTorC)")
        
        var users: [String] = []
        var isPrivate: Bool = true
        let parameters: [String: Any] = [
            "attachId": "\(attachId)",
            "type" : "\(typeBorTorC)"]
        
        AF.request(url,method: .put , parameters: parameters,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success put : \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        //UtilsAlert.showSuccess(message: message)
                        
                        guard let data = response.data else { return }
                        do {
                            
                            self.attachments.remove(at: pos)
                            self.tableViewAttachments.beginUpdates()
                            self.tableViewAttachments.deleteRows(at: [indexPath], with: .left)
                            self.tableViewAttachments.endUpdates()
                            self.tableViewAttachments.reloadData()
                            
                            self.view.makeToast(message)
                        } catch let error {
                            print(error)
                        }
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
        }
        
    }
    
    
    
}


@available(iOS 13.0, *)
extension AttachmentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachments.count
        //return 5;
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellAttachment
        
        let attachment = attachments[indexPath.row]
        cell.setAttachment(attachment: attachment)
        cell.delegate = self;
        
        
        cell.labelFileName.text = attachment.attachName
        //cell.lblDate.text = Utils.pureDate(dateBefore: (attachment?.addDate)!)
        cell.lblDate.text = Utils.pureDateTime(dateBefore: (attachment.addDate)!)
        cell.lblByName.text = attachment.byFullName
        
        if indexPath.row == attachments.count - 1 {
            cell.separator.isHidden = true
        }
        
        return cell;
        //return UITableViewCell()
        
    }
    
    
    
    
    //    @objc func handleAttach(){
    //          print("clicked")
    //        self.view.makeToast("Attach")
    //
    //      }
    
}

@available(iOS 13.0, *)
extension AttachmentsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        self.view.makeToast("\(indexPath.row)")
    //    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //handle delete
            //self.view.makeToast("delete")
            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.attachDelete(indexPath: indexPath,  pos:indexPath.row, attach: self.attachments[indexPath.row])
                
            }))
            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            self.present(deleteConfirmation, animated: true) {}
        })
        deleteAction.image = UIImage(named: "delete_24")
        deleteAction.backgroundColor = .white
        
        
        let currentAttachtId = self.attachments[indexPath.row].byId
        let currentUserId = Utils.fetchSavedUser().data.user.id
        print("XXxxXX = \(currentUserId)")
        print("XXxxXX \(self.attachments[indexPath.row].byId)")
        
        if currentUserId != currentAttachtId {
            return UISwipeActionsConfiguration(actions: [])
        }else{
            return UISwipeActionsConfiguration(actions:
                [deleteAction])
            
        }
        
        return UISwipeActionsConfiguration(actions: [])
        
    }
    
}

//@available(iOS 13.0, *)
//extension AttachmentsViewController: UIImagePickerControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info:
//        [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.imageview.contentMode = .scaleAspectFit
//            self.imageview.image = pickedImage
//        }
//
//        //dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        //dismiss(animated: true, completion: nil)
//    }
//}

@available(iOS 13.0, *)
extension AttachmentsViewController: ImagePickerDelegate{
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
        
        
    }
    
    fileprivate func beginUpload(_ firestImage: UIImage?, _ data: Data?, _ filename: String?) {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .contentType("multipart/form-data"),
            .init(name: "tz", value: TimeZone.current.identifier)
            ,
            
        ]
        let url = Constants.BASE_URL +  Constants.Uplaoding.END_POINT_UPLOAD_FILE
        
        if data == nil {
            uploadAndSaving(image: firestImage!.pngData(), url: url, params: nil, headers: headers, fileName: filename)
        }else{
            uploadAndSaving(image: data, url: url, params: nil, headers: headers, fileName: filename)
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("fetched images")
        imagePicker.dismiss(animated: true, completion: nil)
        let firestImage = images[0]
        
        beginUpload(firestImage, nil, "Attach file name")
        
    }
    
    func uploadAndSaving(image: Data?, url: String?, params: [String: Any]?, headers: HTTPHeaders?, fileName: String?) {
        SwiftProgressBar.addCircularProgressBar(view: self.view, type: 1)
        SwiftProgressBar.setProgressColor(color: UIColor.red)
        AF.upload(multipartFormData: { multiPart in
            multiPart.append(image!, withName: "file",
                             //fileName: "file.png",
                fileName: fileName,
                mimeType: "image/png")
        }, to: url as! URLConvertible, method: .post, headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                //print("Upload Progress: \(progress.fractionCompleted)")
                SwiftProgressBar.setProgress(progress: Float(progress.fractionCompleted * 100))
            })
            .responseJSON { response in
                
                SwiftProgressBar.hideProgressBar()
                
                switch response.result {
                case .success(let data):
                    debugPrint( "Success_upload\(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let swifty = try JSON(data: response.data!)
                            let message = swifty["message"].stringValue
                            let status = swifty["successful"].stringValue
                            let attachKey = swifty["data"]["attachKey"].stringValue as String
                            let attachName = swifty["data"]["attachName"].stringValue as String
                            
                            //                            print(message)
                            //                            print(status)
                            //                            print(attachKey)
                            //                            print(attachName)
                            
                            self.putAttachmentGeneral(attachKey: attachKey, attachName: attachName, typeBorTorC: self.typeBorTorC, idBorTorC: self.idBorTorC)
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
        }
    }
    
    func putAttachmentGeneral(attachKey: String, attachName: String, typeBorTorC: String, idBorTorC: String){
        
        var users: [String] = []
        var isPrivate: Bool = true
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            //.contentType("application/json")
            .init(name: "tz", value: TimeZone.current.identifier)
            
            
        ]
        let parameters: [String: Any] = [
            "attachName": "\(attachName)",
            "attachKey" : "\(attachKey)",
            "isPrivate" : "\(isPrivate)",
            "type" : "\(typeBorTorC)",
            "users" : "\(users)",
        ]
        
        print(attachName)
        print(attachKey)
        print(typeBorTorC)
        print(idBorTorC)
        print(users)
        print(isPrivate)
        
        self.view.makeToastActivity(.center)
        
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ADD_ATTACH_GENERAL + self.idBorTorC
        debugPrint(url)
        AF.request(url,method: .put, parameters: parameters, headers: headers)
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                self.view.hideToastActivity()
                
                switch response.result {
                case .success(let data):
                    debugPrint( "Success put : \(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let main = swiftyData["data"]
                            let addDate = main["addDate"].stringValue
                            let attachId = main["attachId"].stringValue
                            let attachName = main["attachName"].stringValue
                            let byFullName = main["byFullName"].stringValue
                            let byId = main["byId"].stringValue
                            let byShortName = main["byShortName"].stringValue
                            let byUserImage = main["byUserImage"].stringValue
                            let byUserName = main["byUserName"].stringValue
                            
                            var attachment: Attachment? = Attachment()
                            attachment?.byShortName = byShortName
                            attachment?.byFullName = byFullName
                            attachment?.addDate = addDate
                            attachment?.attachId = attachId
                            attachment?.attachName = attachName
                            attachment?.byId = byId
                            attachment?.byUserImage = byUserImage
                            attachment?.byUserName = byUserName
                            
                            //self.attachments?.append(attachment!)
                            self.attachments.insert(attachment!, at: 0)
                            
                            self.tableViewAttachments.beginUpdates()
                            self.tableViewAttachments.insertRows(at: [IndexPath(row: 0, section: 0) ], with: .right)
                            self.tableViewAttachments.endUpdates()
                            
                            //self.tableViewAttachments.reloadData()
                            
                            //UtilsAlert.showSuccess(message: "Uplaoded success")
                            self.view.makeToast(NSLocalizedString("uploaded_success", comment: ""))
                            
                            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.attachments), forKey: Constants.SAVED_ATTACHMENTS_TO_NESTED)
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
        }
        
    }
    
    
}

@available(iOS 13.0, *)
extension AttachmentsViewController: ProtocolDownloadFile{
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        guard let directory = try? FileManager.default.url(
            //for: .documentDirectory,
            for: .downloadsDirectory,
            in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("AhmedMohmed.png")!)
            self.view.makeToast("okay")
            return true
        } catch {
            self.view.makeToast("error")
            print(error.localizedDescription)
            return false
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    fileprivate func downloadAndShowImage(_ url: String, _ headers: HTTPHeaders) -> DownloadRequest {
        return //                FileDownloader.loadFileAsync(url: URL(fileURLWithPath: url), headers: self.headers) { (path, error) in
            //                    print("PDF File downloaded to : \(path!)")
            //                    print(error)
            //
            //                }
            //
            
            AF.download(url, headers: headers).responseData { response in
                self.view.hideToastActivity()
                Loaf("Downloaded successfully",
                     state: .success, presentingDirection: .left,
                     sender: self).show()
                //for images only
                if let data = response.value {
                    let image = UIImage(data: data)
                    if image != nil {
                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        self.showImageAlert(image: image!)
                    }else{
                        self.view.makeToast(NSLocalizedString("error_download", comment: ""))
                    }
                }
        }
    }
    
    fileprivate func downloadPdfFile1(_ url: String, _ headers: HTTPHeaders) -> DownloadRequest {
        return AF.download(url, headers: headers ).responseData { response in
            self.view.hideToastActivity()
            Loaf("Downloaded successfully",
                 state: .success, presentingDirection: .left,
                 sender: self).show()
            //for pdfs
            if let data = response.value {
                //                let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                //                let path = "\(documentPath)/filename.pdf"
                //                do{ try data.write
                //                    //                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                //                    //                        let documentsDirectory = paths[0]
                //                    let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
                //                    dc.delegate = self
                //                    dc.presentPreview(animated: true)
                //                }catch (let err){
                //                    print(err.localizedDescription)
                //                }
            }
        }
    }
    
    func onDownloadFile(attach: Attachment?) {
        
        
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy_MMM_dd_HH_mm_ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let interval = date.timeIntervalSince1970
        print(dateString)
        print(interval)
        //        print(attach?.attachId)
        //        print(attach?.attachName)
        
        
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .init(name: "tz", value: TimeZone.current.identifier),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
            
        ]
        var id = attach?.attachId
        print(attach?.attachName)
        let url = Constants.BASE_URL + Constants.Uplaoding.END_POINT_DOWNLOAD_FILE + id!
        debugPrint(url)
        //        self.view.makeToastActivity(.center)
        
        var documentsURL: URL?
        let destination: DownloadRequest.Destination = { _, _ in
            documentsURL = FileManager.default.urls(for:
                //.picturesDirectory,
                .documentDirectory,
                                                    in: .userDomainMask)[0]
            
            //let ct = String(CACurrentMediaTime().truncatingRemainder(dividingBy: 1))
            let fileURL = documentsURL!.appendingPathComponent(dateString + "_" + (attach?.attachName)!)
            print(fileURL.absoluteString)
            return (fileURL, [.removePreviousFile,.createIntermediateDirectories])
            //            return (fileURL, [])
        }
        
        SwiftProgressBar.addCircularProgressBar(view: self.view, type: 1)
        SwiftProgressBar.setProgressColor(color: UIColor.red)
        
        
        AF.download(url,headers: headers, to: destination)
            .downloadProgress { progress in
                // print("Download Progress: \(progress.fractionCompleted)")
                SwiftProgressBar.setProgress(progress: Float(progress.fractionCompleted * 100))
                
        }
        .response { response in
            
            if response.error == nil, let imagePath = response.fileURL?.path {
                print("file exist \(imagePath)")
                
                
                
                //self.view.hideToastActivity()
                //        Loaf("Downloaded and saved successfully",
                //state: .success, presentingDirection: .left,
                // sender: self).show()
                SwiftProgressBar.hideProgressBar()
                
                
                
                //open the general folder
                let fileBrowser = FileBrowser()
                //fileBrowser.modalPresentationStyle = .overFullScreen
                self.present(fileBrowser, animated: true, completion: nil)
                //self.navigationController?.pushViewController(fileBrowser, animated: true)
                
                
                
                //                if (self.isImage(name: (attach?.attachName)!)) {
                //                    let image = UIImage(contentsOfFile: imagePath)
                //                    //                    self.showImageAlert(image: image!)
                //                }else{
                //                    if (attach?.attachName?.contains("pdf"))! {
                //                        //                        self.view.makeToast("Pdf")
                //                        //                        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: imagePath))
                //                        //                        dc.delegate = self
                //                        //                        dc.presentPreview(animated: true)
                //                    }
                //                }
                //
                
            }
        }
    }
    
    fileprivate func isImage(name: String) -> Bool{
        if name.contains("png") || name.contains("jpg")
            || name.contains("jpeg")
            
        {
            return true
        }
        return false
    }
    
    func showImageAlert(image: UIImage){
        let alertVC = PMAlertController(title: Constants.APP_NAME, description: "You downloaded image", image: image, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            print("Capture action OK")
        }))
        
        //        alertVC.addTextField { (textField) in
        //                    textField?.placeholder = "Location..."
        //                }
        self.present(alertVC, animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension AttachmentsViewController: UIDocumentInteractionControllerDelegate{
    
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
    
}

@available(iOS 13.0, *)
extension AttachmentsViewController: HSAttachmentPickerDelegate {
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) {
        // Handle errors
    }
    
    func attachmentPickerMenuDismissed(_ menu: HSAttachmentPicker) {
        // Run some code when the picker is dismissed
        print("attachmentPickerMenuDismissed")
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
        print("attachmentPickerMenu")
        self.present(controller, animated: true, completion: completion)
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data?, filename: String, image: UIImage?) {
        print("attachmentPickerMenu")
        // Do something with the data of the selected attachment, i.e. upload it to a web service
        self.labelFileNme.text = filename
        if image != nil {
            print("sdfsd image ")
            beginUpload(image!, nil, filename)
        }else{
            if data != nil {
                print("sdfsd data ")
                beginUpload(nil, data, filename)
            }
        }
    }
}

extension AttachmentsViewController: UIPopoverPresentationControllerDelegate{
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}


extension AttachmentsViewController: AttachmentInputDelegate {
    func inputImage(imageData: Data, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: Data?) {
    }
    
    func inputMedia(url: URL, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: Data?) {
    }
    
    func removeFile(fileId: String) {
        
    }
    
    func imagePickerControllerDidDismiss() {
        // Do nothing
    }
    
    func onError(error: Error) {
        let nserror = error as NSError
        if let attachmentInputError = error as? AttachmentInputError {
            print(attachmentInputError.debugDescription)
        } else {
            print(nserror.localizedDescription)
        }
    }
}


