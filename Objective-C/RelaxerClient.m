//  Relaxer.m
//  Relaxful
//
//  Created by Ian Foose on 7/17/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import "RelaxerClient.h"
#import "Response.h"
#import "Method.h"
#import "UploadDelegate.h"

@implementation RelaxerClient

// Variables
@synthesize task;
@synthesize uploadResponse;
@synthesize uploadData;

#pragma mark Delegate Methods

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    self.uploadResponse = response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    [self.uploadData appendData:data];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    [self.uploadDelegate uploadFinished:[[Response alloc] init:self.uploadResponse data:self.uploadData]  :error];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    [self.uploadDelegate uploadProgress:bytesSent :totalBytesSent :totalBytesExpectedToSend];
}

#pragma mark Functions

- (void) upload:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)params headers:(NSDictionary *_Nullable)headers fileKey:(NSString *_Nonnull)fileKey fileName:(NSString *_Nonnull)fileName mime:(NSString *_Nonnull)mime fileData:(NSData *_Nonnull)data uploadDelegate:(id<UploadDelegate>_Nullable)theUploadDelegate{
    
    self.uploadDelegate = theUploadDelegate;
    self.uploadData = [NSMutableData alloc];
    
    NSURL *rURL = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:rURL];
    
    NSString *boundaryConstant = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    request.HTTPMethod = method;
    
    [request setValue:[@"multipart/form-data;boundary=" stringByAppendingString:boundaryConstant] forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    
    NSMutableData * body = [[NSMutableData alloc] init];
    
    if(headers != nil) {
        for(NSString* key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if(params != nil) {
        for (NSString* key in params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileKey, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mime] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    task = [session uploadTaskWithRequest:request fromData:body];
    [task resume];
}

- (void) request:(NSString *_Nonnull)url errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock completion:(void (^_Nonnull)(Response* _Nonnull response))completion {
    
    [self session:@"get" url:url body:nil headers:nil completion:^(NSData * _Nullable data, NSError * _Nullable error, NSURLResponse * _Nullable response) {
        
        if(error == nil ) {
            completion([[Response alloc] init:response data:data]);
        } else {
            errorBlock(error);
        }
    }];
}

- (void) request:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)body headers:(NSDictionary *_Nullable)headers errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock completion:(void (^_Nonnull)(Response* _Nonnull response))completion {
    [self session:method url:url body:body headers:headers completion:^(NSData * _Nullable data, NSError * _Nullable error, NSURLResponse * _Nullable response) {
        if(error == nil ) {
            completion([[Response alloc] init:response data:data]);
        } else {
            errorBlock(error);
        }
    }];
}

- (void) session:(NSString *_Nonnull)method url:(NSString *_Nonnull)url body:(NSDictionary *_Nullable)body headers:(NSDictionary *_Nullable)headers completion:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error, NSURLResponse * _Nullable response))completion {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *rURL = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:rURL];
    
    request.HTTPMethod = method;
    
    if(body != nil) {
        NSString *bodyString;
        int i = 0;
        
        for (NSString* key in body) {
            i++;
            
            [bodyString stringByAppendingString:key];
            [bodyString stringByAppendingString:@"="];
            [bodyString stringByAppendingString:[body objectForKey:key]];
            
            if(i != body.count - 1) {
                [bodyString stringByAppendingString:@"&"];
            }
        }
        
        request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if(headers != nil) {
        for(NSString* key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(data, error, response);
    }];
    
    [task resume];
}

@end

