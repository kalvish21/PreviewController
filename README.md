# PreviewController

### Description

PreviewController allows for easy loading of remote URL's containing valid files (pdf, xls, ppt, etc) for the QuickLook library found on iOS. It will automatically download the files and then show them with a progress bar.

### Usage

Currently, the project is not available on cocoapods (yet). It's a small project, and can be added via the normal project add files. Be sure to add `#import <CommonCrypto/CommonCrypto.h>` to your Bridging Header. Also, add `MBProgressHUD` pod in your podfile. Also, for each file that requires this functionality, put `import QuickLook` on the top of the file.

### Code example

A simple use case would be the following:

```
// Show the PreviewController
let controller = PreviewController()
controller.dataSource = self
self.navigationController?.pushViewController(controller, animated: true)


// Implementation of QLPreviewControllerDataSource
func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
    return 1
}

func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
    return PreviewItem(title: title, location: NSURL(string: urlString)!)
}

```

### License

This code is available under the MIT license

