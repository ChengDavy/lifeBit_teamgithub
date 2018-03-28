//
//  MiWatchManager.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/18.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiWatchManager : NSObject

@property (nonatomic,strong) NSString * macID;

@property (nonatomic,strong) NSString * watchNo;

@property (nonatomic,strong) NSString * testID;

@property (nonatomic,strong) NSString * teamberID;

@property (nonatomic,strong) NSString * groupID;

@property (nonatomic,strong) NSString * beganTime;

@property (nonatomic,strong) NSMutableArray * watchArry;

@property (nonatomic,assign) NSInteger errorTimes;

@property (nonatomic,assign) NSInteger stepSeconds ;

@property (nonatomic,assign) NSInteger totalheart ;

@property (nonatomic,assign) NSInteger totalheartNo ;

- (void)setwatch;

- (void)getWatch;

- (void)getEndData;




@end
