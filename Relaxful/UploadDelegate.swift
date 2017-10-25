//  UploadDelegate.swift
//  Relaxful
//
//  Created by Ian Foose on 7/17/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

import Foundation

public protocol UploadDelegate {
    // progress update
    func uploadProgress(_ bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64)
    
    // upload finished
    func uploadFinished(_ response:Response!, error:Error?)
}
