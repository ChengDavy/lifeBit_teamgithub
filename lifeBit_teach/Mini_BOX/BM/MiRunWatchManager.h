//
//  MiRunWatchManager.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/19.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiRunWatchManager : NSObject

+(instancetype)shareInstance;

@property (nonatomic,strong) CTestModel * cTestModel;

@property (nonatomic,strong) MiTestModel * testModel;

@property (nonatomic,strong) NSString * testId;

@property (nonatomic,strong) NSString * timePoint;

@property (nonatomic,strong) NSMutableArray * testArry;

@property (nonatomic,strong) NSMutableArray * watchArry;

@property (nonatomic,strong) NSMutableArray * unconnArry;

@property (nonatomic,strong) NSMutableArray * ManagerArry;

@property (nonatomic,assign) BOOL isRuning;

//监听启动完成开始请求数据

- (void)linkheart:(NSNotification * )not;

//设置倒计时

- (void)setTimer:(NSString *)testId;

//启动手表

-(void)setWatchModel;

//获取心跳
- (void)getHeartfromWatch;

//获取步数
- (void)getStepfromWatch;


//结束手表

-(void)endWatchModel;

//结束手表

-(void)reSetWatchModel;

// 恢复手表测试

- (void)reStartTest;

// praise

- (void)praise;


// 项目结束后处理数据

-(void)dealHeartWithTestID:(NSString*)testID;



@end


