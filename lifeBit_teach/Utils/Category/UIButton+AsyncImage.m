//
//  UIButton+AsyncImage.m
//  Demo
//
//  Created by shwally on 15/3/31.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import "UIButton+AsyncImage.h"

@implementation UIButton (AsyncImage)

- (void)setImageFromURL:(NSString *)urlString
           adjustToSize:(CGSize)size
             completion:(void (^)(void))completion
                   logo:(UIImage *)logoImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        
        if (image) {
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                image = [UIImage imageWithCGImage:image.CGImage scale:[self scaleImage:image adjustToSize:size] orientation:image.imageOrientation];
            }
            if (logoImage) {
                image = [self addLogoImage:logoImage toImage:image];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:image forState:UIControlStateNormal];
                completion();
            });
        }
        else {
            NSLog(@"async load error.");
        }
    });
}

// 缩放图片以适应按钮大小
- (CGFloat)scaleImage:(UIImage *)image
         adjustToSize:(CGSize)size
{
    CGFloat xScale = size.width / image.size.width;
    CGFloat yScale = size.height / image.size.height;
    
    return 1.0 / MIN(xScale, yScale);
}

- (UIImage *)addLogoImage:(UIImage *)logo
                  toImage:(UIImage *)img
{
    //get image width and height
    CGFloat scale = [UIScreen mainScreen].scale;
    int w = scale * img.size.width;
    int h = scale * img.size.height;
    int logoWidth = logo.scale * logo.size.width;
    int logoHeight = logo.scale * logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake(w - logoWidth, 0, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked scale:scale orientation:img.imageOrientation];
}

@end
