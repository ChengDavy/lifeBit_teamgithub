//
//  MiWatchManager.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/18.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiWatchManager.h"

@implementation MiWatchManager


- (void)setwatch{
    
    _watchArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    _errorTimes=0;
    
    [self getStep];
}
- (void)getWatch{

    if ([MiRunWatchManager shareInstance].isRuning) {
    
    for (LBWatchPerModel * watchPerModel in _watchArry) {
        
        if ([[[watchPerModel.peripheral.name componentsSeparatedByString:@"-"] objectAtIndexWithSafety:1] isEqualToString:_macID]) {
            
            [watchPerModel syncRealTimeWithSuccess:^(NSObject *anyObj) {
                
            } fail:^(NSString *errorStr) {
                
                NSLog(@"errorStr %@   %@",_watchNo,errorStr);
                
                if ([errorStr isEqualToString:@"手表超时或app没有响应蓝牙手表的数据"]) {
                    MiUserTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:[MiRunWatchManager shareInstance].testId teamerID:_teamberID];
                    
                        [[MiRunWatchManager shareInstance].unconnArry addObject:testModel];
                    
                        [[HJBluetootManager shareInstance] addReConnectWithWatch:watchPerModel];
                                        
                        return ;
                }
            }];
            
            __block int seconds1 = 0;
            
            [watchPerModel setGetReadTimeSyncHeartBlock:^(NSInteger heart) {
                
                if (![MiRunWatchManager shareInstance].isRuning) {
                    return ;
                }
                
                if (heart <= 0) {
                    
                    
                    if (_errorTimes<10) {
                        
                        [self performSelector:@selector(getWatch) withObject:nil afterDelay:2.0f];
                        
                        _errorTimes++;
                        
                    }else if (_errorTimes>=10){
                        _errorTimes = 0;

                        MiUserTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:[MiRunWatchManager shareInstance].testId teamerID:_teamberID];
                        
                        [[MiRunWatchManager shareInstance].unconnArry addObject:testModel];
                        
                        [[HJBluetootManager shareInstance] addReConnectWithWatch:watchPerModel];
                        
                        
                        return ;
                    }
                    
                    return;
                }
                if (seconds1 % 100 ==0) {
                    
                    MiHeartModel * heartModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHeartModel];
                    
                    heartModel.testID = _testID;
                    
                    heartModel.teamerID = _teamberID;
                    
                    heartModel.groupID = _groupID;
                    
                    heartModel.heartNumber = [NSString stringWithFormat:@"%ld",heart];
                    
                    heartModel.heartId = [NSString getStrArc4randomWithSize:10];
                    
                    heartModel.timePoint = [self getTimeRun];
                    
                    heartModel.beginTime = _beganTime;
                    
                    if (heart *100 /180>100) {
                        heartModel.gradeNO = @"5";
                    }else if (heart *100 /180>=90){
                        heartModel.gradeNO = @"5";
                    }else if (heart *100 /180>=80){
                        heartModel.gradeNO = @"4";
                    }else if (heart *100 /180>=70){
                        heartModel.gradeNO = @"3";
                    }else if (heart *100 /180>=60){
                        heartModel.gradeNO = @"2";
                    }else{
                        heartModel.gradeNO = @"1";
                    }

                    if ([[LifeBitCoreDataManager shareInstance]efAddMiHeartModel:heartModel]) {
                        
                    }
                    
             if (seconds1%500==0) {
                 
                    MiUserTestModel * testModel = [[LifeBitCoreDataManager shareInstance] efGetMiUserTestModelUserTestModelId:_testID teamerID:_teamberID];
                    
                    NSInteger  maxheart =testModel.maxHeart.integerValue;
                    
                    if (heart > maxheart) {
                        
                        testModel.maxHeart = [NSString stringWithFormat:@"%ld",heart];
                    }
                    
                        [[LifeBitCoreDataManager shareInstance]efAddMiUserTestModel: testModel];
                    
                         testModel.heart = [NSString stringWithFormat:@"%ld",heart];
                 
                 NSString * useHeart = [[NSUserDefaults standardUserDefaults]objectForKey:KUseHeart];
                 if (useHeart.length<2) {
                     useHeart = @"120";
                 }
                         
                         testModel.sportQD = [NSString stringWithFormat:@"%ld",heart*100 / ([useHeart integerValue]+30)];
                         
                         NSDictionary * SPORTMD = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelGradeWithTestId:_testID withTeamerId:_teamberID];
                         
                         if ([[SPORTMD objectForKeyNotNull:@"perMD"] integerValue]>0) {
                             
                             testModel.sportMD = [SPORTMD objectForKeyNotNull:@"perMD"];
                             
                         }
                         NSMutableArray * heartArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelWithTestId:_testID withTeamerId:_teamberID];
                         _totalheart=0;
                         for (MiHeartModel * aheartModel in heartArry) {
                             
                             _totalheart = _totalheart + [aheartModel.heartNumber integerValue];
                         }
                         testModel.avsHeart = [NSString stringWithFormat:@"%ld",_totalheart/heartArry.count];
  
                      if ([[LifeBitCoreDataManager shareInstance]efAddMiUserTestModel: testModel]) {
                        
                            [self performSelector:@selector(getStep) withObject:nil afterDelay:1];
                            
                        }
                    }
                }
                _errorTimes = 0;
                seconds1++;
            }];
            
        }else{
            
        }
        
    }
    }else{
        
    }
}

#pragma mark 请求步数

- (void)getStep{
    
    if ([MiRunWatchManager shareInstance].isRuning) {
        
        for (LBWatchPerModel * watchPerModel in _watchArry) {
            
            if ([[[watchPerModel.peripheral.name componentsSeparatedByString:@"-"] objectAtIndexWithSafety:1] isEqualToString:_macID]) {
                
                
                [watchPerModel syncWalkWithProgress:^(NSObject *anyObj) {
                    
                    if (![MiRunWatchManager shareInstance].isRuning) {
                        return ;
                    }
                    if ([[NSString stringWithFormat:@"%@",anyObj] integerValue]>0) {
                        
                        MiUserTestModel * userTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:[MiRunWatchManager shareInstance].testId teamerID:_teamberID];
                        
                        if ([[NSString stringWithFormat:@"%@",anyObj] integerValue]>  [userTestModel.step integerValue]) {
                            
                            userTestModel.step = [NSString stringWithFormat:@"%@",anyObj];
                            
                            
                            NSString * calor = [NSString stringWithFormat:@"%ld",[userTestModel.teamerheight integerValue]*6*[userTestModel.step integerValue]/1500];
                            
                            NSLog(@"%@   %@   userTestModel.step  %@",userTestModel.teamerheight ,calor  ,userTestModel.step);
                            
                            userTestModel.calorie = calor;
                            
                            [[LifeBitCoreDataManager shareInstance] efUpdateMiUserTestModel:userTestModel];
                        }
                        
                    }
                    
                } Success:^(NSObject *anyObj) {
                    
                    watchPerModel.upDateWalkData = (NSData*)anyObj;
                    watchPerModel.progressStepStr = @"";
                    
                    NSString* base64Str = [watchPerModel.upDateWalkData base64EncodedStringWithOptions:0];
                    
                    [self performSelector:@selector(getWatch) withObject:nil afterDelay:1];
                    
                    return ;

                } fail:^(NSString *errorStr) {

                    _stepSeconds++;
                    
                     NSLog(@"%@  记步错误次数%d次",_watchNo,_stepSeconds);
                    
                    if (_stepSeconds > 5) {
                        
                        _stepSeconds = 0;
                    
                        
                        MiUserTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:[MiRunWatchManager shareInstance].testId teamerID:_teamberID];
                        
                        [[MiRunWatchManager shareInstance].unconnArry addObject:testModel];
                        
                        [[HJBluetootManager shareInstance] addReConnectWithWatch:watchPerModel];
                        
                        
                        return ;
                        
                    }else{
                        
                        [self performSelector:@selector(getStep) withObject:nil afterDelay:1];
                    }
                    
                }];
                
            }else{
                
            }
            
        }
 
    }else{
   
    }
   
}

- (NSNumber *)getTimeRun{
    
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:_beganTime];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:nowDate options:0];
    NSInteger second = [comps second];//时间差
    
//    NSLog(@"secondsecond  %ld",second);
    
    return  [NSNumber numberWithInteger: second];
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
- (void)getEndData{
    
    
    
    
}
@end

