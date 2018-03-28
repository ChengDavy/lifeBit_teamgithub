//
//  classNoteViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/1.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface classNoteViewController : HJBaseVC
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *updown;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) NSDictionary * pushDict;

@end
