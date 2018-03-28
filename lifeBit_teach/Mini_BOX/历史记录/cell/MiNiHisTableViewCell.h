//
//  MiNiHisTableViewCell.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/25.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiNiHisTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *dateLa;
@property (weak, nonatomic) IBOutlet UILabel *sportMode;
@property (weak, nonatomic) IBOutlet UILabel *sportTime;
@property (weak, nonatomic) IBOutlet UILabel *avsHeart;
@property (weak, nonatomic) IBOutlet UILabel *maxHeart;
@property (weak, nonatomic) IBOutlet UILabel *avsStep;
@property (weak, nonatomic) IBOutlet UILabel *sportQD;
@property (weak, nonatomic) IBOutlet UILabel *sportMD;
@property (weak, nonatomic) IBOutlet UILabel *calorie;

@end
