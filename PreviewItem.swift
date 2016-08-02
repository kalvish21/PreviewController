//
//  PreviewItem.swift
//
//  Created by Kalyan Vishnubhatla on 8/1/16.
//  Copyright © 2016 Kalyan Vishnubhatla. All rights reserved.
//

import Foundation
import QuickLook

public class PreviewItem: NSObject, QLPreviewItem {
    
    /*!
     * @abstract The URL of the item to preview.
     * @discussion The URL must be a file URL.
     */
    
    private var url: NSURL!
    public var previewItemURL: NSURL {
        return url
    }
    
    /*!
     * @abstract The item's title this will be used as apparent item title.
     * @discussion The title replaces the default item display name. This property is optional.
     */
    private var title: String!
    public var previewItemTitle: String! {
        return title
    }

    public init(title: String, location: NSURL) {
        super.init()
        self.url = location
        self.title = title
    }
    
    public func setUrl(url: NSURL) -> Void{
        self.url = url
    }
    
    public func setTitle(title: String) -> Void {
        self.title = title
    }
}