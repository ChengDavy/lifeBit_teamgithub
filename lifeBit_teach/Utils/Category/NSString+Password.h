//
//  NSString+Password.h
//  Demo
//
//  Created by shwally on 15/1/22.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Password)

/**
 *  32位MD5加密
 *
 *  @return 32位MD5加密结果
 */
- (NSString *)MD5;

/**
 *  SHA1加密
 *
 *  @return SHA1加密结果
 */
- (NSString *)SHA1;

@end
