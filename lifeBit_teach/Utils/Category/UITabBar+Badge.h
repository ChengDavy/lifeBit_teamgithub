//
//  UITabBar+Badge.h
//  活动指南
//
//  Created by shwally on 15/4/23.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;

@end
