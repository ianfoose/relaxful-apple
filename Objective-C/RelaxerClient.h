//  Relaxer.h
//  Relaxful
//
//  Created by Ian Foose on 7/17/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <Relaxful/Response.h>
#import <Relaxful/UploadDelegate.h>

@interface RelaxerClient : NSObject <NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

/**
 * basic get request
 *
 * @param url request url
 * @param errorBlock error completion block
 */
- (void) request:(NSString *_Nonnull)url errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock completion:(void (^_Nonnull)(Response* _Nonnull response))completion;

/**
 * request with request paramters
 *
 * @param method request method
 * @param url request url
 * @param body body data dictionary
 * @param headers headers data dictionary
 * @param errorBlock error completion block
 * @param completion success completion block
 */
- (void) request:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)body headers:(NSDictionary *_Nullable)headers errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock completion:(void (^_Nonnull)(Response* _Nonnull response))completion;

/**
 * builds and executes an NSURLSession
 *
 * @param method request method
 * @param url request url
 * @param body body data dictionary
 * @param headers headers data dictionary
 * @param completion success completion block
 */
- (void) session:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)body headers:(NSDictionary *_Nullable)headers completion:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error, NSURLResponse * _Nullable response))completion;

/**
 * Uploads a file
 *
 * @param method HTTP Method
 * @param url URL
 * @param params body data dictionary
 * @param headers headers data dictionary
 * @param fileKey Input File Key Name
 * @param fileName File Name
 * @param mime File Mime Type
 * @param data File
 * @param theUploadDelegate Upload Delegate
 */
- (void) upload:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)params headers:(NSDictionary *_Nullable)headers fileKey:(NSString *_Nonnull)fileKey fileName:(NSString *_Nonnull)fileName mime:(NSString *_Nonnull)mime fileData:(NSData *_Nonnull)data uploadDelegate:(id<UploadDelegate>_Nullable)theUploadDelegate;

@property NSURLSessionTask * _Nullable task;
@property id<UploadDelegate>_Nullable uploadDelegate;
@property NSURLResponse * _Nonnull uploadResponse;
@property NSMutableData * _Nullable uploadData;

@end
