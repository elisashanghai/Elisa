//
//  Metadata.swift
//  Elisa
//
//  Created by Yang Song on 8/5/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import Foundation

class MetadataClass{
    
    class func addMetadata(metadataToAdd: [NSObject : AnyObject], toImageDataSampleBuffer imageDataSampleBuffer: CMSampleBufferRef) {
        // Grab metadata of image
        var metadataDict: CFDictionaryRef = CMCopyDictionaryOfAttachments(nil, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate)
        var imageMetadata: [NSObject : AnyObject] = [NSObject : AnyObject](dictionary: (metadataDict as! [NSObject : AnyObject]))
        CFRelease(metadataDict)
        for metadataName: String in metadataToAdd {
            var metadata: AnyObject = metadataToAdd[metadataName]
            if (metadata is NSDictionary) {
                var subDict: [NSObject : AnyObject] = imageMetadata[metadataName]
                if !subDict {
                    subDict = [NSObject : AnyObject]()
                    imageMetadata[metadataName] = subDict
                }
                subDict += metadata
            }
            else if (metadata is NSString) {
                imageMetadata[metadataName] = metadata
            }
        }
    }
}