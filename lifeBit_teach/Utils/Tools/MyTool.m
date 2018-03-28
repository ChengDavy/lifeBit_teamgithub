//
//  MyTool.m
//  ZhongYiyao
//
//  Created by XCGS on 15/8/18.
//  Copyright (c) 2015年 XCGS. All rights reserved.
//

#import "MyTool.h"
#import "DefineUtils.h"
#import <CoreText/CoreText.h>


@implementation MyTool

/** 字符串取颜色 */
+ (UIColor *)ColorWithColorStr:(NSString *)colorStr{
    unsigned long color = strtoul([colorStr UTF8String],0,16);
    
    UIColor * themeColor=UIColorFromHEX(color);
    
    return themeColor;
  
}
/** 获取机器信息 */
+(NSDictionary*) GetPhoneMessage{
    
   NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    
    NSLog(@"%@",infoDict);
    
    return infoDict;
}

/** 获取设备推送 deviceToken */
+ (NSString *)getDeviceToken
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"kDeviceToken"];
    if ([self strExistence:str]) {
        return str;
    }
    else {
        return @"";
    }
}

/** appstroe版本更新 */
+ (void)onCheckVersion
{
    
}

/** 删除NSUserDefaults所有记录 */
+ (void)removeUserDefaultsRecords
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults dictionaryRepresentation];  // get all value and key in userDefault
    for (id key in dict) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

/** 使用正则表达式去掉html中的标签元素,获得纯文本 */
+ (NSMutableArray *)regularExpretionWithHtmlStr:(NSString *)htmlStr
{
    NSRegularExpression *regularExpretion =
    [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                              options:0
                                                error:nil];
    // 替换所有html和换行匹配元素为"-"
    htmlStr = [regularExpretion stringByReplacingMatchesInString:htmlStr
                                                         options:NSMatchingReportProgress
                                                           range:NSMakeRange(0, htmlStr.length)
                                                    withTemplate:@"-"];
    // 把多个"-"匹配为一个"-"
    regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"-{1,}"
                                                                 options:0
                                                                   error:nil];
    htmlStr = [regularExpretion stringByReplacingMatchesInString:htmlStr
                                                         options:NSMatchingReportProgress
                                                           range:NSMakeRange(0, htmlStr.length)
                                                    withTemplate:@"-"];
    // 根据"-"分割到数组
    NSArray *arr = [NSArray array];
    htmlStr = [NSString stringWithString:htmlStr];
    arr = [htmlStr componentsSeparatedByString:@"-"];
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:arr];
    
    return arrM;
}

+ (void)showAlertViewWithStr:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:str
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}


/** cookie */
+ (void)addCookie:(NSString *)session
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:@"" forKey:NSHTTPCookieDomain];
    [properties setObject:@"/" forKey:NSHTTPCookiePath];
    [properties setObject:@"__SESSION_USER_TOKEN" forKey:NSHTTPCookieName];
    [properties setObject:@"" forKey:NSHTTPCookieValue];
    [properties setObject:[[NSDate date] dateByAddingTimeInterval:26297430] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage setCookie:cookie];
    for (NSHTTPCookie *cookie in storage.cookies) {
        NSLog(@"cookie = %@", cookie);  // check cookie
        [storage deleteCookie:cookie];  // delete cookie
    }
}


/** 注册密码格式是否正确(6-16个字符组成，可使用数字、英文字母、下划线， 密码区分大小写) */
+ (BOOL)passwordIsLegal:(NSString *)password
{
    NSString *Regex = @"^[0-9A-Za-z_]{6,16}$";
    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL bPass = [emailCheck evaluateWithObject:password];
    return bPass;
}

/** 邮箱格式是否正确 */
+ (BOOL)emailIsLegal:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailCheck evaluateWithObject:email];
}

/** 是否数字字符串 */
+ (BOOL)strIsNumber:(NSString *)str
{
    NSString *emailRegex = @"[0-9]*";
    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailCheck evaluateWithObject:str];
}

/** 用户名格式是否正确 */
+ (BOOL) UserNameIsLegal:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,16}+$";//6到20位
    NSPredicate *userNameCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    return [userNameCheck evaluateWithObject:name];
    return YES;
}

/** 手机格式是否正确 */
+ (BOOL)phoneNumberIsLegal:(NSString *)mobile
{
    NSString *phoneNumRegex = @"^[1][3-8]\\d{9}$";
    NSPredicate *mobileCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumRegex];
    return [mobileCheck evaluateWithObject:mobile];
}

// 身份证格式是否正确
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/** string是否为空 */
+ (BOOL)strIsEmpty:(NSString *)str
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    if ([str stringByTrimmingCharactersInSet:whiteSpace].length == 0) {
        return YES;
    }
    return NO;
}

/** 字符串是否有效   YES 合法的值  NO 不合法 */
+ (BOOL)strExistence:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    NSCharacterSet *space = [NSCharacterSet whitespaceCharacterSet];
    
    if (string && [string stringByTrimmingCharactersInSet:space].length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

/** 禁止表情输入 */
+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}


/** 把十六进制颜色值转化  参数:十六进制颜色值 */
+ (UIColor *)colorWithString:(NSString *)hexColor
{
    NSAssert(hexColor.length == 6, @"参数 hexColor 长度必须等于6");
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

/** label高度自适应  参数: 文本text,字体,label的宽度 */
+ (CGFloat)heightOfLabel:(NSString *)strText forFont:(UIFont *)font labelLength:(CGFloat)length
{
    CGSize size;
    
    if (kVersion >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        size = [strText boundingRectWithSize:CGSizeMake(length, 0)
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    }else {
        size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(length, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    return size.height;
}

/** label宽度自适应  */
+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font labelHeight:(CGFloat)height
{
    CGSize size;
    if (kVersion >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        size = [strText boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    else {
        size = [strText sizeWithFont:font];
    }
    
    return size.width;
}

/** label显示html格式*/
+ (NSAttributedString *)changeWithHtmlStr:(NSString *)str;
{
    NSString *htmlStr = str;
    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithData:data
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                                                      }
                                 documentAttributes:nil
                                              error:nil];
    [attrStr addAttribute:(NSString *)kCTFontAttributeName
                    value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:13].fontName,
                                                                     13,
                                                                     NULL))
                    range:NSMakeRange(0, attrStr.length)];   // font
    [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
                    value:(id)[UIColor lightGrayColor].CGColor
                    range:NSMakeRange(0, attrStr.length)];  // color
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 10.f;
    paragraphStyle.maximumLineHeight = 20.f;
    paragraphStyle.lineHeightMultiple = 1.0f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : paragraphStyle};
    [attrStr addAttributes:attributtes
                     range:NSMakeRange(0, attrStr.length)]; //  设置段落样式
    
    return attrStr;
}

/** 获取当前时间 */
+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *str = nil;
    str = [formatter stringFromDate:date];
    return str;
}

/** 日期转化星期 */
+ (NSString *)getWeekFromDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[year integerValue]];
    [components setMonth:[month integerValue]];
    [components setDay:[day integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [gregorian setTimeZone:timeZone];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [weekdayComponents weekday]-1;
    
    NSString *str = nil;
    switch (weekday) {
        case 1:{
            str = @"星期一";
        }
            break;
        case 2:{
            str = @"星期二";
        }
            break;
        case 3:{
            str = @"星期三";
        }
            break;
        case 4:{
            str = @"星期四";
        }
            break;
        case 5:{
            str = @"星期五";
        }
            break;
        case 6:{
            str = @"星期六";
        }
            break;
        case 0:{
            str = @"星期日";
        }
            break;
        default:
            break;
    }
    
    return str;
}

/** 格式化的JSON格式的字符串转换字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    // 把数据序列化
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"解析失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
        return nil;
    }
    
    return dict;
}



/** 取图片 */
+ (UIImage *)imageWithName:(NSString *)imageName
{
    NSString *name = [NSString stringWithFormat:@"%@@2x.png", imageName];
    NSString * filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"" inDirectory:nil];
    UIImage* img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

/** 绘制UIImage */
+ (UIImage *)captureView:(UIView *)theView
{
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/** 截取部分图像 */
+ (UIImage *)getSubImage:(CGRect)rect withImage:(UIImage *)image
{
    rect.size.width = rect.size.width * 2;
    rect.size.height = rect.size.height * 2;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

/** private */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/** 图片等比例缩放 */
+ (UIImage *)scaleToSize:(CGSize)size withImage:(UIImage *)image
{
    UIImage *scaleImage = nil;
    
    UIImage *img = [MyTool fixOrientation:image];
    scaleImage = [self cutOutNewImage:img withScale:1.0];
    UIGraphicsBeginImageContext(size);
    [scaleImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *transformImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transformImage;
}

/** 图片截取 */
+ (UIImage *)cutOutNewImage:(UIImage *)originalImage withScale:(CGFloat)scale
{
    //定义myImageRect，截图的区域
    if (!originalImage) {
        return nil;
    }
    
    CGRect myImageRect;
    CGSize size;
    CGFloat orignalHeight = originalImage.size.height;
    CGFloat orignalWidth  = originalImage.size.width;
    
    if (orignalWidth/orignalHeight == scale) {
        return originalImage;
    }
    else if (orignalWidth/orignalHeight > scale) {
        myImageRect = CGRectMake((orignalWidth-orignalHeight*scale)/2, 0, orignalHeight*scale, orignalHeight);
        size.width = orignalHeight * scale;
        size.height = orignalHeight;
    }
    else{
        myImageRect = CGRectMake(0, 0, orignalWidth, orignalWidth/scale);
        size.width = orignalWidth;
        size.height = orignalWidth/scale;
    }
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

/* 按最短边 等比压缩 */
+(UIImage *)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if(width < newSize.width && height < newSize.height)
    {
        return image;
    }
    else
    {
        return [self imageWithImage:image ratioToSize:newSize];
    }
}

//等比缩放
+(UIImage *)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    float verticalRadio = newSize.height/height;
    float horizontalRadio = newSize.width/width;
    float radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    width = width*radio;
    height = height*radio;
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(width,height)];
}

//缩放
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 计算缓存大小 */
+ (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}

#pragma mark - 计算缓存文件的大小的M
+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){

        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}
/** 用户ID转环信ID */
+ (NSString *)EasemoIdbyUserId:(NSString *)userId{
    
    NSString * EasemoId=[userId stringByReplacingOccurrencesOfString:@"@"withString:@"_.."];
    
    return EasemoId;
}

/** 环信ID转用户ID */
+ (NSString *)UserIDbyEasemoId:(NSString *)easemoId{
    
    NSString * userId=[easemoId stringByReplacingOccurrencesOfString:@"_.."withString:@"@"];
    
    return userId;
    
}
/** 用户ID组转环信ID组 */
+ (NSArray *)EasemoIdArrybyUserId:(NSArray *)userIdArry{
    NSMutableArray * EasemoIdArry=[[NSMutableArray alloc]init];
    
    for (int i = 0; i <userIdArry.count; i++) {
        [EasemoIdArry addObject:[self EasemoIdbyUserId:userIdArry[i]]];
    }
    return EasemoIdArry;
    
}

/** 环信ID组转用户ID组 */
+ (NSArray *)UserIDArrybyEasemoId:(NSArray *)easemoIdArry{
    NSMutableArray * userIdArry=[[NSMutableArray alloc]init];
    for (int i = 0; i <easemoIdArry.count; i++) {
        [userIdArry addObject:[self EasemoIdbyUserId:easemoIdArry[i]]];
    }
    return userIdArry;
}

// wifiIP
+ (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


// 字符串转十六进制
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}


// 十六进制转字符串
+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


/** 字典去NULL */

+ (NSDictionary *)dictionaryWithDictRemoveNull:(NSDictionary *)dict{

    NSMutableDictionary * MDict=[[NSMutableDictionary alloc]init];
    
    NSArray * KeyArry=[dict allKeys];
    
    for (int i = 0; i<KeyArry.count; i++) {
        
        NSString * dictStr=[NSString stringWithFormat:@"%@",[dict objectForKeyNotNull:KeyArry[i]]];
        dictStr=[dictStr stringByReplacingOccurrencesOfString:@"<null>" withString:@" "];
        
        dictStr=[dictStr stringByReplacingOccurrencesOfString:@"<NULL>" withString:@" "];
        [MDict setObject:dictStr forKey:KeyArry[i]];
  
    }
    
    NSLog(@"%@     %@",dict , MDict);
    
    return MDict;
//    
//    
//    
//    
//    
//    NSString * dictStr=[NSString stringWithFormat:@"%@",dict];
//    
//    dictStr=[dictStr stringByReplacingOccurrencesOfString:@"<null>" withString:@" "];
//    
//    dictStr=[dictStr stringByReplacingOccurrencesOfString:@"<NULL>" withString:@" "];
//    
//    dictStr=[dictStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    dictStr=[dictStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSLog(@"%@",dictStr);
//    
//    NSDictionary * dict2=[self dictionaryWithJsonString:dictStr];
//    
//    return dict2;
}

/** 数组去NULL */

+ (NSArray  *)arryWithArryRemoveNull:(NSArray *)arry{
    
    NSString * arryStr=[NSString stringWithFormat:@"%@",arry];
    
    [arryStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    [arryStr stringByReplacingOccurrencesOfString:@"<NULL>" withString:@""];
    
//    NSArray * arry2=[self :arryStr];

    
    return arry;
}

//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
    
    [preferences synchronize];
}

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}

@end
