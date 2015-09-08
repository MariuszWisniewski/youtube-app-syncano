//
//  Video.swift
//  youtube-app-syncano
//
//  Created by Mariusz Wisniewski on 9/2/15.
//  Copyright (c) 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit

class Video: SCDataObject {
    var publishedAt : NSDate?
    var videoDescription : String?
    var title : String?
    var url : String?
    var sourceId : String?
    
    override class func extendedPropertiesMapping() -> [NSObject: AnyObject] {
        return [
            "publishedAt": "published_at",
            "videoDescription" : "video_description",
            "sourceId" : "source_id"
        ]
    }
    
    class func fromDictionary(dictionary: AnyObject!) -> Video {
        let video = SCParseManager.sharedSCParseManager().parsedObjectOfClass(self.classForCoder(), fromJSONObject: dictionary) as! Video
        return video
    }
}
