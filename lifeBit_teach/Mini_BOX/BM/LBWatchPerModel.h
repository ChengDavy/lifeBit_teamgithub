//
//  LBWatchPerModel.h
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "crc16.h"

typedef NS_ENUM(NSInteger, LBWatchType) {
    LBWatchTypeUnConnected          = 0, // 没有连接
    LBWatchTypeConnecting           = 1, // 连接中
    LBWatchTypeConnected            = 2, // 连接
    LBWatchTypeDisConnected         = 3, // 连接失败
    LBWatchTypeSyncHeart             = 4, 
    LBWatchTypeupDataHeart           = 5,
    LBWatchTypeSyncWalk             = 6,
    LBWatchTypeupDataWalk           = 7,
    LBWatchTypeNetError             =8,
    LBWatchTypeDone                 =9,    // 同步完成
    LBWatchTypeClean                =10,   //清除数据
    LBWatchTypeWait                 =11, // 等待连接
    LBWatchTypeClearDone                 =12,    // 清除数据同步完成
    
    LBWatchTypeHearting                =13,   //心率中
    LBWatchTypeSteping                 =14, // 等待连接
    LBWatchTypeDataDone                 =15,    // 清除数据同步完成
    LBWatchTypeDataFail                 =16,     // 同步数据失败
};
typedef NS_ENUM(NSInteger, ShowModeType) {
    ShowModeStepType               = 0, // 运动记步
    ShowModeOnceHeartType          = 1, // 单次心率
    ShowModeMoreHeartType          = 2, // 持续心率
    ShowModePraiseType             = 3, // 点赞
    ShowModeShowLogoType           = 4, // 显示图标
    ShowModeBackStepType          = 5, // 停止心率返回记步

};


typedef NS_ENUM(NSInteger, AMLBSyncType) {
    AMLBSyncTypeNotWorking         = 0,
    AMLBSyncTypeTime               = 1,
    AMLBSyncTypeHeartContinue      = 2,
    AMLBSyncTypeWalk               = 3,
    AMLBSyncTypeClean              = 4,
    AMLBSyncTypeWorkTime           = 5,
    
    LBWatchTypeOrderHeartContinue   =6,
    AMRealTimeSyncTypeHeart        =7,   // 实时心率
    AMCommandRealTimeSyncTypeHeart        =8,   // 用命令发送进入实时心率
    AMLBContinuingHeartContinue = 9,  // 进入连续心率
 //新加
    AMLBSyncTypeSetLogo   = 10, // 设置显示模式
    AMLBSyncTypeReset     = 11,   // 重置
    AMLBSyncTypeConnting  = 12,  // 连接中
};
@protocol HJDetectionPeripheralRSSI <NSObject>

-(void)didReadRSSI:(NSNumber*)RSSI withPeripher:(CBPeripheral*)peripheral;

@end

@interface LBWatchPerModel : NSObject <CBPeripheralDelegate>


@property(nonatomic,strong)CBPeripheral* peripheral;
@property(nonatomic,strong)CBCentralManager* manager;


@property(nonatomic)LBWatchType type;
@property(nonatomic,assign)AMLBSyncType syncType;

@property(nonatomic,strong)NSData* upDateWalkData;
@property(nonatomic,strong)NSData* upDateHeartData;
@property(nonatomic,strong)NSString* progressStr;
@property(nonatomic,strong)NSString* waRSSI;

@property(nonatomic,strong)NSString* testID;

@property(nonatomic,strong)NSString* teamberID;

@property(nonatomic,strong)NSString* groupID;

@property(nonatomic,strong)NSString* beginTime;

@property(nonatomic,strong)NSString* timeLong;

@property(nonatomic,strong)NSString* progressStepStr;

@property(nonatomic,assign)NSInteger FailTime;


@property(nonatomic)BOOL isConnected;

#pragma mark - 是否处于连接中



#pragma mark -  错误连接次数
@property (nonatomic,assign)NSInteger countConnected;

@property (nonatomic,strong)id<HJDetectionPeripheralRSSI> delegate;


@property(nonatomic,strong)NSMutableData* heartData;
@property(nonatomic,strong)NSMutableData* walkData;

@property (nonatomic,strong)NSMutableArray *syncHeartArr;
@property (nonatomic,strong)NSMutableArray *syncWalktArr;


+(instancetype)watchPerWithPeripheral:(CBPeripheral*)peripheral;


@property(nonatomic,strong)void (^connectSuccessBlock)(CBPeripheral* peripheral);
@property(nonatomic,strong)void (^connectFailBlock)(NSString* errorStr);
@property(nonatomic,strong)void(^getDataBlock)(NSData* data);

#pragma mark -  同步实时心率回调的Block
@property (nonatomic,strong) void (^getReadTimeSyncHeartBlock)(NSInteger heart);

#pragma mark 回调心率

-(void)setGetReadTimeSyncHeartBlock:(void (^)(NSInteger heart))getReadTimeSyncHeartBlock;

@property (nonatomic,strong) void (^readTimeSyncHeartErrorBlock)(NSString *errorStr);
-(void)setReadTimeSyncHeartErrorBlock:(void (^)(NSString *errorStr))readTimeSyncHeartErrorBlock;

@property (nonatomic, copy) void (^heartRateNotification)(NSInteger heart);
#pragma mark - lifebit专用

#pragma mark - 同步时间
-(void)syncTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


#pragma mark - 同步连续心率
-(void)syncHeartContinueWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


#pragma mark - 同步运动步数心率数据
-(void)syncWalkWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


#pragma mark - 清楚所有数据指令
-(void)orderCleanSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


#pragma mark - 设置工作时间
-(void)orderWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

#pragma mark - 设置指定工作时间
-(void)orderWorkTime:(NSString*)timerStr  Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

#pragma mark - 设置工作时间5分钟
-(void)orderTestWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

#pragma mark - 设置重置模式
-(void)orderReSetSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

#pragma mark - 设置显示模式
-(void)orderSetShowMode:(ShowModeType )Mode Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

#pragma mark - 进入休眠模式
-(void)orderSleep;

#pragma mark - 进入结束模式
-(void)endTest;

#pragma mark - 发送连续测心率模式
-(void)orderHeartContinue:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;;


#pragma mark - 查看实时心率
-(void)syncRealTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;



@end
