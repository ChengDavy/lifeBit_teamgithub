//
//  DefineUtils.h
//  Demo
//
//  Created by shwally on 15-1-19.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ApplicationDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)


/** Device */
#define isRetina ([[UIScreen mainScreen] scale]==2)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define isRetinaOld ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS4 ([[[UIDevice currentDevice] systemVersion] intValue]==4)

#define isIOS5 ([[[UIDevice currentDevice] systemVersion] intValue]==5)

#define isIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]==6)

#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]==7.0)

#define isIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]==8.0)

#define isAfterIOS4 ([[[UIDevice currentDevice] systemVersion] intValue] >= 4)

#define isAfterIOS5 ([[[UIDevice currentDevice] systemVersion] intValue] >= 5)

#define isAfterIOS6 ([[[UIDevice currentDevice] systemVersion] intValue] >= 6)

#define IsAfterIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)

#define IsAfterIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)

#define iOSCurrentVersion ([[UIDevice currentDevice] systemVersion])

/** status */
#define StatusbarSize ((IsAfterIOS7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)



/** openURL */
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define openURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])


/** 当前系统版本 */
#define kVersion  [[[UIDevice currentDevice] systemVersion] doubleValue]

/** 当前屏幕高度 */
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height

/** 当前屏幕宽度 */
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

/** 当前屏幕中心点 */
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

/** 设置frame为屏幕大小 */
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

/** 设置RGB颜色 */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/** 十六进制颜色 */
#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]

//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/** 输出frame */
#define LOGRECT(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define LOGBOOL(b)  NSLog(@"%@",b?@"YES":@"NO");

/** 适配 */
#define Swidth ([UIScreen mainScreen].bounds.size.width / 375)
#define Sheight ([UIScreen mainScreen].bounds.size.height / 667)

/** defineLog pattern */
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

