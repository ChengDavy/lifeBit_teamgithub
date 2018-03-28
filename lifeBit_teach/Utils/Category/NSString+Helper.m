//
//  NSString+Helper.m
//  mystar
//
//  Created by mos on 13-2-19.
//  Copyright (c) 2013年 medev. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helpers)

- (NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                                     (kCFAllocatorDefault,
                                                      (CFStringRef)self,
                                                      NULL,
                                                       CFSTR("!*'();:@&=+$,/?%#[]、"),
                                                    kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding    (kCFAllocatorDefault,
    (CFStringRef)self,
    CFSTR(""),
    kCFStringEncodingUTF8));
    
    return result;
}

@end
