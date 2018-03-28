//
//  addTeamTableViewCell.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/28.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addTeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *changeB;
@property (weak, nonatomic) IBOutlet UIButton *deleteB;

@end
