//  UploadDelegate.h
//  Relaxful
//
//  Created by Ian Foose on 9/10/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import <Relaxful/Response.h>

@protocol UploadDelegate <NSObject>
@optional
// upload finished
- (void) uploadFinished:(Response *)response :(NSError *)error;

// progress update
- (void) uploadProgress:(int64_t)bytesSent :(int64_t)totalBytesSent :(int64_t)totalBytesExpectedToSend;

@end
