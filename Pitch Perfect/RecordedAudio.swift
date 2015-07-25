//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Frazer Hogg on 25/07/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    
    /* Properties */
    var filePathUrl : NSURL!
    var title: String!
    
    /* Initialiser */
    init (locationToSaveTo: NSURL, desriedFileName: String!) {
        filePathUrl = locationToSaveTo
        title = desriedFileName
    }
}
