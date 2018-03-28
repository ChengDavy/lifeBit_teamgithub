//
//  HJBluetootManager.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBluetootManager.h"


#define LBLog(fmt, ...) NSLog((@"LBLog: "fmt), ##__VA_ARGS__);


static HJBluetootManager *_bluetootManager = nil;

@interface HJBluetootManager()

@property(nonatomic,strong)NSMutableArray* waitingConnectArray;

@property(nonatomic,strong)NSMutableArray* waitingCleanArray;

@property(nonatomic,strong)NSMutableArray* waitingPraiseArray;

@property(nonatomic)BOOL isAutoSync;

@property (nonatomic,assign)NSInteger errorCount;

// 测试medol
@property (nonatomic,strong) MiTestModel *asynTestModel;

// 同步完成的周边
@property (nonatomic,strong)CBPeripheral *syncSuccess;

@end
@implementation HJBluetootManager


-(void)registerBlueToothManager {
    
    _bluetootManager.waitingConnectArray = [NSMutableArray array];
    _bluetootManager.blueTools = [AMLifeBitBlueTools instance];
    _bluetootManager.isAutoSync = NO;
    
    //配置蓝牙状态更改回调
    [_bluetootManager stepBlueStateChangeBlock];
    
    //配置蓝牙设备断连回调
    [_bluetootManager stepBlueDisConnectBlock];
    
    [self addObserver:self forKeyPath:@"waitingConnectArray" options:NSKeyValueObservingOptionNew context:nil];
}

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bluetootManager = [[HJBluetootManager alloc] init];
        _bluetootManager.asyncDone = NO;
    });
    return _bluetootManager;
}

+(void)destroyInstance {
    
    if (_bluetootManager) {
        _bluetootManager = nil;
    }
}
//当前没有连接中的设备时,自动检测等待队列
-(void)setConnectingWatch:(LBWatchPerModel *)connectingWatch {
    
    if (connectingWatch) {
        _connectingWatch = connectingWatch;
    } else {
        _connectingWatch = nil;

    }
}

// 长连接链接
- (void)longConnectWithWatch:(LBWatchPerModel *)watchModel{
    if (_connectingArray == nil) {
        _connectingArray = [NSMutableArray array];
                            
    }
    if (_ReadyConnectArray == nil) {
        _ReadyConnectArray= [NSMutableArray array];
        
    }
    
    NSLog(@"---------------------------------------待链接: %ld,  conntct: %ld", self.connectingArray.count, [self.connectingArray indexOfObject:watchModel]);
    NSLog(@"---------------------------------------已连接:个数 %ld    %@",self.ReadyConnectArray.count,watchModel.peripheral.name);
    
    __weak HJBluetootManager* blockSelf = self;
    
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
        
        LBLog(@"%@: 长连接成功",watchModel.peripheral.name);
        
        watchModel.type = LBWatchTypeConnected;
        
        [_connectingArray removeObject:watchModel];
        [_ReadyConnectArray addObject:watchModel];
        
        if (_connectingArray.count>0) {
            [blockSelf longConnectWithWatch:[_connectingArray firstObject]];
        }
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"%@: 长连接失败, 重操作",watchModel.peripheral.name);
        [blockSelf longConnectWithWatch:watchModel];
    }];
}

// 长连接重连
- (void)relongConnectWithWatch:(LBWatchPerModel *)watchModel{
    
    if (_connectingArray == nil) {
        _connectingArray = [NSMutableArray array];
        
    }
    if (_ReadyConnectArray == nil) {
        _ReadyConnectArray= [NSMutableArray array];
        
    }

    BOOL isConnect = NO;

    for (int i = 0; i < _ReadyConnectArray.count; i++) {
        
        LBWatchPerModel * readyWatch = [_ReadyConnectArray objectAtIndexWithSafety:i];
        if ([readyWatch.peripheral.name isEqualToString:watchModel.peripheral.name]) {
            
            [_ReadyConnectArray removeObject:readyWatch];
            i--;
        }
    }
    
    if (isConnect == NO) {
        
        watchModel.type = AMLBSyncTypeConnting;
        
        __weak HJBluetootManager* blockSelf = self;
        
        [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
            
            LBLog(@"%@: 长连接成功",watchModel.peripheral.name);
            
            watchModel.type = LBWatchTypeConnected;
            
            [_ReadyConnectArray addObject:watchModel];
            
            NSLog(@"---------------------------------------待连接:个数 %ld    %@",self.connectingArray.count,watchModel.peripheral.name);
            NSLog(@"---------------------------------------已连接:个数 %ld    %@",_ReadyConnectArray.count,watchModel.peripheral.name);

        } andFail:^(NSString * errorStr) {
            LBLog(@"%@: 长连接失败, 重操作",watchModel.peripheral.name);
            [blockSelf relongConnectWithWatch:watchModel];
        }];
    }
    
}

// 长连接
- (void)longConnect{
    
    _ReadyConnectArray = [[NSMutableArray alloc]init];
    _connectingArray = [self.blueTools.scanWatchArray mutableCopy];
    
    if (_connectingArray.count>0) {
        [self longConnectWithWatch:[_connectingArray firstObject]];
    }
}


#pragma --mark-- 同步所有手表进入连续心率模式
// 设置同步班级
-(void)syncAssignClassAllWatch:(MiTestModel*)classInfo {
    
    [self syncAllWatch];
}

#pragma --mark-- 同步所有手表

// 设置同步结束班级
-(void)syncCloseAllWatch:(MiTestModel*)classInfo {
    
    [self praiseAllWatch];
    
    [self performSelector:@selector(closeAllWatch) withObject:[self.waitingCleanArray firstObject] afterDelay:10];

}

#pragma --mark-- 同步测试项目所有手表进入连续心率模式
// 设置同步测试项目所有手表进入连续心率模式
-(void)syncAssignMitestAllWatch:(MiTestModel*)TestModel {
    
    self.asynTestModel = TestModel;
    
    [self syncAllWatch];
}

#pragma --mark--  配置蓝牙状态更变的回调

//配置蓝牙状态更变的回调

-(void)stepBlueStateChangeBlock{
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools setDidUpdateStateBlock:^(CBCentralManager *centralManager) {
        //        NSLog(@"状态改变回调了");
        
        switch (centralManager.state) {
                
            case CBCentralManagerStateUnknown: NSLog( @"蓝牙初始化中...");
                break;
            case CBCentralManagerStateResetting: NSLog(@"Resetting...");
                break;
            case CBCentralManagerStateUnsupported: NSLog(@"您的设备不支持蓝牙");
                break;
            case CBCentralManagerStateUnauthorized: NSLog(@"您的设备蓝牙未授权");
                break;
            case CBCentralManagerStatePoweredOff:{
                
            [blockSelf.blueTools.scanWatchArray removeAllObjects];
                
              NSLog(@"您的设备未打开蓝牙,请打开蓝牙");
                
            }
                break;
            case CBCentralManagerStatePoweredOn: {
                NSLog(@"搜索...");
                if (blockSelf.blueTools.scanWatchArray.count) {
                    blockSelf.isAutoSync = NO;
                    NSLog(@"蓝牙瞬断了");
                    
                    UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"设备蓝牙刚才断开了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                    for (LBWatchPerModel* watch in blockSelf.blueTools.scanWatchArray) {
                        if (watch.type != LBWatchTypeDone && watch.type !=LBWatchTypeUnConnected) {
                            watch.type = LBWatchTypeDisConnected;
                            blockSelf.waitingConnectArray = nil;
                            blockSelf.connectingWatch = nil;
                        }
                    }

                    [blockSelf.blueTools.scanWatchArray removeAllObjects];
                    return ;
                }
                //开始扫描
                
                if (!blockSelf.waitingConnectArray) {
                    blockSelf.waitingConnectArray = [@[] mutableCopy];
                }
                
                [blockSelf.blueTools startScanWithResultBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                    
                    
                    if (peripheral.name && [peripheral.name hasPrefix:@"SmartAM"]) {
                        
                        if ([[LifeBitCoreDataManager shareInstance] efGetBoxIsWatch:[[peripheral.name componentsSeparatedByString:@"-"] objectAtIndex:1]]) {
                            
                            LBWatchPerModel* watch =[LBWatchPerModel watchPerWithPeripheral:peripheral];
                            
                            CBPeripheral * tempPeripheral = nil;
                            
                            for (LBWatchPerModel * watch2 in blockSelf.blueTools.scanWatchArray) {
                                if ([watch2.peripheral.name isEqualToString:peripheral.name]) {
                                     [blockSelf relongConnectWithWatch:watch2];
                                    tempPeripheral = peripheral;
                                    break;
                                }
                            }
                            
                           
                            
                            if (!tempPeripheral) {
                                [blockSelf.blueTools.scanWatchArray addObject:watch];
                                 [blockSelf relongConnectWithWatch:watch];
                                
                            }
                        }
                    }
                    
                }];
                break;
            }
        }
    }];
}
#pragma --mark-- 重新搜索手表
- (void)refreshScanAllWatch {
    
    [self.blueTools startScanWithResultBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        NSLog(@"peripheral.nameperipheral.name    %@",peripheral.name);
        NSLog(@"_ReadyConnectArray.count _ReadyConnectArray.count %ld",_ReadyConnectArray.count);
        
        if (peripheral.name && [peripheral.name hasPrefix:@"SmartAM"]) {
            
            if ([[LifeBitCoreDataManager shareInstance] efGetBoxIsWatch:[[peripheral.name componentsSeparatedByString:@"-"] objectAtIndex:1]]) {
                
                LBWatchPerModel* watch =[LBWatchPerModel watchPerWithPeripheral:peripheral];
                
                CBPeripheral * tempPeripheral = nil;
                
                for (LBWatchPerModel * watch2 in self.blueTools.scanWatchArray) {
                    if ([watch2.peripheral.name isEqualToString:peripheral.name]) {
                        [self relongConnectWithWatch:watch2];
                        tempPeripheral = peripheral;
                        break;
                    }
                }

                if (!tempPeripheral) {
                    [self.blueTools.scanWatchArray addObject:watch];
                    [self relongConnectWithWatch:watch];
                    
                }
            }
        }
        
    }];
    
}

#pragma mark - 同配置蓝牙断连回调
-(void)stepBlueDisConnectBlock{
    
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools setDisconnectPeripheralBlock:^(CBCentralManager *central, LBWatchPerModel * watch) {
        
        
        if (watch.peripheral.name && [watch.peripheral.name hasPrefix:@"SmartAM"]) {
            
            if ([[LifeBitCoreDataManager shareInstance] efGetBoxIsWatch:[[watch.peripheral.name componentsSeparatedByString:@"-"] objectAtIndex:1]]) {
                
                watch.type = AMLBSyncTypeConnting;
                for (int i = 0; i < _ReadyConnectArray.count; i++) {
                    LBWatchPerModel * readyWatch = [_ReadyConnectArray objectAtIndexWithSafety:i];
                    if ([readyWatch.peripheral.name isEqualToString:watch.peripheral.name]) {
                        [_ReadyConnectArray removeObject:readyWatch];
                        i--;
                    }
                }
                
                [blockSelf relongConnectWithWatch:watch];
                
            }
        }
        
//        if (watch.type != LBWatchTypeDone) {
//
//            NSLog(@"异常断开连接%@",watch.peripheral.name);
//            watch.type = LBWatchTypeDisConnected;
//
//            //连接时断开
//            if (watch == blockSelf.connectingWatch) {
//                   NSLog(@"连接时异常导致断开%@",watch.peripheral.name);
//                watch.type = LBWatchTypeDisConnected;
//
//                blockSelf.connectingWatch = nil;
//
//            }
//
//            if ([blockSelf.waitingConnectArray count]) {
//
//                LBWatchPerModel * watch = [blockSelf.waitingConnectArray firstObject];
//
//                if (watch) {
//                    [blockSelf toConnectWithWatch:watch];
//                }
//            }
//
//            if (watch.type == LBWatchTypeSyncHeart) {
//
//                [blockSelf.waitingConnectArray addObject:watch];
//
//                if ([blockSelf.waitingConnectArray count]) {
//
//                    LBWatchPerModel * watch = [blockSelf.waitingConnectArray firstObject];
//
//                    if (watch) {
//                        [blockSelf toReConnectWithWatch:watch];
//                    }
//                }
//            }
//
//        } else {
//
//            NSLog(@"%@: 断开成功",watch.peripheral.name);
//        }
//        if (blockSelf.isAutoSync) {
//
//            [blockSelf syncAllWatch];
//        }
    }];
}

#pragma mark - 同筛选队员对应手表

-(NSMutableArray*)screenWatch:(NSMutableArray*)arry{
    
    NSMutableArray * screenArry = [[NSMutableArray alloc]init];
    
    NSMutableArray * testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:[MiRunWatchManager shareInstance].testId];
    
    for (MiUserTestModel * testModel in testArry) {
        for (LBWatchPerModel * watchPerModel in arry) {
            
            WatchModel * watch = [[LifeBitCoreDataManager shareInstance]efGetWatchModelBYwatchNo:testModel.teamerNo];
            
            if ([[[watchPerModel.peripheral.name componentsSeparatedByString:@"-"] objectAtIndexWithSafety:1] isEqualToString:watch.watchMAC]) {
                
                [screenArry addObject:watchPerModel];
                
            }
        }
    }
    
    return  screenArry;
}


#pragma mark - 同同步所有手表

//------------------------------------- Test watch began

-(void)syncAllWatch {
    
    self.waitingConnectArray = [self screenWatch: self.blueTools.scanWatchArray];
    
    if (self.waitingConnectArray.count) {
        
        [self toConnectWithWatch:[self.waitingConnectArray firstObject]];
        
    }
}

#pragma mark - 同步点赞所有手表

//------------------------------------- Test watch stop
-(void)praiseAllWatch{
    
    self.waitingPraiseArray = [self.blueTools.scanWatchArray mutableCopy];

    
    if (self.waitingPraiseArray.count) {
        
        [self toPraisetWatch:[self.waitingPraiseArray firstObject]];
        
    }
//     [self performSelector:@selector(closeAllWatch) withObject:[self.waitingCleanArray firstObject] afterDelay:10];
}

#pragma mark - 同步重置所有手表

//------------------------------------- Test watch stop

-(void)closeAllWatch {
    
    self.waitingCleanArray = [self.blueTools.scanWatchArray mutableCopy];
    
    if (self.waitingCleanArray.count) {
        
        [self performSelector:@selector(toReSetWatch:) withObject:[self.waitingCleanArray firstObject] afterDelay:0];
        
    }
}

-(void)reSetAllWatch{
    
    self.waitingCleanArray = [self.blueTools.scanWatchArray mutableCopy];
    
    if (self.waitingCleanArray.count) {
        
        [self performSelector:@selector(toReSetWatch:) withObject:[self.waitingCleanArray firstObject] afterDelay:0];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"waitingConnectArray"]) {
        
        if ([self.waitingConnectArray count]) {
            
            LBWatchPerModel * watch = [self.waitingConnectArray firstObject];
            
            if (watch) {
                [self toConnectWithWatch:watch];
            }
        } else {
            
            self.asyncDone = YES;
            
            LBLog(@"当前所有设备已全部同步完成");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"readread" object:nil];
        }
    }
}

#pragma mark 添加调用重连手表
- (void)addReConnectWithWatch:(LBWatchPerModel *)watchModel{
    
    [self.waitingConnectArray addObject:watchModel];
    
    if (self.waitingConnectArray.count) {
        
        [self toReConnectWithWatch:[self.waitingConnectArray firstObject]];
    }
}

#pragma mark 重连表

- (void)toReConnectWithWatch:(LBWatchPerModel *)watchModel {
    NSLog(@"---------------------------------------TotalCount: %ld,  conntct: %ld", self.waitingConnectArray.count, [self.waitingConnectArray indexOfObject:watchModel]);
    
    __weak HJBluetootManager* blockSelf = self;
    
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
        
        LBLog(@"%@: 连接成功",watchModel.peripheral.name);
        watchModel.type = LBWatchTypeConnected;
        [blockSelf toSyncTimeWithWatch:watchModel];
        
        
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"%@: 连接失败, 重操作",watchModel.peripheral.name);
        [self toConnectWithWatch:watchModel];
        
    }];
}

#pragma mark 重连表
- (void)toConnectWithWatch:(LBWatchPerModel *)watchModel {
    
    NSLog(@"---------------------------------------TotalCount: %ld,  conntct: %ld", self.waitingConnectArray.count, [self.waitingConnectArray indexOfObject:watchModel]);
    
    __weak HJBluetootManager* blockSelf = self;
    
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
        
        LBLog(@"%@: 连接成功",watchModel.peripheral.name);
        
        watchModel.type = LBWatchTypeConnected;
        [blockSelf toSyncTimeWithWatch:watchModel];
        
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"%@: 连接失败, 重操作",watchModel.peripheral.name);
        [self toConnectWithWatch:watchModel];
    }];
}

#pragma mark - 手表点赞

-(void)toPraisetWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    LBLog(@"%@: 开始设置显示",watchModel.peripheral.name);
    
    [watchModel orderSetShowMode:ShowModePraiseType Success:^(NSObject *anyObj) {
        
        LBLog(@"%@: 设置显示成功",watchModel.peripheral.name);
        
        [self.waitingPraiseArray removeObject:watchModel];
        
        if (self.waitingPraiseArray.count>0) {
            
            [self toSetShowMode:ShowModePraiseType Watch:[self.waitingPraiseArray firstObject]];
        }
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 设置显示失败, 重操作",watchModel.peripheral.name);
        
        [blockSelf toSetShowMode:ShowModePraiseType Watch:watchModel];
        
    } ];}


#pragma mark - 重置手表

-(void)toReSetWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    LBLog(@"%@: 开始重置",watchModel.peripheral.name);
    
    //链接手表
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
        
        LBLog(@"%@: 连接成功",watchModel.peripheral.name);
    
        //重置手表
        [watchModel orderReSetSuccess:^(NSObject *anyObj) {
            LBLog(@"%@: 重置成功",watchModel.peripheral.name);
            
            [self.waitingCleanArray removeObject:watchModel];

            if (self.waitingCleanArray.count>0) {
                
                [self toReSetWatch:[self.waitingCleanArray firstObject]];
            }
            //延时重置时间
            [self performSelector:@selector(toSetEndModelWatch:) withObject:watchModel afterDelay:15];
            
        } fail:^(NSString *errorStr) {
            
            LBLog(@"%@: 重置失败, 重操作",watchModel.peripheral.name);
            
            [blockSelf toReSetWatch:watchModel];
        }];
        
        
    } andFail:^(NSString * errorStr) {
    
        LBLog(@"%@: 连接失败, 重操作",watchModel.peripheral.name);
        [self toReSetWatch:watchModel];
    }];
}

#pragma mark - 设置结束模式
- (void)toSetEndModelWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
        
        LBLog(@"%@: 连接成功",watchModel.peripheral.name);
        
        watchModel.type = LBWatchTypeConnected;
        
        [watchModel syncTimeWithSuccess:^(NSObject *anyObj) {
            
            watchModel.type = LBWatchTypeWait;
            
            LBLog(@"%@: 时间成功",watchModel.peripheral.name);
            
        } fail:^(NSString *errorStr) {
            LBLog(@"%@: 时间失败, 重操作",watchModel.peripheral.name);
            [self toSetEndModelWatch:watchModel];
        }];
        
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"%@: 连接失败, 重操作",watchModel.peripheral.name);
        [self toSetEndModelWatch:watchModel];
    }];
    
}

#pragma mark - 设置显示模式

-(void)toSetShowMode:(ShowModeType)mode Watch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    LBLog(@"%@: 开始设置显示",watchModel.peripheral.name);
    
    
    [watchModel orderSetShowMode:mode Success:^(NSObject *anyObj) {
        LBLog(@"%@: 设置显示成功",watchModel.peripheral.name);
        
        
        [self.waitingPraiseArray removeObject:watchModel];
        
        if (self.waitingPraiseArray.count>0) {
            
            [self toSetShowMode:mode Watch:[self.waitingPraiseArray firstObject]];
            
        }
  
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 设置显示失败, 重操作",watchModel.peripheral.name);
        
        [blockSelf toSetShowMode:mode Watch:watchModel];
    } ];
}

#pragma mark - 开始上课时不再清除手表数据（暂不用）

-(void)toCleanWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    LBLog(@"%@: 开始清理",watchModel.peripheral.name);
    
    [watchModel orderCleanSuccess:^(NSObject *anyObj) {
        
        LBLog(@"%@: 清理成功",watchModel.peripheral.name);
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 清理失败, 重操作",watchModel.peripheral.name);
        
        [blockSelf toCleanWatch:watchModel];
    }];
}

#pragma mark - 设置时间

-(void)toSyncTimeWithWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    [watchModel syncTimeWithSuccess:^(NSObject *anyObj) {
        
//        LBLog(@"%@: 时间成功",watchModel.peripheral.name);
        [blockSelf toSetWorkTimeWithWatch:watchModel];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 时间失败, 重操作",watchModel.peripheral.name);
        [self toSyncTimeWithWatch:watchModel];
        
    }];
}
#pragma mark - 设置工作时间
-(void)toSetWorkTimeWithWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    _asynTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:@""];
    
    NSString * classTime = [NSString stringWithFormat:@"%d",[_asynTestModel.testTimeLong intValue]/60 + 1];
    
    
    
    [watchModel orderWorkTime:classTime Success:^(NSObject *anyObj) {
        
        LBLog(@"%@: 工时成功   %@",watchModel.peripheral.name,classTime);
        
        [blockSelf toStartContinuousHeartRate:watchModel];
        
    } fail:^(NSString *errorStr) {
        _errorCount ++;
        
        if (_errorCount>10) {
            
            [self connectWatch: watchModel];
            _errorCount = 0;
            
        }else{
            
            LBLog(@"%@: 工时失败, 重操作",watchModel.peripheral.name);
            [self toSetWorkTimeWithWatch:watchModel];
        }
        
    }];
}


#pragma mark - 开始连续心率
-(void)toStartContinuousHeartRate:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    [watchModel orderHeartContinue:^(NSObject *anyObj) {
        
        LBLog(@"%@: 模式成功",watchModel.peripheral.name);
        watchModel.type = LBWatchTypeSyncHeart;
        watchModel.syncType = AMLBSyncTypeNotWorking;
        self.syncSuccess = watchModel.peripheral;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.waitingConnectArray count]) {
                [[self mutableArrayValueForKey:@"waitingConnectArray"] removeObjectAtIndex:0];
            }
        });
        
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 模式失败, 重操作",watchModel.peripheral.name);
        [self toStartContinuousHeartRate:watchModel];
    }];
}

//------------------------------------- Test watch end


#pragma mark - 同步某一个设备
-(void)syncWatch:(LBWatchPerModel*)watch{
    
    if (watch.type!= LBWatchTypeWait && !watch.isConnected) {
        
        watch.type = LBWatchTypeWait;
        
        NSLog(@"将%@加入等待连接列表",watch.peripheral.name);
        
        if (![self.waitingConnectArray containsObject:watch] && self.connectingWatch!= watch) {
            
            [self.waitingConnectArray addObject:watch];
            
        }
    }
    //当前正有设备在连接中
    if (self.connectingWatch) {
        
    }else{
        [self syncWatchInWaitingQueue];
    }
}

#pragma mark - 同步等待队列中的手表
-(void)syncWatchInWaitingQueue{
    NSLog(@"准备连接等待队列中的设备");
    
    if (!self.waitingConnectArray.count) {
        NSLog(@"没有设备在等待队列中");
        return;
    }
    LBWatchPerModel* watch = self.waitingConnectArray[0];
    //进行设备的连接
    if (watch.type == LBWatchTypeDisConnected) {
        NSLog(@"准备重连%@",watch.peripheral.name);
        [self performSelector:@selector(prepareConnectWatch:) withObject:watch afterDelay:0];
    }else{
        [self prepareConnectWatch:watch];
    }
}

-(void)prepareConnectWatch:(LBWatchPerModel*)watch {
    
    __weak HJBluetootManager *weakSelf = self;
    weakSelf.connectingWatch = watch;
    [weakSelf.waitingConnectArray removeObject:watch];
    
    NSLog(@"正在连接%@",watch.peripheral.name);
    
    watch.type = LBWatchTypeConnecting;
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        [weakSelf connectWatch:watch];
    });
}

-(void)connectWatch:(LBWatchPerModel*)watch {
    
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
        NSLog(@"连接成功%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeConnected;
        [blockSelf syncTimeWithWatch:watch];
        
    } andFail:^(NSString * errorStr) {
        NSLog(@"连接失败%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeDisConnected;
        
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


#pragma mark - 同步时间
-(void)syncTimeWithWatch:(LBWatchPerModel*)watch {
    __weak HJBluetootManager* blockSelf = self;
    [watch syncTimeWithSuccess:^(NSObject *anyObj) {
        [blockSelf orderWorkTimeWithWatch:watch];
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


#pragma mark - 设置工作时间
-(void)orderWorkTimeWithWatch:(LBWatchPerModel*)watch{
    __weak HJBluetootManager* blockSelf = self;
    
    _asynTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:@""];
    
    NSString * classTime = [NSString stringWithFormat:@"%d",[_asynTestModel.testTimeLong intValue] + 5];
    
//    NSLog(@"classTime    %@",classTime);
    
    [watch orderWorkTime:classTime Success:^(NSObject *anyObj) {
        NSLog(@"------------\n 设置工作时间成功---------\n");
        
        [blockSelf goContinuousHeartRate:watch];
        
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


#pragma mark - 开始连续心率
-(void)goContinuousHeartRate:(LBWatchPerModel*)watch{
    __weak HJBluetootManager* blockSelf = self;
    
    [watch orderHeartContinue:^(NSObject *anyObj) {
        
        [blockSelf syncDoneWithWatch:watch];
        
    } fail:^(NSString *errorStr) {
        
        
    }];
}



#pragma mark - 同步数据完成
-(void)syncDoneWithWatch:(LBWatchPerModel*)watch{
    watch.type = LBWatchTypeDone;
    watch.syncType = AMLBSyncTypeNotWorking;
    self.syncSuccess = watch.peripheral;
    [self.blueTools cancelPeripheralConnection:watch.peripheral];
    
    [self.waitingConnectArray removeObject:watch];
    if (self.waitingConnectArray.count>0) {
        [self syncDoneWithWatch:[self.waitingConnectArray firstObject]];
        
    }
    //    [self orderSleepWithWatch:watch];
}


#pragma mark - 进入休眠
-(void)orderSleepWithWatch:(LBWatchPerModel*)watch{
    
    [watch orderSleep];
    
}

#pragma mark - 停止工作
-(void)stopWorkWithWatch:(LBWatchPerModel*)watch{
    
    [watch endTest];
    
    [self.waitingCleanArray removeObject:watch];
    
    if (self.waitingCleanArray.count>0) {
        [self stopWorkWithWatch:[self.waitingCleanArray firstObject]];
        
    }
}

#pragma mark - 停止搜索
-(void)stopScanWatch{
    [self.blueTools.scanWatchArray removeAllObjects];
    [self.blueTools  cancelAllBluePeripheral];
    [self.waitingConnectArray removeAllObjects];
    [self.blueTools stopScan];
}


#pragma --mark--
-(void)buyBackAllSyncWatchStatus{
    for (LBWatchPerModel*watchModel in self.blueTools.scanWatchArray) {
        watchModel.type = LBWatchTypeUnConnected;
        watchModel.syncType = AMLBSyncTypeNotWorking;
    }
}



//#pragma --mark-- 重新搜索手表
//- (void)refreshScanAllWatch {
////    self.isAutoSync = NO;
////    [self.waitingConnectArray removeAllObjects];
//
//    //    self.asynClassInfo =  nil;
//
//    self.connectingWatch = nil;
//
//    [self.blueTools stopScan];
////    [self.blueTools cancelAllBluePeripheral];
////    self.blueTools = [AMLifeBitBlueTools instance];
//    [self.blueTools registerBlueToothManager];
//    [self stepBlueStateChangeBlock];
//    [self stepBlueDisConnectBlock];
//}




@end



