//
//  UIButton+AsyncImage.h
//  Demo
//
//  Created by shwally on 15/3/31.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AsyncImage)
//size by point
- (void)setImageFromURL:(NSString *)urlString
           adjustToSize:(CGSize)size
             completion:(void (^)(void))completion
                   logo:(UIImage *)logoImage;
@end
