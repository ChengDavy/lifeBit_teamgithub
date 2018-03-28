//
//  endDataViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/9.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"


@protocol Updatadelegate <NSObject>

- (void)upData:(NSString *)testId;

@end

@interface endDataViewController : HJBaseVC

@property(nonatomic,assign)id<Updatadelegate>delegate;

@property(nonatomic,copy)NSString * testId;

@end
