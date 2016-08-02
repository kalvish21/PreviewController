//
//  PreviewController.swift
//
//  Created by Kalyan Vishnubhatla on 8/1/16.
//  Copyright © 2016 Kalyan Vishnubhatla. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import QuickLook

class PreviewController: QLPreviewController, QLPreviewControllerDataSource {
    
    private var usersDataSource: QLPreviewControllerDataSource?
    override public var dataSource: QLPreviewControllerDataSource? {
        get {
            return usersDataSource
        }
        set {
            super.dataSource = self
            usersDataSource = newValue
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getLocalPathForUrl(url: NSURL) -> String {
        let fileExtension = url.pathExtension!
        let fileName = self.md5(string: url.absoluteString)
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]

        // Get the file name
        var filePath = NSURL(fileURLWithPath: cacheDirectory).URLByAppendingPathComponent(fileName).path!
        filePath = NSURL(fileURLWithPath: filePath).URLByAppendingPathExtension(fileExtension).path!
        return filePath
    }
    
    // QLPreviewControllerDataSource
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        if self.usersDataSource == nil {
            return 0
        }
        return self.usersDataSource!.numberOfPreviewItemsInPreviewController(controller)
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {

        let originalPreviewItem = self.usersDataSource!.previewController(controller, previewItemAtIndex: index)
        let previewItemCopy: PreviewItem = PreviewItem(title: originalPreviewItem.previewItemTitle!!, location: originalPreviewItem.previewItemURL)
        let originalUrl = previewItemCopy.previewItemURL
        let localFilePath: NSURL = NSURL(fileURLWithPath: getLocalPathForUrl(originalUrl))

        if originalUrl.isFileReferenceURL() {
            return previewItemCopy
        }
        
        // Local file path
        previewItemCopy.setUrl(localFilePath)
        
        // See if file exists
        if NSFileManager.defaultManager().fileExistsAtPath(localFilePath.path!) {
            return previewItemCopy
        }
        
        // Download the file to cache
        
        // Setup progress bar
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let progressBar = MBProgressHUD(view: appDelegate.window!.rootViewController!.view)
        progressBar.mode = MBProgressHUDMode.Determinate
        appDelegate.window!.rootViewController!.view.addSubview(progressBar)
        progressBar.show(true)
        
        // Download file
        Alamofire.download(.GET, originalUrl,
            destination: { (temporaryURL, response) in
                return localFilePath
        })
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
                dispatch_async(dispatch_get_main_queue()) {
                    let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                    progressBar.progress = progress
                }
            }
            .response { (request, response, _, error) in
                print(response)
                print("Downloaded file to \(localFilePath.path!)")
                
                progressBar.hide(true)
                controller.refreshCurrentPreviewItem()
        }
        
        return previewItemCopy
    }
    
    // Convert string to MD5
    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}
