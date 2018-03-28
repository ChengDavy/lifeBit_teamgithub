//
//  MiNiCoachSetViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface MiNiCoachSetViewController : HJBaseVC
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIm;
@property (weak, nonatomic) IBOutlet UIImageView *emailIm;
@property (weak, nonatomic) IBOutlet UIImageView *ipadIm;
@property (weak, nonatomic) IBOutlet UIImageView *passIm;

@property (weak, nonatomic) IBOutlet UITextField *nameT;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UITextField *emailT;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *ipadId;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIView *backView3;
@property (weak, nonatomic) IBOutlet UIImageView *headBack;

@end
