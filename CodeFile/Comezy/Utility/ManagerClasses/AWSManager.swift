//
//  AWSManager.swift
//  SoundTide
//
//  Created by archie on 12/04/21.
//

import Foundation
import AWSS3
import AWSCore
import AVFoundation
import MBProgressHUD

typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3

class AWSS3Manager {
    
    static let shared = AWSS3Manager() // 4
    private init () { }
    let bucketName = "comezyandroidd9188d0503e4419a82be1cd838c6264c13733-dev" //5
    private var progressHUD: MBProgressHUD?
    
    func initializeS3() {
        let secretKey = "bzMsE7SvyhOTjwNqADz+BgObXaoiKXSFj+DOTul5"
        let accessKey = "AKIAXJIEVGZEW5MALDO2"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    //MARK:- MBProgredHUD -
    func showProgressHUD(message:String? = nil) {
        hideProgressHUD()
        progressHUD = nil
        progressHUD = MBProgressHUD.showAdded(to: (currentController?.view)!, animated: true)
        
        if let message = message {
            progressHUD?.label.text = message
            progressHUD?.label.numberOfLines = 0
        }
    }
    
    func hideProgressHUD() {
        if let progressHUD = progressHUD {
            progressHUD.hide(animated: true)
        }
    }
    // Upload image using UIImage object
    func uploadImage(image: UIImage, fileName: String, progress: progressBlock?, completion: completionBlock?) {
        self.showProgressHUD()
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }
        
        let tmpPath = NSTemporaryDirectory() as String
        let myfileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
        let filePath = tmpPath + "/" + myfileName
        let fileUrl = URL(fileURLWithPath: filePath)
        print(fileUrl)
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: fileName + ".jpg", contenType: "image", progress: progress, completion: completion)
        } catch let err{
            self.hideProgressHUD()
            //let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, err)
        }
    }
    
    // Upload video from local path url
    func uploadVideo(videoUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: videoUrl)
        self.uploadfile(fileUrl: videoUrl, fileName: fileName, contenType: "video", progress: progress, completion: completion)
    }
    
    // Upload auido from local path url
    func uploadAudio(audioUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: audioUrl)
        self.uploadfile(fileUrl: audioUrl, fileName: fileName, contenType: "audio", progress: progress, completion: completion)
    }
    
    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    func uploadImageFile(fileUrl: URL, fileName: String, conentType: String = "image", progress: progressBlock?, completion: completionBlock?) {
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
    
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                self.hideProgressHUD()
            }
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    
    func trimAudio(audioUrl: URL, endTime: Double, completionHandler: @escaping(_ success: Bool?, _ url: URL?, _ error: String?) -> Void){
        let asset: AVURLAsset!
        asset = AVURLAsset.init(url: audioUrl)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
                print("video length: \(length) seconds")
                
                
                let fileManager = FileManager.default
                
        guard let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { completionHandler(false, nil, "Please try again!")
            return
        }//return nil}
                
                
                var outputURL = documentDirectory.appendingPathComponent("output")
                do {
                    try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                    
                    outputURL = outputURL.appendingPathComponent("output.m4a")
                }catch let error {
                    print(error)
                }
                
                //Remove previous existing file
                _ = try? fileManager.removeItem(at: outputURL)

                guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {completionHandler(false, nil, "Please try again!")
                    return
                }

                exportSession.outputURL = outputURL
                exportSession.outputFileType = AVFileType.m4a
                
                let start = 0
                let end = endTime
                
        let startTimeRange = CMTime(seconds: Double(start), preferredTimescale: 1000)
        let endTimeRange = CMTime(seconds: Double(end), preferredTimescale: 1000)
                let timeRange = CMTimeRange(start: startTimeRange, end: endTimeRange)
                
                exportSession.timeRange = timeRange
                exportSession.exportAsynchronously{
                    switch exportSession.status {
                    case .completed:
                        completionHandler(true, outputURL, nil)
                        print("exported at \(outputURL)")
                    case .failed:
                        completionHandler(false, nil, "\(String(describing: exportSession.error))")
                        print("failed \(String(describing: exportSession.error))")
                    case .cancelled:
                        completionHandler(false, nil, "\(String(describing: exportSession.error))")
                        print("cancelled \(String(describing: exportSession.error))")
                    default:
                        break
                    }
                }
    }
}



