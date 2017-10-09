//  Method.m
//  Relaxful
//
//  Created by Ian Foose on 8/3/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import "Method.h"

@implementation Method

- (NSString*) methodToString:(APIMethod)method {
    NSString *result = @"GET";
    
    switch (method) {
        case PUT:
            result = @"PUT";
            break;
        case PATCH:
            result = @"PATCH";
            break;
        case DELETE:
            result = @"DELETE";
            break;
        case POST:
            result = @"POST";
            break;
        case HEAD:
            result = @"HEAD";
            break;
        default:
            break;
    }
    return result;
}

@end

