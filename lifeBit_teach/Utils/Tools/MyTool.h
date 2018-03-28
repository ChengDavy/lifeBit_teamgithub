//
//  MyTool.h
//  ZhongYiyao
//
//  Created by XCGS on 15/8/18.
//  Copyright (c) 2015年 XCGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface MyTool : NSObject

/** 字符串取颜色 */
+ (UIColor *)ColorWithColorStr:(NSString *)colorStr;
/** 获取机器mac地址 */
+ (NSString *)getUUIDString;

/** 获取机器UUID */
+(NSString*) GetIOSUUID;

/** 获取机器信息 */
+(NSDictionary*) GetPhoneMessage;

/** 获取设备推送 deviceToken */
+ (NSString *)getDeviceToken;

/** appstroe版本更新 */
+ (void)onCheckVersion;

/** 删除NSUserDefaults所有记录 */
+ (void)removeUserDefaultsRecords;

/** 使用正则表达式去掉html中的标签元素,获得纯文本 */
+ (NSMutableArray *)regularExpretionWithHtmlStr:(NSString *)htmlStr;

+ (void)showAlertViewWithStr:(NSString *)str;


/** 邮箱格式是否正确 */
+ (BOOL)emailIsLegal:(NSString *)email;

/** 是否数字字符串 */
+ (BOOL)strIsNumber:(NSString *)str;

/** 用户名格式是否正确 */
+ (BOOL) UserNameIsLegal:(NSString *)name;

/** 手机格式是否正确 */
+ (BOOL)phoneNumberIsLegal:(NSString *)mobile;

/** 身份证格式是否正确 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/** 注册密码格式是否正确 */
+ (BOOL)passwordIsLegal:(NSString *)password;

/** string是否为空 */
+ (BOOL)strIsEmpty:(NSString *)str;

/** 字符串是否有效   YES 合法的值  NO 不合法 */
+ (BOOL)strExistence:(NSString *)string;

/** 禁止表情输入 */
+ (BOOL)isContainsEmoji:(NSString *)string;

/** cookie */
+ (void)addCookie:(NSString *)session;




/** 把十六进制颜色值转化  参数:十六进制颜色值 */
+ (UIColor *)colorWithString:(NSString *)hexColor;

/** label高度自适应  参数: 文本text,字体,label的宽度 */
+ (CGFloat)heightOfLabel:(NSString *)strText forFont:(UIFont *)font labelLength:(CGFloat)length;

/** label宽度自适应  */
+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font labelHeight:(CGFloat)height;

/** label显示html格式(attributedText) */
+ (NSAttributedString *)changeWithHtmlStr:(NSString *)str;

/** 获取当前时间 */
+ (NSString *)getCurrentTime;

/** 日期转化星期 */
+ (NSString *)getWeekFromDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

/** 格式化的JSON格式的字符串转换字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr;



/** 取图片 */
+ (UIImage *)imageWithName:(NSString *)imageName;

/** 绘制UIImage */
+ (UIImage *)captureView:(UIView *)theView;

/** 截取部分图像 */
+ (UIImage *)getSubImage:(CGRect)rect withImage:(UIImage *)image;

/** 图片等比例缩放 */
+ (UIImage *)scaleToSize:(CGSize)size withImage:(UIImage *)image;

/** 图片截取 */
+ (UIImage *)cutOutNewImage:(UIImage *)originalImage withScale:(CGFloat)scale;

/**按最短边 等比压缩 */
+(UIImage*)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize;

/** wifiIP */
+ (NSString *) localWiFiIPAddress;

/** 计算缓存大小 */
+ (float)folderSizeAtPath:(NSString *)folderPath;

/** 用户ID转环信ID */
+ (NSString *)EasemoIdbyUserId:(NSString *)userId;

/** 环信ID转用户ID */
+ (NSString *)UserIDbyEasemoId:(NSString *)easemoId;

/** 用户ID组转环信ID组 */
+ (NSArray *)EasemoIdArrybyUserId:(NSArray *)userIdArry;

/** 环信ID组转用户ID组 */
+ (NSArray *)UserIDArrybyEasemoId:(NSArray *)easemoIdArry;

/** 字符串转十六进制 */
+ (NSData *)convertHexStrToData:(NSString *)str;

/** 十六进制转字符串 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

/** 字典去NULL */

+ (NSDictionary *)dictionaryWithDictRemoveNull:(NSDictionary *)dict;

/** 数组去NULL */

+ (NSArray  *)arryWithArryRemoveNull:(NSArray *)arry;
//将图片保存到本地

+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;

//本地是否有相关图片

+ (BOOL)LocalHaveImage:(NSString*)key;

//从本地获取图片

+ (UIImage*)GetImageFromLocal:(NSString*)key;

@end
