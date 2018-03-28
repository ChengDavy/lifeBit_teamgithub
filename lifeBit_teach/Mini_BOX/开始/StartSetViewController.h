//
//  StartSetViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "NSTimer+Expand.h"

@interface StartSetViewController : HJBaseVC
@property (weak, nonatomic) IBOutlet UIView *selectBack;
@property (weak, nonatomic) IBOutlet UIView *backDateB;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end
