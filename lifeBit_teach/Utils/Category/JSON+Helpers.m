//
//  JSON+Helpers.m
//  mystar
//
//  Created by mos on 13-2-22.
//  Copyright (c) 2013年 medev. All rights reserved.
//

#import "JSON+Helpers.h"

@implementation NSDictionary (Utility)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
    if ( [[self allKeys]containsObject:key] ) {
     
        
    }else{
        return @"";
    }
    
    id object = [self objectForKey:key];
    
    if (object == [NSNull null]){
        return @" ";
    }
    return object;
}

@end