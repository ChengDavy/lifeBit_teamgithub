//
//  DetailsViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/28.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface DetailsViewController : HJBaseVC

@property (nonatomic , strong) NSMutableDictionary * PushDict;

@property (nonatomic , strong) NSString * testId;

@property (weak, nonatomic) IBOutlet UIView *headBackVie;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *dateLa;
@property (weak, nonatomic) IBOutlet UILabel *sportMode;
@property (weak, nonatomic) IBOutlet UILabel *timeLa;
@property (weak, nonatomic) IBOutlet UILabel *heartAv;
@property (weak, nonatomic) IBOutlet UILabel *heartMax;
@property (weak, nonatomic) IBOutlet UILabel *stepLa;
@property (weak, nonatomic) IBOutlet UILabel *caloLa;
@property (weak, nonatomic) IBOutlet UILabel *sportQd;
@property (weak, nonatomic) IBOutlet UILabel *sportMd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomlay;
@property (weak, nonatomic) IBOutlet UIImageView *demoimage;


@end
