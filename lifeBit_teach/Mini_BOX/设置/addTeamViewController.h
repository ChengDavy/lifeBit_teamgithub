//
//  addTeamViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/28.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface addTeamViewController : HJBaseVC

#pragma mark 传值

@property (nonatomic , assign) BOOL isNew;

@property (nonatomic , strong) NSString * groupId;


@property (nonatomic , strong) NSMutableDictionary * PushDict;





@property (nonatomic , strong) MiGroupModel * Migroupmodel;

@property (nonatomic , strong) CGroupModel * groupmodel;

@property (weak, nonatomic) IBOutlet UIImageView *MyHeadPic;

@property (weak, nonatomic) IBOutlet UILabel *tittleLa;
@property (weak, nonatomic) IBOutlet UIButton *doneBu;
@property (weak, nonatomic) IBOutlet UITextField *teamName;
@property (weak, nonatomic) IBOutlet UITextField *sportName;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottLayout;
@property (weak, nonatomic) IBOutlet UIButton *addteamer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bomlay;

@property (weak, nonatomic) IBOutlet UIView *addTeamerback;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *ageF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSele;
@property (weak, nonatomic) IBOutlet UITextField *highF;
@property (weak, nonatomic) IBOutlet UITextField *weightF;
@property (weak, nonatomic) IBOutlet UIView *watchBac;

@property (weak, nonatomic) IBOutlet UIView *exchangback;
@property (weak, nonatomic) IBOutlet UIButton *flashWatch;

@property (weak, nonatomic) IBOutlet UIButton *W1;
@property (weak, nonatomic) IBOutlet UIButton *W2;
@property (weak, nonatomic) IBOutlet UIButton *W3;
@property (weak, nonatomic) IBOutlet UIButton *W4;
@property (weak, nonatomic) IBOutlet UIButton *W5;
@property (weak, nonatomic) IBOutlet UIButton *W6;
@property (weak, nonatomic) IBOutlet UIButton *W7;
@property (weak, nonatomic) IBOutlet UIButton *W8;
@property (weak, nonatomic) IBOutlet UIButton *W9;
@property (weak, nonatomic) IBOutlet UIButton *W10;
@property (weak, nonatomic) IBOutlet UIButton *W11;
@property (weak, nonatomic) IBOutlet UIButton *W12;

@property (weak, nonatomic) IBOutlet UIButton *exchangeDone;

@property (weak, nonatomic) IBOutlet UIView *seleBack;


@end
