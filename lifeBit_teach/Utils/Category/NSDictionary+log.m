//
//  NSDictionary+log.m
//  mystart
//
//  Created by shwally on 15/1/29.
//  Copyright (c) 2015年 medev. All rights reserved.
//

#import "NSDictionary+log.h"

@implementation NSDictionary (log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}

@end
