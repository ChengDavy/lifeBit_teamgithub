//
//  GPDockItem.m
//  sideDemo
//
//  Created by 程党威 on 2017/8/22.
//  Copyright © 2017年 程党威. All rights reserved.
//

#import "GPDockItem.h"

@implementation GPDockItem

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {

        
    }
    return self;
    
}
//设置背景图片
-(void)setBackgroundImage:(NSString *)backgroundImage{
    
    _backgroundImage=backgroundImage;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    
}
//设置选中图片
-(void)setSelectedImage:(NSString *)selectedImage{
    _selectedImage=selectedImage;
     [self setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    
}

-(void)setFrame:(CGRect)frame{
    //固定Item宽高
    frame.size=CGSizeMake(GPDockItemWidth, GPDockItemHeight);
    [super setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
