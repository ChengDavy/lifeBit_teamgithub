//
//  chartView.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/27.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chartView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

-(void)creatViewWithTime:(NSInteger)time;

-(void)setZXView:(NSArray*)dataArry;

- (void)creatTittle:(NSString *)tittle;

#pragma mark - 加载测试数据
- (void)loadData:(NSArray *)dataArry Animated:(BOOL)animated timeLong:(NSInteger)timelong;

@end
