//
//  MiTeamerViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"


@interface MiTeamerViewController : HJBaseVC

@property (nonatomic,strong) NSDictionary * pushDict;

@property (nonatomic,assign) teamerShowType ShowType;

@property (nonatomic,strong) NSMutableArray * watchArry;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *sportMode;
@property (weak, nonatomic) IBOutlet UILabel *timelong;
@property (weak, nonatomic) IBOutlet UILabel *sportQD;
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UILabel *heart;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *miniName;
@property (weak, nonatomic) IBOutlet UIView *middeBack;
@property (weak, nonatomic) IBOutlet UIView *headBack;
@property (weak, nonatomic) IBOutlet UIView *footBack;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *NO1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layer1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Nulayer1;
@property (weak, nonatomic) IBOutlet UILabel *time1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *NO2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layer2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Nulayer2;
@property (weak, nonatomic) IBOutlet UILabel *time2;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *NO3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layer3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Nulayer3;
@property (weak, nonatomic) IBOutlet UILabel *time3;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *NO4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layer4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Nulayer4;
@property (weak, nonatomic) IBOutlet UILabel *time4;

@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UILabel *NO5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layer5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Nulayer5;
@property (weak, nonatomic) IBOutlet UILabel *time5;

















@end
