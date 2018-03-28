//
//  NSArray+Log.m
//  网易新闻侧栏
//
//  Created by qianfeng on 14-10-22.
//  Copyright (c) 2014年 kong. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string=[NSMutableString string];
    
    [string appendFormat:@"%ld (",self.count];
    
    for (NSObject *object in self) {
        [string appendFormat:@"\t%@\n",object];
    }
    
    [string appendFormat:@")"];
    
    return string;
}

@end
