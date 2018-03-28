//
//  MiNiRealViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface MiNiRealViewController : HJBaseVC
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *sportMode;
@property (weak, nonatomic) IBOutlet UILabel *timeRun;
@property (weak, nonatomic) IBOutlet UILabel *sportHi;
@property (weak, nonatomic) IBOutlet UILabel *heart;
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UIView *groupBack;
@property (weak, nonatomic) IBOutlet UIView *groupBack2;
@property (weak, nonatomic) IBOutlet UIButton *endBU;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;

@end
