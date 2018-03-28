//
//  scanViewController.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/11.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@protocol ScanDelegate <NSObject>

- (void)scanData:(NSString *)message;

@end

@interface scanViewController : HJBaseVC

@property(nonatomic,assign)id<ScanDelegate>delegate;

@property (nonatomic , strong) NSMutableDictionary * PushDict;

@property (nonatomic , strong) NSString * watchNo;

@property (nonatomic , strong) NSString * oldMac;

@end
