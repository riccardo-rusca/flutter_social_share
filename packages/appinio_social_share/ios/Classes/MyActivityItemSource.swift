//
//  MyActivityItemSource.swift
//  appinio_social_share
//
//  Edited by ARiccardo Rusca on 2024-11-07
//

import Foundation
import LinkPresentation

@available(iOS 13,*)
class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    var filePath: String
    
    init(title: String, text: String, filePath: String) {
        self.title = title
        self.text = text
        self.filePath = filePath
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata {
            let metadata = LPLinkMetadata()
            metadata.title = title
            metadata.iconProvider = NSItemProvider(object: UIImage(contentsOfFile: filePath)!)
            metadata.originalURL = URL(fileURLWithPath: text)
            return metadata
    }
    
}
