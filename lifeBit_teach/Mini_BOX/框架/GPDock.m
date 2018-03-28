//
//  GPDock.m
//  sideDemo
//
//  Created by 程党威 on 2017/8/22.
//  Copyright © 2017年 程党威. All rights reserved.
//

#import "GPDock.h"

@implementation GPDock

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //自动伸缩高度可伸缩，右边距可以伸缩
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        //设置背景图片
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackView"]];
        
        UILabel * logo = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 100, 20)];
        logo.textColor = [UIColor whiteColor];
        logo.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
        logo.transform = matrix;
        logo.text = @"Life Team";
        
        [self addSubview:logo];
//        self.backgroundColor=[UIColor orangeColor];
        [self addTabItems];
    }
    return self;
}

- (void)addTabItems
{
    //开始介绍
    [self addSingleTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"开始@2x.png" tittle:@"开始介绍" weight:1];
    
    //实时情况
    [self addSingleTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"实时情况@2x.png" tittle:@"实时情况" weight:2];
    
    //运动统计
    [self addSingleTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"运动统计@2x.png" tittle:@"运动统计" weight:3];
    
    // 历史记录
    [self addSingleTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"历史记录@2x.png" tittle:@"历史记录" weight:4];
    // 设置
    [self addSingleTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"设置@2x.png" tittle:@"设置" weight:5];
    
    // 教练设置
    [self addSingleTeachTab:@"blackView.png" selectedImage:@"selectback.png" icon:@"教练设置@2x.png" tittle:@"教练设置" weight:6];
    
}
-(void)jumpToViewByTag:(NSInteger)tag{
    
    GPTabItem *tabItem = (GPTabItem *) [self viewWithTag:tag];
    
    [self tabItemTouchEvent:tabItem];
    
}

- (void)addSingleTab:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage icon:(NSString *)icon tittle:(NSString *)tittle weight:(int)weight
{
    GPTabItem *tabItem=[[GPTabItem alloc]init];
    [tabItem setBackgroundImage:backgroundImage];
    [tabItem setSelectedImage:selectedImage];

    //设置位置
    tabItem.frame = CGRectMake(0, GPDockItemHeight * (weight-1)+64, 0, 0);
    
    
    UIImageView * imageW = [[UIImageView alloc]initWithFrame:CGRectMake(28, 28, 44, 44)];
    imageW.image =[UIImage imageNamed:icon];
    
    [tabItem addSubview:imageW];
    
    UILabel * tittleLb =[[UILabel alloc ]initWithFrame:CGRectMake(0, 85, GPDockItemWidth   , 30)];
    tittleLb.textAlignment=NSTextAlignmentCenter;
    tittleLb.textColor = [UIColor whiteColor];
    tittleLb.font = [UIFont systemFontOfSize:17];
    
    tittleLb.text = tittle;
    
    [tabItem addSubview:tittleLb];
    
    //设置选中触摸选中事件
    [tabItem addTarget:self action:@selector(tabItemTouchEvent:) forControlEvents:UIControlEventTouchDown];
    if (weight ==1) {
        [self tabItemTouchEvent:tabItem];
    }
    tabItem.tag = weight - 1;
    [self addSubview:tabItem];
    
}
- (void)addSingleTeachTab:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage icon:(NSString *)icon tittle:(NSString *)tittle weight:(int)weight
{
    GPTabItem *tabItem=[[GPTabItem alloc]init];
    [tabItem setBackgroundImage:backgroundImage];
    [tabItem setSelectedImage:selectedImage];
    
    //设置位置
    tabItem.frame = CGRectMake(0, kMainScreenHeitht-GPDockItemHeight, 0, 0);
    
    
    UIImageView * imageW = [[UIImageView alloc]initWithFrame:CGRectMake(28, 28, 44, 44)];
    
    imageW.image =[UIImage imageNamed:icon];
    
    [tabItem addSubview:imageW];
    
    UILabel * tittleLb =[[UILabel alloc ]initWithFrame:CGRectMake(0, 85, GPDockItemWidth , 30)];
    tittleLb.textAlignment=NSTextAlignmentCenter;
    tittleLb.textColor = [UIColor whiteColor];
    tittleLb.font = [UIFont systemFontOfSize:17];
    
    tittleLb.text = tittle;
    
    [tabItem addSubview:tittleLb];
    
    //设置选中触摸选中事件
    [tabItem addTarget:self action:@selector(tabItemTouchEvent:) forControlEvents:UIControlEventTouchDown];
    if (weight ==1) {
        [self tabItemTouchEvent:tabItem];
    }
    tabItem.tag = weight - 1;
    [self addSubview:tabItem];
    
}


//设置触摸事件
- (void)tabItemTouchEvent:(GPTabItem *)tabItem
{
    
    if ([self.dockDelegate respondsToSelector:@selector(switchMainByTabItem:originalTab:destinationTab:)]) {
        [self.dockDelegate switchMainByTabItem:self originalTab:selectedTabItem.tag destinationTab:tabItem.tag];
    }
    selectedTabItem.enabled=YES;
    tabItem.enabled = NO;
    //将当前选中的赋值
    selectedTabItem =tabItem;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
