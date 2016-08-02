# PreviewController

### Description

PreviewController allows for easy loading of remote URL's containing valid files (pdf, xls, ppt, etc) for the QuickLook library found on iOS. It will automatically download the files and then show them with a progress bar.

### Usage

1. Using cocoapods, add the following:

```
pod 'Alamofire'
pod 'MBProgressHUD'
```

2. Add `#import <CommonCrypto/CommonCrypto.h>` to your Bridging Header.

3. Add `import QuickLook` to each file that requires PreviewController.

4. Be sure to implement `QLPreviewControllerDataSource` for each class that uses PreviewController.

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

