//  Response.h
//  Relaxer
//
//  Created by Ian Foose on 7/17/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface Response : NSObject

/**
 *  Initializes a response object
 *
 * @param response URLResponse
 * @param data Response data
 * @return Response
 */
-(id)init:(NSURLResponse *)response data:(NSData *)data;

/**
 *  Validates the response
 *
 * @return BOOL
 */
- (BOOL) validate;

/**
 * Parses a JSON Array from response data
 *
 * @return NSArray
 */
- (NSArray *) jsonArray;

/**
 * Parses a JSON Object from response data
 *
 * @return NSObject
 */
- (NSDictionary *) jsonObject;

@property NSURLResponse *response;
@property NSInteger status;
@property NSData *data;
@property NSString *text;
@property NSDictionary *headers;

@end
