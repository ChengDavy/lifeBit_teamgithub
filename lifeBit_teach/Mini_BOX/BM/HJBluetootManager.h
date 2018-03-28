//
//  HJBluetootManager.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMLifeBitBlueTools.h"
#import "LBWatchPerModel.h"

@interface HJBluetootManager : NSObject
+(instancetype)shareInstance;
@property(nonatomic,strong)AMLifeBitBlueTools* blueTools;
@property(nonatomic)LBWatchPerModel* connectingWatch;
@property(nonatomic,copy)NSMutableArray *  connectingArray;
@property(nonatomic,copy)NSMutableArray * ReadyConnectArray;

// 同步完成
@property (nonatomic,assign)BOOL asyncDone;

// 开始搜索
-(void)stepBlueStateChangeBlock;

// 设置同步班级
-(void)syncAssignClassAllWatch:(MiTestModel*)classInfo;

#pragma --mark-- 同步测试项目所有手表进入连续心率模式
// 设置同步测试项目所有手表进入连续心率模式
-(void)syncAssignMitestAllWatch:(MiTestModel*)TestModel;

#pragma --mark-- 同步指定班级所有手表退出
// 设置同步结束班级
-(void)syncCloseAllWatch:(MiTestModel*)classInfo;

//同步点赞所有手表

-(void)praiseAllWatch;

//同步重置所有手表
-(void)closeAllWatch;

//同步重置所有手表
-(void)reSetAllWatch;


-(void)syncAllWatch;


-(void)stopScanWatch;

//停止工作
-(void)stopWorkWithWatch:(LBWatchPerModel*)watch;

// 置回Watch的所有状态
-(void)buyBackAllSyncWatchStatus;

#pragma --mark-- 重新搜索手表
- (void)refreshScanAllWatch;

-(void)registerBlueToothManager;

//添加调用重连手表
- (void)addReConnectWithWatch:(LBWatchPerModel *)watchModel;

//重连手表
- (void)toReConnectWithWatch:(LBWatchPerModel *)watchModel;

// 链接手表
- (void)toConnectWithWatch:(LBWatchPerModel *)watchModel;

// 长连接链接
- (void)longConnectWithWatch:(LBWatchPerModel *)watchModel;

// 长连接重连
- (void)relongConnectWithWatch:(LBWatchPerModel *)watchModel;

// 长连接
- (void)longConnect;


@end
