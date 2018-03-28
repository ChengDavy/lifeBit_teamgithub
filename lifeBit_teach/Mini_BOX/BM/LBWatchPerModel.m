//
//  LBWatchPerModel.m
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "LBWatchPerModel.h"
#import "HJBluetoothDataInfo.h"
#import "BluetoothDataModel.h"

#define LBLog(fmt, ...) NSLog((@"LBLog %@: "fmt),self.peripheral.name,##__VA_ARGS__);
//#define LBLog(...);

static NSString * const kServiceUUID = @"FFE0";
//static NSString * const kServiceUUID = @"180D";


static NSString * const kReadCharacteristicUUID  = @"FFE1";  // 
static NSString * const kWriteCharacteristicUUID = @"FFE2";  //
static NSString * const kRealTimeServiceUUID     = @"180D";  // 实时心率传输服务
static NSString * const KReadCharacteristicUUID  = @"2A37";  // 实时心率传输特征值

@interface LBWatchPerModel()<CBPeripheralDelegate>

@property (nonatomic, strong) CBUUID* serviceUUID;
@property (nonatomic, strong) CBUUID* readUUID;
@property (nonatomic, strong) CBUUID* writeUUID;

@property (nonatomic, strong) CBUUID *readTimeServiceUUID;
@property (nonatomic, strong) CBUUID* readTimeReadUUID;

@property (nonatomic, strong) CBCharacteristic* readCharacteristic;
@property (nonatomic, strong) CBCharacteristic* writeCharacteristic; //写入操作特征

@property (nonatomic, strong) NSTimer* timer; //十秒超时计时器
@property (nonatomic, assign) NSInteger time;

//lifeBit专用回调
@property (nonatomic, strong) void(^syncSuccessBlock)(NSObject* anyObj);
@property (nonatomic, strong) void(^syncFailBlock)(NSString* errorStr);
@property (nonatomic, strong) void(^syncProgressBlock)(NSObject* anyObj);


@property(nonatomic, strong)NSMutableString* responseStr;

#pragma mark - 步数专用

@property(nonatomic, strong)NSMutableString* responseStepStr;
//lifeBit专用回调
@property (nonatomic, strong) void(^syncSuccessStepBlock)(NSObject* anyObj);
@property (nonatomic, strong) void(^syncFailStepBlock)(NSString* errorStr);
@property (nonatomic, strong) void(^syncProgressStepBlock)(NSObject* anyObj);

@property(nonatomic, strong)NSData* sendData;

@end


@implementation LBWatchPerModel

+(instancetype)watchPerWithPeripheral:(CBPeripheral*)peripheral {
    
    LBWatchPerModel* m =  [[LBWatchPerModel alloc]init];
    m.peripheral = peripheral;
    m.peripheral.delegate = m;
    m.type = LBWatchTypeUnConnected;
    m.serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    m.readUUID    = [CBUUID UUIDWithString:kReadCharacteristicUUID];
    m.writeUUID   = [CBUUID UUIDWithString:kWriteCharacteristicUUID];
    
    m.readTimeServiceUUID = [CBUUID UUIDWithString:kRealTimeServiceUUID];
    m.readTimeReadUUID =    [CBUUID UUIDWithString:KReadCharacteristicUUID];
    m.syncType = AMLBSyncTypeNotWorking;
    m.progressStr = @"";
    m.countConnected = 0;
    
    return  m;
}


-(void)setType:(LBWatchType)type{
    if (_type == LBWatchTypeDone ) {
        _type = type;
        return;
    }
    
    if (type == LBWatchTypeConnected) {
        self.isConnected = YES;
    }
    
    if (type == LBWatchTypeDone || type ==LBWatchTypeDisConnected || type == LBWatchTypeNetError) {
        self.isConnected = NO;
    }
    
    _type =type;
}

-(NSMutableArray *)syncHeartArr{
    if (_syncHeartArr == nil) {
        self.syncHeartArr = [NSMutableArray array];
    }
    return _syncHeartArr;
}

-(NSMutableArray *)syncWalktArr{
    if (_syncWalktArr == nil) {
        self.syncWalktArr = [NSMutableArray array];
    }
    return _syncWalktArr;
}

#pragma mark - 发送数据
-(void)sendData:(NSData*)data{
    if (self.peripheral.state == CBPeripheralStateConnected) {
//        LBLog(@"发送数据:%@",data);
        [self.peripheral writeValue:data 
                  forCharacteristic:self.writeCharacteristic 
                               type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark  ----CBPeripheralDelegate----
#pragma mark - 发现服务
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    if (error) {
        LBLog(@"didDiscoverServices error");
        if (self.connectFailBlock) {
            self.connectFailBlock(@"查找服务出错");
            LBLog(@"查找服务出错");
            [self.manager cancelPeripheralConnection:aPeripheral];
        }
        return;
    }
    BOOL readServices = NO;
    BOOL isServies = NO;
    
    for (CBService *service in aPeripheral.services) {
        
        // 查找特征
        if ([service.UUID isEqual:self.serviceUUID]) {
//            LBLog(@"已到服务 %@ 并开始查找特征",service.UUID);
            isServies = YES;
            [aPeripheral discoverCharacteristics:nil forService:service];
            continue;
        }
        if ([service.UUID isEqual:self.readTimeServiceUUID]) {
            readServices = YES;
//            [aPeripheral discoverCharacteristics:nil forService:service];
            continue;
        }
    }
    if (!readServices && !isServies) {
        if (self.connectFailBlock) {
            self.connectFailBlock(@"没有发现相关服务");
            LBLog(@"没有发现相关服务");
            [self.manager cancelPeripheralConnection:aPeripheral];
        }
    }
}


#pragma mark - 发现特征

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:
(CBService *)service error:(NSError *)error {
    
    if (error) {
//        LBLog(@"didDiscoverCharacteristicsForService error");
        if (self.connectFailBlock) {
            self.connectFailBlock(@"查找特征出现错误");
//            LBLog(@"查找特征出现错误");
            [self.manager cancelPeripheralConnection:peripheral];
        }
        return;
    }
    
    BOOL hasRead = NO;
    BOOL hasWrite = NO;
    BOOL readRead = NO;
    
    if ([service.UUID isEqual:self.readTimeServiceUUID]) {
        for (CBCharacteristic * characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:self.readTimeReadUUID]) {
                //订阅某一个特征,用于检测
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//                LBLog(@"实时心率  已订阅读取特征 %@",characteristic.UUID);
                readRead = YES;
            }
        }
    }
    
    if ([service.UUID isEqual:self.serviceUUID]) {
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:self.readUUID]) {
                //监听某个特征
                self.readCharacteristic = characteristic;
                //订阅某一个特征,用于检测
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//                LBLog(@"已订阅读取特征 %@",characteristic.UUID);
                hasRead = YES;
            }
            
            if ([characteristic.UUID isEqual:self.writeUUID]) {
                //监听某个特征
                self.writeCharacteristic = characteristic;
//                LBLog(@"已存入写入特征:%@",characteristic.UUID);
                hasWrite = YES;
                
            }
        }
    }
    
    if ((hasRead && hasWrite) ||readRead) {
       
//        LBLog(@"已连接");
        if (self.connectSuccessBlock) {
            self.connectSuccessBlock(peripheral);
        }
    } else {
        if (self.connectFailBlock) {
            self.connectFailBlock(@"没有找到read或者write特征");
//            LBLog(@"没有找到read或者write特征");
            [self.manager cancelPeripheralConnection:peripheral];
        }
    }
}



#pragma mark - 监听的特征值发生了变化
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:
(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
//        LBLog(@"didUpdateNotificationStateForCharacteristic error");
        return;
    }
    // Exits if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:self.readUUID]) {
        return;
    }
    // Notification has started
    if (characteristic.isNotifying) {
        //        LBLog(@"%@", characteristic.value);
        [peripheral readValueForCharacteristic:characteristic];
        
    } else {
        // Notification has stopped
//        LBLog(@"didUpdateNotificationStateForCharacteristic stopped");
    }
    [peripheral readRSSI];
}


-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        LBLog(@"error:    %@",error);
//        LBLog(@"发送失败");
    }else{
//        LBLog(@"发送成功");
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSData* data = characteristic.value;
    
    if ([characteristic.UUID.UUIDString isEqual:KReadCharacteristicUUID]) {
        self.syncType = AMRealTimeSyncTypeHeart;
    }

    if (self.getDataBlock) {
        self.getDataBlock(characteristic.value);
    }
    
    [self handleData:data andErrorStr:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    
//    LBLog(@" 信号值 %ld",(long)[RSSI intValue]);
    _waRSSI = [NSString stringWithFormat:@"%@",RSSI];
    [self performSelector:@selector(peripheralReadRSSI:) withObject:peripheral afterDelay:2.0];
    if (!error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReadRSSI:withPeripher:)]) {
            [self.delegate didReadRSSI:RSSI withPeripher:peripheral];
        }
    }else{
//        NSLog(@"readRSSI error with %@",error);
    }
}

-(void)peripheralReadRSSI:(CBPeripheral*)peripheral{
    [peripheral readRSSI];
}

#pragma mark  ----lifeBit 专用方法------
#pragma mark - 同步时间
-(void)syncTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    
    self.syncType = AMLBSyncTypeTime;
    
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    //拼接时间命令字符串
    NSString* yearStr = [[self getDataWithFormat:@"YYYY"] mutableCopy];
    NSMutableString* dataStr = [@"C00A" mutableCopy];
    
    [dataStr appendString:[yearStr substringWithRange:NSMakeRange(2, 2)]];
    [dataStr appendString:[yearStr substringWithRange:NSMakeRange(0, 2)]];
    
    [dataStr appendString:[self getDataWithFormat:@"MMdd"]];
    [dataStr appendString:[self weekdayStringFromDate:[NSDate date]]];
    [dataStr appendString:[self getDataWithFormat:@"HHmmss"]];
    
//    LBLog(@"dateStr = %@",dataStr);
    
    //命令数据转data并crc16加密
    NSMutableData* data = [[self convertHexStrToData:dataStr] mutableCopy];
    

    
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, (int)data.length);
    
//    LBLog(@"crc :%x",crc);
    
    [data appendBytes:&crc length:2];
    
//    LBLog(@"同步时间指令为:%@",data);
    
    [self sendData:data];
}


#pragma mark - 同步连续心率数据
-(void)syncHeartContinueWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    
    self.syncType = AMLBSyncTypeHeartContinue;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    self.syncProgressBlock = progress;
    
    self.responseStr = [@"" mutableCopy];
    self.heartData  = [NSMutableData data];
    
    Byte bytes[] = { 0xC7, 0x02 };
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    
//    LBLog(@"同步心率指令为:%@",data);
    [self sendData:data];
}




#pragma mark  同步运动步数数据

-(void)syncWalkWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    
    self.syncType = AMLBSyncTypeWalk;
    
    self.syncSuccessStepBlock = success;
    self.syncFailStepBlock = fail;
    self.syncProgressStepBlock = progress;
    
    self.responseStepStr = [@"" mutableCopy];
    self.walkData = [NSMutableData data];
    
    Byte bytes[] = { 0xDA,0x02 };
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    NSLog (@"同步运动步数指令为:%@",data);
    [self sendData:data];
}

#pragma mark 查看实时心率

-(void)syncRealTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
   
    self.syncType = AMCommandRealTimeSyncTypeHeart;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    Byte bytes[] = {0xD3,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
//    LBLog(@"crc :%x  ",crc);
    [data appendBytes:&crc length:2];
    
//    LBLog(@"同步运动心率指令为:%@",data);
    
    [self sendData:data];

}


-(void)setSyncType:(AMLBSyncType)syncType{
    _syncType = syncType;
    //当数据不再传输中时,停止超时检测
    if (syncType == AMLBSyncTypeNotWorking) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }else{
        self.time = 10;
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
    }
}


#pragma mark - 清楚所有数据指令

-(void)orderCleanSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeClean;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x03,0x00};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    LBLog(@"清楚数据数指令为:%@",data);
    [self sendData:data];
}

#pragma mark - 设置工作时间
-(void)orderWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeWorkTime;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x04,0x03,0x40};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:4];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 4);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}

#pragma mark - 设置指定工作时间
-(void)orderWorkTime:(NSString*)timerStr  Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
 
    self.syncType = AMLBSyncTypeWorkTime;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    NSMutableString *s = [[self ToHex:[timerStr intValue]] mutableCopy];
    if (s.length <= 1) {
        [s insertString:@"0" atIndex:0];
    }

    NSString *dataStr = [NSString stringWithFormat:@"DB0403%@",s];
    //命令数据转data并crc16加密convertHexStrToData
    NSMutableData* data = [[self convertHexStrToData:dataStr] mutableCopy];
    
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, (int)data.length);
    
//    LBLog(@"crc :%x",crc);
//    LBLog(@"同步时间指令为:%@",data);
    [data appendBytes:&crc length:2];
   
//    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}

#pragma mark - 设置工作时间
-(void)orderTestWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeWorkTime;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x04,0x03,0x05};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:4];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 4);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}
#pragma mark - 设置重置模式
-(void)orderReSetSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeReset;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xD2,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
    //    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    //    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}

#pragma mark - 设置显示模式
-(void)orderSetShowMode:(ShowModeType )Mode Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeReset;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    switch (Mode) {
        case 0:
        {
            Byte bytes[] = {0xDB,0x03,0x01};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
  
            [self sendData:data];
        }
            break;
        case 1:
        {
            Byte bytes[] = {0xDB,0x03,0x02};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
          
            [self sendData:data];
        
        }
            break;
        case 2:
        {
            Byte bytes[] = {0xDB,0x03,0x03};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
          
            [self sendData:data];
        }
            break;
        case 3:
        {
            Byte bytes[] = {0xDB,0x03,0x06};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
      
            [self sendData:data];
        }
            break;
        case 4:
        {
            Byte bytes[] = {0xDB,0x03,0x07};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
           
            [self sendData:data];
        }
            break;
        case 5:
        {
            Byte bytes[] = {0xDB,0x03,0x08};
            NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
            UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
            //    LBLog(@"crc :%x",crc);
            [data appendBytes:&crc length:2];
            //    LBLog(@"设置显示模式指令为:%@",data);
            [self sendData:data];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 进入休眠模式
-(void)orderSleep{
    self.syncType = AMLBSyncTypeNotWorking;
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xD9,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    LBLog(@"设置休眠:%@",data);
    [self sendData:data];
}

#pragma mark - 发送连续测心率模式

-(void)orderHeartContinue:(void (^)(NSObject *))success fail:(void (^)(NSString *))fail{
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    self.syncType = AMLBContinuingHeartContinue;

    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x03,0x03};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
//    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
//    LBLog(@"启动连续测心率指令为:%@",data);
    [self sendData:data];
}


-(void)runTime{
    
    self.time --;
//    LBLog(@"超时剩余:%d",(int)self.time);
    if (self.time <=0) {
        //超时了
        [self handleData:nil andErrorStr:@"手表超时或app没有响应蓝牙手表的数据"];
    }
}

#pragma mark - 处理进入连续的数据
-(void)handleGoContinuingHeartRateData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
//        LBLog(@"进入连续心率成功");
        self.syncSuccessBlock(nil);
    }
}


#pragma mark  ----收到数据后的处理-------
-(void)handleData:(NSData*)data andErrorStr:(NSString*)errorStr{
//    LBLog(@"syncData:%@ error:%@",data,errorStr);
    
    //超时没有收到回包
    if (errorStr) {
        
        if (self.syncType == AMLBSyncTypeWalk) {
            self.syncType = AMLBSyncTypeNotWorking;
            LBLog(@"超时了Walk");
            
            self.syncFailStepBlock(errorStr);
            
            LBLog(@"syncDataWalk:%@ error:%@",data,errorStr);
            return;
        }else{
            self.syncType = AMLBSyncTypeNotWorking;
            LBLog(@"超时了22");
            self.syncFailBlock(errorStr);
            
            LBLog(@"syncDataNotWorking:%@ error:%@",data,errorStr);
            return;
        }
       
    }
    
    self.time = 10;
    
    if (!data) {
        return;
    }
    
    Byte* bytes = (Byte*)data.bytes;
    if (self.syncType == AMLBContinuingHeartContinue) {
        if (bytes[0] == 0xFE) {
            if (bytes[1] == 0x03) {
                
            }
        }
    }
    //指令出现错误
    if (bytes[0] ==0xFE) {
        self.syncType = AMLBSyncTypeNotWorking;
        if (bytes[1] == 0x01) {
            self.syncFailBlock(@"指令不存在");
//            NSLog(@"sync 不存在");
            
        }else if (bytes[1] == 0x02){
            self.syncFailBlock(@"crc16错误");
//            NSLog(@"sync crc16错误");
            
        }else if (bytes[1] == 0x03){
            self.syncFailBlock(@"data错误");
//            NSLog(@"sync data错误 %@",self.peripheral.name);
            
        }else if (bytes[1] == 0x04){
            self.syncFailBlock(@"length错误");
//            NSLog(@"sync length错误");
        }
        return;
    }
    
    switch (self.syncType) {
        case AMLBSyncTypeTime:                [self handleSyncTimeData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeHeartContinue:       [self handleHeartContinueData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeWalk:                [self handleWalkData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeClean:               [self handleOrderCleanData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeWorkTime:            [self handleOrderWorkTimeData:data andErrorStr:errorStr];
            break;
        case LBWatchTypeOrderHeartContinue:   [self handleOrderHeartContinueData:data andErrorStr:errorStr];
            break;
        case AMRealTimeSyncTypeHeart:         [self handleOrderHeartReadTimeData:data andErrorStr:errorStr];
            break;
        case AMCommandRealTimeSyncTypeHeart:  [self handleOrderCommandRealTimeData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeReset:  [self handleResetData:data andErrorStr:errorStr];
            break;
        case AMLBSyncTypeSetLogo:  [self handleSetLogoData:data andErrorStr:errorStr];
            break;
        case AMLBContinuingHeartContinue:     [self handleGoContinuingHeartRateData:data andErrorStr:errorStr];
        default:
            break;
    }
}

//处理设置logo的数据

-(void)handleSetLogoData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"设置logo");
        self.syncSuccessBlock(nil);
    }
}
//处理重置数据

-(void)handleResetData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"重置");
        self.syncSuccessBlock(nil);
    }
}

//处理时间同步的数据

-(void)handleSyncTimeData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
//        LBLog(@"同步时间成功");
        self.syncSuccessBlock(nil);
    }
}


#pragma mark - 处理连续心率数据

-(void)handleHeartContinueData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    
    if (bytes[0] == 0xE4 && (bytes[1] ==0x12 || bytes[1] == 0x0A)) {
        
        [self saveHeartBytes:bytes andData:data]; /// 保存读取到的心率数据
        
        Byte sendbytes[] = {0xFF,0x02}; /// 请求剩余的心率数据
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
//        LBLog(@"继续同步心率指令为:%@",sendData);
        [self sendData:sendData];
        
    }else if (bytes[0] == 0xE4 && bytes[1] == 0x02){
        
        Byte sendbytes[] = {0xFF,0x02}; /// 收到心率数据结束标示
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
//        LBLog(@"继续同步心率指令为:%@",sendData);
        [self sendData:sendData];
        
        self.syncType = AMLBSyncTypeNotWorking;
//        LBLog(@"心率数据信息:%@",self.responseStr);
        if (self.heartData.length >1) {
            [self.heartData replaceBytesInRange:NSMakeRange([self.heartData length]-1, 1) withBytes:NULL length:0];
        }
        self.syncSuccessBlock(self.heartData);
        
    } else {
        self.syncType = AMLBSyncTypeNotWorking;
        ++self.countConnected;
    }
}



#pragma mark - 处理运动步数数据

-(void)handleWalkData:(NSData*)data andErrorStr:(NSString*)errorStr {
    
    Byte* bytes = (Byte*)data.bytes;
    
    if (bytes[0] == 0xEF && (bytes[1] ==0x0C)) {
        //保存读取到的计步数据
        [self saveWalkBytes:bytes andData:data];
        
        //请求剩余的计步数据
        Byte sendbytes[] = {0xFF,0x02};
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
//        LBLog(@"继续同步步数指令为:%@",sendData);
        [self sendData:sendData];
        
    } else if (bytes[0] == 0xEF && bytes[1] == 0x02) {
        
#warning aimi
        
        //收到计步数据结束标示
        Byte sendbytes[] = { 0xFF, 0x02 };
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
        [self sendData:sendData]; //LBLog(@"继续同步步数指令为:%@",sendData);

        self.syncType = AMLBSyncTypeNotWorking; //LBLog(@"计步数据信息:%@",self.responseStr);

        if (self.walkData.length > 1) {
            
            [self.walkData replaceBytesInRange:NSMakeRange([self.walkData length]-1, 1) withBytes:NULL length:0];
        }
        self.syncSuccessStepBlock(self.walkData);
    }
    else{
        
    }
}

//处理清楚数据的回复
-(void)handleOrderCleanData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
           LBLog(@"清除数据成功");
        self.syncSuccessBlock(nil);
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
        
    }
}


//处理启动连续测心率

-(void)handleOrderHeartContinueData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
//        LBLog(@"启动连续测心率成功");
        self.syncSuccessBlock(nil);
        
    }else{
//                self.syncType = AMLBSyncTypeNotWorking;
//                ++self.countConnected;
//                LBLog(@"硬件返回格式出错");
//                self.syncFailBlock(@"硬件返回格式出错");
        
    }
}

//处理启动实时心率
-(void)handleOrderHeartReadTimeData:(NSData*)data andErrorStr:(NSString*)errorStr {
    
    if (errorStr.length > 0 || errorStr != nil ) {
        if (self.readTimeSyncHeartErrorBlock) {
             self.readTimeSyncHeartErrorBlock(errorStr);
        }
       
        return;
    }
    NSString *dataStr = [self convertDataToHexStr:data];
    unsigned long size = strtoul([dataStr UTF8String],0,16);
//    NSLog(@"length - >%ld",size);
//    NSLog(@"处理实时心率 %@",dataStr);
    if (self.getReadTimeSyncHeartBlock) {
        self.getReadTimeSyncHeartBlock(size);
    }
    
}

//处理启动实时心率
-(void)handleOrderCommandRealTimeData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte *byte = (Byte*)data.bytes;
    if (errorStr.length > 0 || errorStr != nil ) {
        if (self.syncFailBlock) {
            self.syncFailBlock(errorStr);
        }
        
        return;
    }
    if (byte[0] == 0xE8 || byte[1] == 0x03) {
        NSData *realTimeData = [NSData dataWithBytes:&byte[2] length:1];
        NSString *dataStr = [self convertDataToHexStr:realTimeData];
        unsigned long size = strtoul([dataStr UTF8String],0,16);
        if (size <= 0) {
            if (self.syncFailBlock) {
                self.syncFailBlock(@"未开启心率测试模式或未测出准确值");
            }
            if (self.getReadTimeSyncHeartBlock) {
                self.getReadTimeSyncHeartBlock(size);
            }
            return;
        }

        if (self.syncSuccessBlock) {
            self.syncSuccessBlock(nil);
        }
    }
    self.syncType = AMLBSyncTypeNotWorking;
    [self saveRealTimeBytes:byte andData:data];
    
    

}

//处理设置工作时间
-(void)handleOrderWorkTimeData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
//        LBLog(@"设置工作时间成功");
        self.syncSuccessBlock(nil);
    }
}


//解析心率的bytes
-(void)saveHeartBytes:(Byte*)bytes andData:(NSData*)data{
    
    if (data.length >= 14) {
        //2条心率数据
        
        Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
        Byte heartBty[] = {bytes[7]};
        
        NSData* timedata = [NSData dataWithBytes:timeBty length:4];
        NSData* heartData = [NSData dataWithBytes:heartBty length:1];
        
        int i ;
        [timedata getBytes:&i length:4];
        
        int j;
        [heartData getBytes:&j length:1];
        
        NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
        
        NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr = [NSString stringWithFormat:@"%d",heartBty[0]];
        
        [self.responseStr appendString:timeStr];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr];
        [self.responseStr appendString:@"mac="];
        [self.responseStr appendString:[self getPeripheralMAC]];
        [self.responseStr appendString:@"\n"];
        
//        NSLog(@"---------------(1)  %@  =  %@",timeStr, heartStr);
        
        NSTimeInterval timeInterval= [date timeIntervalSinceReferenceDate];
        date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        
        NSNumber * timeP = [self getTimeRun:date];
        
        if ([timeP intValue]<=0) {
            
        }else{
            
            MiHeartModel * heartModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHeartModel];
            
            heartModel.testID = _testID;
            
            heartModel.teamerID = _teamberID;
            
            heartModel.groupID = _groupID;
            
            heartModel.heartNumber = heartStr ;
            
            heartModel.heartId = [NSString getStrArc4randomWithSize:10];
            
            heartModel.timePoint = timeP;
            
            heartModel.beginTime = _beginTime;
            
            if (heartStr.intValue *100 /180>100) {
                heartModel.gradeNO = @"5";
            }else if (heartStr.intValue *100 /180>=90){
                heartModel.gradeNO = @"5";
            }else if (heartStr.intValue *100 /180>=80){
                heartModel.gradeNO = @"4";
            }else if (heartStr.intValue *100 /180>=70){
                heartModel.gradeNO = @"3";
            }else if (heartStr.intValue *100 /180>=60){
                heartModel.gradeNO = @"2";
            }else{
                heartModel.gradeNO = @"1";
            }
            
            if ([[LifeBitCoreDataManager shareInstance]efAddMiHeartModel:heartModel]) {
                
            }
  
        }
        
        NSMutableString* progressStr = [NSMutableString string];
        [progressStr appendString:timeStr];
        [progressStr appendString:@"="];
        [progressStr appendString:heartStr];
        
        self.progressStr = progressStr;
        self.syncProgressBlock(progressStr);
        
        [self.heartData appendData:timedata];
        [self.heartData appendData:heartData];
        Byte f4[] = {0xF4};
        [self.heartData appendBytes:f4 length:1];
        
        
        Byte timeBty2[] = {bytes[11],bytes[12],bytes[13],bytes[14]};
        Byte heartBty2[] = {bytes[15]};
        
        NSData* timedata2 = [NSData dataWithBytes:timeBty2 length:4];
        NSData* heartData2 = [NSData dataWithBytes:heartBty2 length:1];
        
        int a ;
        [timedata2 getBytes:&a length:4];
        
        int b;
        [heartData2 getBytes:&b length:1];
        
        NSDate* date2 = [NSDate dateWithTimeInterval:a sinceDate:date2000];
        
        NSString* timeStr2 = [self transDateToString:date2 withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr2 = [NSString stringWithFormat:@"%d",heartBty2[0]];

        timeInterval= [date2 timeIntervalSinceReferenceDate];
        
        date2 = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        
        NSNumber * timeP2 = [self getTimeRun:date2];
        
        if ([timeP intValue]<=0) {
            
        }else{
            
            MiHeartModel * heartModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHeartModel];
            
            heartModel.testID = _testID;
            
            heartModel.teamerID = _teamberID;
            
            heartModel.groupID = _groupID;
            
            heartModel.heartNumber = heartStr2 ;
            
            heartModel.heartId = [NSString getStrArc4randomWithSize:10];
            
            heartModel.timePoint = timeP2;
            
            heartModel.beginTime = _beginTime;
            
            if (heartStr2.intValue *100 /180>100) {
                heartModel.gradeNO = @"5";
            }else if (heartStr2.intValue *100 /180>=90){
                heartModel.gradeNO = @"5";
            }else if (heartStr2.intValue *100 /180>=80){
                heartModel.gradeNO = @"4";
            }else if (heartStr2.intValue *100 /180>=70){
                heartModel.gradeNO = @"3";
            }else if (heartStr2.intValue *100 /180>=60){
                heartModel.gradeNO = @"2";
            }else{
                heartModel.gradeNO = @"1";
            }
            
            if ([[LifeBitCoreDataManager shareInstance]efAddMiHeartModel:heartModel]) {
                
            }
            
            
            
        }

        
        
        [self.responseStr appendString:timeStr2];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr2];
        [self.responseStr appendString:@"mac="];
        [self.responseStr appendString:[self getPeripheralMAC]];
        [self.responseStr appendString:@"\n"];
        
        
        NSMutableString* progressStr2 = [NSMutableString string];
        [progressStr2 appendString:timeStr2];
        [progressStr2 appendString:@"="];
        [progressStr2 appendString:heartStr2];
        self.syncProgressBlock(progressStr2);
        
        [self.heartData appendData:timedata2];
        [self.heartData appendData:heartData2];
        [self.heartData appendBytes:f4 length:1];
        
//        NSLog(@"---------------(2)  %@  =  %@",timeStr2, heartStr2);
        
    }else{
        //1条心率数据
        NSMutableString* progressStr = [NSMutableString string];
        
        Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
        Byte heartBty[] = {bytes[7]};
        
        NSData* timedata = [NSData dataWithBytes:timeBty length:4];
        NSData* heartData = [NSData dataWithBytes:heartBty length:1];
        
        int i ;
        [timedata getBytes:&i length:4];
        
        int j;
        [heartData getBytes:&j length:1];
        
        NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
        NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr = [NSString stringWithFormat:@"%d",heartBty[0]];
        
        
        NSTimeInterval timeInterval= [date timeIntervalSinceReferenceDate];
        date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        
        
        NSString * timeP = [self getTimeRun:date];
        
        if ([timeP intValue]<=0) {
            
        }else{
            
            MiHeartModel * heartModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHeartModel];
            
            heartModel.testID = _testID;
            
            heartModel.teamerID = _teamberID;
            
            heartModel.groupID = _groupID;
            
            heartModel.heartNumber = heartStr ;
            
            heartModel.heartId = [NSString getStrArc4randomWithSize:10];
            
            heartModel.timePoint = timeP;
            
            heartModel.beginTime = _beginTime;
            
            if (heartStr.intValue *100 /180>100) {
                heartModel.gradeNO = @"5";
            }else if (heartStr.intValue *100 /180>=90){
                heartModel.gradeNO = @"5";
            }else if (heartStr.intValue *100 /180>=80){
                heartModel.gradeNO = @"4";
            }else if (heartStr.intValue *100 /180>=70){
                heartModel.gradeNO = @"3";
            }else if (heartStr.intValue *100 /180>=60){
                heartModel.gradeNO = @"2";
            }else{
                heartModel.gradeNO = @"1";
            }
            
            if ([[LifeBitCoreDataManager shareInstance]efAddMiHeartModel:heartModel]) {
                
            }
            
            
            
        }

        
        
        
        
        
//        BluetoothDataModel *bluetootDataModel = [[LifeBitCoreDataManager shareInstance] efCraterBluetoothDataModel];
//        bluetootDataModel.recordDate = date;
//        bluetootDataModel.bluetootData = heartStr;
//        bluetootDataModel.dataType = @"1";
//        bluetootDataModel.watchMac = [self getPeripheralMAC];
//        bluetootDataModel.bluetootDataData = heartData;
//        bluetootDataModel.recordDateData = timedata;
//        bluetootDataModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
//        [[LifeBitCoreDataManager shareInstance] efAddBluetoothDataModel:bluetootDataModel];
        

        [self.responseStr appendString:timeStr];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr];
        [self.responseStr appendString:@"mac="];
        [self.responseStr appendString:[self getPeripheralMAC]];
        [self.responseStr appendString:@"\n"];
        
        [progressStr appendString:timeStr];
        [progressStr appendString:@"="];
        [progressStr appendString:heartStr];
        self.syncProgressBlock(progressStr);
        
        [self.heartData appendData:timedata];
        [self.heartData appendData:heartData];
        Byte f4[] = {0xF4};
        [self.heartData appendBytes:f4 length:1];
//                NSLog(@"%@",self.responseStr);
    }
}

- (NSNumber *)getTimeRun:(NSDate*)nowDate{
    
//    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:_beginTime];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:nowDate options:0];
    NSInteger second = [comps second];//时间差
    
    if (second<0 && second>[_timeLong intValue]) {
        
        second = 0;
        
    }
    
    return  [NSNumber numberWithInteger: second];
}


#pragma mark  //解析步数

-(void)saveWalkBytes:(Byte*)bytes andData:(NSData*)data {
    
    NSMutableString* progressStr = [NSMutableString string];

    Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
    
    Byte walkBty[] = {bytes[7],bytes[8],bytes[9],0x00};
    
    
    NSData* timedata = [NSData dataWithBytes:timeBty length:4];
    
    NSData* walkData = [NSData dataWithBytes:walkBty length:4];
    
    
    int i ;
    [timedata getBytes:&i length:4];
    
    int j;
    [walkData getBytes:&j length:4];
    
    
    NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
    NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* walkStr = [NSString stringWithFormat:@"%d",j];
    
    NSTimeInterval timeInterval= [date timeIntervalSinceReferenceDate];
    date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    
    BluetoothDataModel *bluetootDataModel = [[LifeBitCoreDataManager shareInstance] efCraterBluetoothDataModel];
    bluetootDataModel.recordDate = date;
    bluetootDataModel.bluetootData = walkStr;
    bluetootDataModel.dataType = @"2";
    bluetootDataModel.watchMac = [self getPeripheralMAC];
    bluetootDataModel.bluetootDataData = walkData;
    bluetootDataModel.recordDateData = timedata;
    bluetootDataModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
    [[LifeBitCoreDataManager shareInstance] efAddBluetoothDataModel:bluetootDataModel];
    
//    NSLog(@"%@ 步数 = %@", bluetootDataModel.watchMac, walkStr);
//    NSLog(@"---------------( 步数)  %@  =  %@",bluetootDataModel.watchMac, walkStr);

        
    [self.responseStr appendString:timeStr];
    [self.responseStr appendString:@"="];
    [self.responseStr appendString:walkStr];
    [self.responseStr appendString:@"\n"];
    
//    [progressStr appendString:timeStr];
//    [progressStr appendString:@"="];
    
    [progressStr appendString:walkStr];
    
    self.progressStepStr = progressStr;
    self.syncProgressStepBlock(progressStr);
    
    [self.walkData appendData:timedata];
    [self.walkData appendData:walkData];
    Byte f4[] = {0xF4};
    [self.walkData appendBytes:f4 length:1];
}



#pragma mark  //解析实时心率
-(void)saveRealTimeBytes:(Byte*)bytes andData:(NSData*)data{
    
    NSData *realTimeData = [NSData dataWithBytes:&bytes[2] length:1];
    NSString *dataStr = [self convertDataToHexStr:realTimeData];
    unsigned long size = strtoul([dataStr UTF8String],0,16);
//    NSLog(@"length - >%ld",size);
//    NSLog(@"处理实时心率 %@",dataStr);
    if (self.getReadTimeSyncHeartBlock) {
        self.getReadTimeSyncHeartBlock(size);
    }
    
    self.syncType = AMCommandRealTimeSyncTypeHeart;
    Byte sendBytes[] = {0xD3,0x02};
    NSMutableData* sendData = [NSMutableData dataWithBytes:sendBytes length:2];
    
    UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
//    LBLog(@"crc :%x  ",crc);
    [sendData appendBytes:&crc length:2];
//    LBLog(@"同步运动步数指令为:%@",sendData);
    [self sendData:sendData];
}

#pragma mark  -----其他用到的工具----




-(NSString*)getPeripheralMAC{
    NSString* localName =self.peripheral.name;
    NSArray* arr = [localName componentsSeparatedByString:@"-"];
    NSString *macStr = [arr objectAtIndexWithSafety:1];
    return macStr;
}


#pragma mark  //16进制转为字符串

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}



#pragma mark  //字符串转16进制

- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}


- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}
#pragma mark  //获取日期是周几
-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"06", @"00", @"01", @"02", @"03", @"04", @"05", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


#pragma mark  //日期转化

-(NSString *)getDataWithFormat:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSString * dateString = [format stringFromDate:[NSDate date]];
    return dateString;
}


-(NSString *)transDateToString:(NSDate *)date withformotStr:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSString * dateString = [format stringFromDate:date];
    return dateString;
}

-(NSDate*)transStringToDate:(NSString *)str withformotStr:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSDate * date = [format dateFromString:str];
    return date;
}

-(void)dealloc{
//    NSLog(@"%@ AMwatchModel dealloc",self.peripheral.name);
}

@end
