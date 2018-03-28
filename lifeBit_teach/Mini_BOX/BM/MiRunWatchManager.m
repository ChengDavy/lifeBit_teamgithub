//
//  MiRunWatchManager.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/19.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiRunWatchManager.h"
#import "NSTimer+Expand.h"

@implementation MiRunWatchManager

+(instancetype)shareInstance{
    
    static MiRunWatchManager * sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

//设置全局倒计时

- (void)setTimer:(NSString *)testId{
    
    MiTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:_testId];
    
    NSString * timeStr = testModel.testTimeLong;
    
    int setTime = [[self getTimeRun:testModel.testBeginTime] intValue];
    
    int timeLong = [timeStr intValue];

    [NSTimer ibLocalInvertedTimekeeping:timeLong - setTime timing:^(int value, BOOL isArriving) {
        
        if (_isRuning && [_testId isEqualToString:testId]) {
            int leftTime = value;
            int overTime = timeLong - value;
            
            if (overTime%10==2) {
 
                [self setTeamMessage];
            }
            
            _timePoint = [NSString stringWithFormat:@"%d",overTime];
            
            NSMutableDictionary * timeDict = [[NSMutableDictionary alloc]init];
            
            [timeDict setObject:[NSString stringWithFormat:@"%d",leftTime] forKey:@"leftTime"];
            [timeDict setObject:[NSString stringWithFormat:@"%d",overTime] forKey:@"overTime"];
            [timeDict setObject:[NSString stringWithFormat:@"%@",timeStr] forKey:@"timeLong"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:KPostTime object:timeDict];
            
            if (value<=5) {
                
                 _isRuning = NO;
                
                MiHistoryTestModel * historyModel = [[LifeBitCoreDataManager shareInstance]efCraterMiHistoryTestModel];
                
                MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
                
                historyModel.avscalorie=TestModel.avscalorie;
                historyModel.avsHeart=TestModel.avsHeart;
                historyModel.avsStep=TestModel.avsStep;
                historyModel.groupId=TestModel.groupId;
                historyModel.groupName=TestModel.groupName;
                historyModel.maxHeart=TestModel.maxHeart;
                historyModel.sportMD=TestModel.sportMD;
                historyModel.sportQD=TestModel.sportQD;
                historyModel.teacherId=TestModel.teacherId;
                historyModel.sportMode=TestModel.sportMode;
                historyModel.testBeginTime=TestModel.testBeginTime;
                
                historyModel.testID=TestModel.testID;
                historyModel.testTimeLong=TestModel.testTimeLong;
                historyModel.testTittle=TestModel.testTittle;
                historyModel.testMiddleText=TestModel.testMiddleText;
                
                if ([[LifeBitCoreDataManager shareInstance]efAddMiHistoryTestModel:historyModel]) {
                    
                    [[LifeBitCoreDataManager shareInstance]efDeleteMiTestModel:TestModel];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:historyModel.testID forKey:KWaitData];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:KHoldTestSuccess object:nil];
                    
                };
                _isRuning = NO;
            }
        }else{
            
            value = 0;
        }
    }];
    
}

//启动手表

-(void)setWatchModel{
    
    _isRuning =YES;
    
    [self setTimer:_testId];
    
    _testModel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:_testId];
    
    [[HJBluetootManager shareInstance] performSelector:@selector(syncAssignClassAllWatch:) withObject:nil afterDelay:0];
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    
    _testId = TestModel.testID;
    
    _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId] mutableCopy];
    
    _unconnArry = [_testArry mutableCopy];
    
}
- (void)linkheart:(NSNotification * )not{
    
    
}
- (void)getHeartfromWatch{
    
    if (_isRuning) {
        
        NSLog(@"重连   _unconnArry.count  %ld",_unconnArry.count);
        
        if (_unconnArry.count>0) {
            
            MiUserTestModel * testModel = [_unconnArry objectAtIndexWithSafety:0];
            
            WatchModel * watch = [[LifeBitCoreDataManager shareInstance]efGetWatchModelBYwatchNo:testModel.teamerNo];
            
            MiWatchManager * watchman = nil;
            
            for (MiWatchManager * manager in _ManagerArry) {
                if ([manager.macID isEqualToString:watch.watchMAC]||[manager.testID isEqualToString:testModel.testID]) {
                    watchman = manager;
                }
            }
            if (watchman == nil) {
                watchman = [[MiWatchManager alloc]init];
                [_ManagerArry addObject:watchman];
            }
            
            
            watchman.macID = watch.watchMAC;
            
            watchman.testID = testModel.testID;
            
            watchman.teamberID = testModel.teamerId;
            
            watchman.groupID = testModel.teamerGroupId;
            
            watchman.watchNo = testModel.teamerNo;
            
            watchman.beganTime = testModel.testBeginTime;
            
            [watchman setwatch];
            
            [_unconnArry removeObject:testModel];
            
            [self getHeartfromWatch];
            
        }
        
    }
    
}

- (void)getStepfromWatch{
    
}
//结束手表

-(void)endWatchModel{
    
    _isRuning = NO;
    
    [[HJBluetootManager shareInstance] performSelector:@selector(syncCloseAllWatch:) withObject:nil afterDelay:0];
    
}

//结束手表

-(void)reSetWatchModel{
    
    _isRuning = NO;
    
    [[HJBluetootManager shareInstance] performSelector:@selector(reSetAllWatch) withObject:nil afterDelay:0];
    
}

// 恢复手表测试

- (void)reStartTest{
    NSArray * testArry = [[LifeBitCoreDataManager shareInstance]efGetAllMiTestModel];
    
    if (testArry.count>0) {
        
        MiTestModel * TestModel = [testArry objectAtIndexWithSafety:0];
        
        _testId = TestModel.testID;
        
        if (_isRuning) {
            
           _unconnArry = [_testArry mutableCopy];
            
            [self getHeartfromWatch];
          
        }else{
            
            _isRuning = YES;

            [self setWatchModel];
            
        }
        
    }else{
        
        
    }
    
}
// praise

- (void)praise{
    
    _isRuning = NO;
    
    [[HJBluetootManager shareInstance] performSelector:@selector(praiseAllWatch) withObject:nil afterDelay:0];
    
}

- (NSString *)getTimeRun:(NSString *)beganTime{
    
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:beganTime];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:nowDate options:0];
    NSInteger second = [comps second];//时间差
    
    return  [NSString stringWithFormat:@"%ld",second];
}

- (void)setTeamMessage{
    
    MiTestModel * testmodel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:@""];
    
    CTestModel * cTestModel = [CTestModel createCTestModelWithMiTestModel:testmodel];
    
    NSMutableArray * testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:cTestModel.testID] mutableCopy];
    
    //心率
    NSInteger avsHeart=0;
    
    NSInteger avsHeartNo=0;
    
    NSInteger MaxHeart=0;
    
    //运动距离(米)
    
    
    NSInteger avscalorie=0;
    
    NSInteger avscalorieNO=0;
    
    //步数
    NSInteger avsStep=0;
    
    NSInteger avsStepNO=0;
    
    //运动密度
    NSInteger sportMD=0;
    
    NSInteger sportMDNO=0;
    
    //运动强度
    NSInteger sportQD=0;
    
    NSInteger sportQDNO=0;
    
    
    for (int i = 0; i < testArry.count; i++) {
        
        
        MiUserTestModel * userTestModel = [testArry objectAtIndexWithSafety:i];
        
        avsHeart = avsHeart + userTestModel.avsHeart.integerValue;
        
        if (userTestModel.avsHeart.integerValue) {
            avsHeartNo = avsHeartNo +1;
        }
        
        avscalorie = avscalorie + userTestModel.calorie.integerValue;
        
        if (userTestModel.calorie.integerValue) {
            avscalorieNO = avscalorieNO +1;
        }
        
        avsStep = avsStep + userTestModel.step.integerValue;
        
        if (userTestModel.step.integerValue) {
            avsStepNO = avsStepNO +1;
        }
        
        sportQD = sportQD + userTestModel.sportQD.integerValue;
        
        if (userTestModel.sportQD.integerValue) {
            sportQDNO = sportQDNO +1;
        }
        
        sportMD = sportMD + userTestModel.sportMD.integerValue;
        
        if (userTestModel.sportMD.integerValue) {
            sportMDNO = sportMDNO +1;
        }
        
        if (MaxHeart <  userTestModel.maxHeart.integerValue) {
            
            MaxHeart =userTestModel.maxHeart.integerValue;
        }
    }
    
    testmodel.avsStep = [NSString stringWithFormat:@"%ld",avsStep/avsStepNO];
    
    testmodel.avscalorie = [NSString stringWithFormat:@"%ld",avscalorie/avscalorieNO];
    
    testmodel.avsHeart = [NSString stringWithFormat:@"%ld",avsHeart/avsHeartNo];
    
    testmodel.sportQD = [NSString stringWithFormat:@"%ld",sportQD/sportQDNO];
    
    testmodel.sportMD = [NSString stringWithFormat:@"%ld",sportMD/sportMDNO];
    
    testmodel.maxHeart = [NSString stringWithFormat:@"%ld",MaxHeart];
    
    
    if ([[LifeBitCoreDataManager shareInstance] efAddMiTestModel:testmodel] ) {
        
    }
    
}

-(void)dealHeartWithTestID:(NSString*)testID{
    
    //
    MiHistoryTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:testID];
    
    NSString * useHeart = [[NSUserDefaults standardUserDefaults]objectForKey:KUseHeart];
    
    if (useHeart.length<2) {
        useHeart = @"90";
    }
    NSInteger userHeartNum = useHeart.integerValue;
    
    NSMutableArray * teamerArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiTeamerWith:testModel.groupId];
    
    NSInteger testHeartSum = 0;
    NSInteger testHeartCount = 0;
    NSInteger testHeartMDCount = 0;
    
    for (MiTeamer * teamer in teamerArry) {
        
        NSLog(@"teamer.teamerName %@",teamer.teamerName);
      
        MiUserTestModel * userTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:testID teamerID:teamer.teamerId];
        
        NSMutableArray * testHeartArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelWithTestId:testID withTeamerId:teamer.teamerId];
        
        NSInteger heartSum = 0;
        NSInteger heartCount = 0;
        NSInteger heartMDCount = 0;
        
        for (MiHeartModel * heartModel in testHeartArry) {
            
            if (heartModel.heartNumber.integerValue>0) {
                heartSum = heartSum + heartModel.heartNumber.integerValue;
                heartCount ++;
                
                if (heartModel.heartNumber.integerValue > userTestModel.maxHeart.integerValue) {
                    
                    userTestModel.maxHeart = heartModel.heartNumber;
                    
                }
                if (heartModel.heartNumber.integerValue > userHeartNum) {
                    heartMDCount++;
                }
            }
        }
        
        if (heartCount>0) {
            
            testHeartSum = testHeartSum + heartSum;
            testHeartCount = testHeartCount + heartCount;
            testHeartMDCount = testHeartMDCount + heartMDCount;
            
            if (testModel.maxHeart.integerValue < userTestModel.maxHeart.integerValue) {
                
                testModel.maxHeart = userTestModel.maxHeart;
                
            }
            
            
            userTestModel.avsHeart=[NSString stringWithFormat:@"%ld",heartSum/heartCount];
            userTestModel.sportMD = [NSString stringWithFormat:@"%ld",heartMDCount*100/heartCount];
            
            NSLog(@"userTestModel.sportMD  %@",userTestModel.sportMD);
        }

        
        
        [[LifeBitCoreDataManager shareInstance]efUpdateMiUserTestModel:userTestModel];
        
    }
    
    if (testHeartCount>0) {
        
        testModel.avsHeart = [NSString stringWithFormat:@"%ld",testHeartSum/testHeartCount];
        testModel.sportMD = [NSString stringWithFormat:@"%ld",testHeartMDCount*100/testHeartCount];
   
    }
    
    [[LifeBitCoreDataManager shareInstance]efUpdateMiHistoryTestModel:testModel];
    
}



@end
