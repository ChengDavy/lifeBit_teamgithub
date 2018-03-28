//
//  ZXView.h
//  折线图
//
//  Created by iOS on 16/6/28.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TimeType) {
    Time30               = 0, // 30分钟
    Time60               = 1, // 60分钟
    Time90               = 2, // 90分钟
};

@interface ZXView : UIView
@property (nonatomic,strong)NSString * testID;
@property (nonatomic,strong)NSString * teamerID;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setViewTimeType:(TimeType)timeType;

#pragma mark - 加载demo 数据
- (void)loadDemoData;

#pragma mark - 加载测试数据
- (void)loadData:(NSArray *)dataArry Animated:(BOOL)animated timeLong:(NSInteger)timelong;
@end
