//
//  UIView+ZKPulseView.h
//  Demo
//
//  Created by shwally on 15/3/30.
//  Copyright (c) 2015年 shwally. All rights reserved.
//  View亮灯效果

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>

@interface UIView (ZKPulseView)

/*
 * To remove all pulse effect if you have any.
 *
 */
-(void) stopPulseEffect;

/*
 * Start to pulse by using default color, which is the background color's reversed color
 *
 */
-(void) startPulse;

/*
 * Start to pulse by providing needed pulse color.
 *
 */
-(void) startPulseWithColor:(UIColor *)color;

/*
 * The must underneeth method to create the pulse effect, you can use that for your own purposes
 *
 */
-(void) startPulseWithColor:(UIColor *)color offset:(CGSize) offset frequency:(CGFloat) freq;

@end
