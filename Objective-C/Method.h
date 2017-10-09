//  Method.h
//  Relaxful
//
//  Created by Ian Foose on 8/3/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface Method : NSObject

typedef enum APIMethod {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE,
    HEAD
} APIMethod;

/**
 * Returns Method String HTTP Method
 *
 * @param method APIMethod
 * @return NSString
 */
- (NSString*) methodToString:(APIMethod)method;

@end
