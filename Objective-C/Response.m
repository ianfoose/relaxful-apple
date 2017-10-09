//  Response.m
//  Relaxer
//
//  Created by Ian Foose on 7/17/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

#import "Response.h"

@implementation Response

-(id)init:(NSURLResponse *)response data:(NSData *)data {
    self = [super init];
    
    if(self) {
        _response = response;
        _data = data;
        
        if(_response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) _response;
            _status = httpResponse.statusCode;
            _headers = httpResponse.allHeaderFields;
        }
        
        if(_data != nil) {
            _text = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        }
    }
    return self;
}

- (NSArray *) jsonArray {
    NSError *error;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:_data options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
        return nil;
    } else {
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            return (NSArray *)jsonObject;
        }
    }
    
    return nil;
}

- (NSObject *) jsonObject {
    NSError *error;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:_data options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
        return nil;
    } else {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"it is a dictionary");
            return (NSDictionary *)jsonObject;
        }
    }
    
    return nil;
}

- (BOOL) validate {
    if((_status <= 200 && _status <= 304) || _status == 409) {
        return YES;
    }
    return NO;
}

@end
