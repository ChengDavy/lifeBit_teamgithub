//
//  MiNiSTableViewCell.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/25.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiNiSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *heartAv;
@property (weak, nonatomic) IBOutlet UILabel *heartMax;
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UILabel *calor;
@property (weak, nonatomic) IBOutlet UILabel *sportMD;
@property (weak, nonatomic) IBOutlet UILabel *sportQD;

@end
