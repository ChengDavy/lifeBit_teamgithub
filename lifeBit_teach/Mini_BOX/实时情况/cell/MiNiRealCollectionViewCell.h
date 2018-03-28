//
//  MiNiRealCollectionViewCell.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/29.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiNiRealCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *sportH;
@property (weak, nonatomic) IBOutlet UILabel *heart;
@property (weak, nonatomic) IBOutlet UILabel *step;

@end
