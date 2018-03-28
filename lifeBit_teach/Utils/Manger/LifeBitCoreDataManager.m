//
//  LifeBitCoreDataManager.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "LifeBitCoreDataManager.h"
static LifeBitCoreDataManager *_coreData = nil;
@implementation LifeBitCoreDataManager
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreData = [[self alloc] init];
    });
    return _coreData;
}

+(void)destroyInstance{
    if (_coreData) {
        _coreData = nil;
    }
}
#pragma mark - 版本信息
//==============================================================================

/* 版本信息*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return VersionModel
 */
-(VersionModel*)efCraterVersionModel{
    VersionModel *versionModel = (VersionModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KVersionModel];
    return  versionModel;
    
}
/**
 *  获取所有版本信息
 *
 *  @return VersionModel
 */
-(NSMutableArray*)efGetAllVersionModel{
    NSMutableArray *versionArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KVersionModel sortByKey:nil];
    return versionArr;
}

/**
 *  添加版本信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddVersionModel:(VersionModel *)versionModel{
    BOOL isSuccess = NO;
    VersionModel *mo = [self efGetVersionModelWithTeacherId:versionModel.uTeacherId];
    
    if (versionModel) {
        if (!(versionModel == mo)) {
            [self efDeleteVersionModel:mo];
            mo = versionModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据老师id获取版本信息
 *
 *  @param 老师id
 *
 *  @return
 */
-(VersionModel*)efGetVersionModelWithTeacherId:(NSString*)teacherId{
    NSMutableArray *versionArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KVersionModel condition:[NSString stringWithFormat:@"uTeacherId = %@",teacherId] sortByKey:nil];
    if (versionArr.count > 0) {
        VersionModel *versionModel = [versionArr objectAtIndexWithSafety:0];
        return versionModel;
    }
    return [self efCraterVersionModel];
}


/**
 *  删除指定老师的版本
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteVersionModel:(VersionModel *)versionModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:versionModel];
}

/**
 *  更新老师版本信息
 *
 *  @param VersionModel
 *
 *  @return
 */
-(BOOL)efUpdateVersionModel:(VersionModel *)versionModel{
    return  [self efAddVersionModel:versionModel];
}

/**
 *  清空所有版本信息
 *
 *  @return
 */
-(BOOL)efDeleteAllVersionModel{
    BOOL flag = YES;
    for (VersionModel* versionModel in [self efGetAllVersionModel]) {
        if (![self efDeleteVersionModel:versionModel]) {
            flag = NO;
        }
    }
    return flag;
}
#pragma mark - 用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(UserModel*)efCraterUserModel{
    UserModel *userModel = (UserModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KUserModel];
    return  userModel;
}
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllUserModel{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel sortByKey:nil];
    return userArr;
}

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddUserModel:(UserModel *)user{
    BOOL isSuccess = NO;
    UserModel *mo = [self efGetUserModelMobile:user.uAccount andPassword:user.uPassword];
    
    if (user) {
        if (!(user == mo)) {
            [self efDeleteUserModel:mo];
            mo = user;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllUserModelWith:(NSString*)schoolId{
    NSString *conditionStr = [NSString stringWithFormat:@"uSchoolId = '%@'",schoolId];
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel condition:conditionStr sortByKey:@"uTeacherId" limit:100 ascending:YES];
    return studentArr;
}

/**
 *  根据老师用户Id获取详情
 *
 *  @param uId
 *
 *  @return
 */
-(UserModel *)efGetUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel condition:[NSString stringWithFormat:@"uAccount = '%@' and uPassword = '%@'",mobileStr,password] sortByKey:nil];
    if (userArr.count > 0) {
        UserModel *userModel = [userArr objectAtIndexWithSafety:0];
        return userModel;
    }
    return [self efCraterUserModel];
}

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteUserModel:(UserModel *)user{
    return  [[CoreDataManager shareInstance] deleteWithObject:user];
}

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateUserModel:(UserModel *)user{
    return  [self efAddUserModel:user];
}

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllUserModel{
    BOOL flag = YES;
    for (UserModel* user in [self efGetAllUserModel]) {
        if (![self efDeleteUserModel:user]) {
            flag = NO;
        }
    }
    return flag;
}






#pragma --mark-- 手表管理
//==============================================================================

/*手表管理*/

//==============================================================================
/**
 *  创建手环
 *
 *  @return WatchModel
 */
-(WatchModel*)efCraterWatchModel{
    WatchModel *watch =  (WatchModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kWatchModel];
    return watch;
}
/**
 *  获取所有手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetAllWatchModel {
    
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:nil sortByKey:@"watchNo"];
    
    return watchArr;
}


-(NSMutableArray*)efGetTearchAllWatchModel:(NSString*)tearchId{
    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
    NSString *conditionStr = [NSString stringWithFormat:@"ipadIdentifying = '%@' and teacherId = '%@'",uuidStr,tearchId];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:conditionStr sortByKey:@"watchNo"];
    return watchArr;
}

/**
 *  ID 查找手环
 *
 *  @param WatchModel
 *
 *  @return
 */

-(WatchModel*)efGetWatchModelBYwatchNo:(NSString*)watchNo{
//    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
    NSString *conditionStr = [NSString stringWithFormat:@"watchNo = '%@'",watchNo];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:conditionStr sortByKey:@"watchNo"];
    
    if (watchArr.count>0) {
        WatchModel * searchwatchmodel = [watchArr objectAtIndexWithSafety:0];
        return searchwatchmodel;
    }
    
     return [self efCraterWatchModel];
}

-(BOOL)efDeleteTearchAllWatchModel:(NSString*)tearchId{
    BOOL isSuccess = NO;
    NSMutableArray *watchArr = [self efGetTearchAllWatchModel:tearchId];
    for (WatchModel *watch  in watchArr) {
        isSuccess = [[CoreDataManager shareInstance] deleteWithObject:watch];
    }
    return isSuccess;
}

/**
 *  添加手环到数据库
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efAddWatchModel:(WatchModel *)watch{
    BOOL isSuccess = NO;
    WatchModel *mo = [self efGetWatchDetailedById:watch.watchMAC];
    if (mo) {
        if (!(mo == watch)) {
            [self efDeleteWatchModel:mo];
            mo = watch;
        }
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据手表Id获取手表详情
 *
 *  @param watchId
 *
 *  @return
 */
-(WatchModel *)efGetWatchDetailedById:(NSString*)watchId{
    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:[NSString stringWithFormat:@"watchMAC = '%@' and ipadIdentifying = '%@'",watchId,uuidStr] sortByKey:nil];
    if (watchArr.count > 0) {
        WatchModel *watchModel = [watchArr objectAtIndexWithSafety:0];
        return watchModel;
    }
    return [self efCraterWatchModel];
}
/**
 *  根据手表Id判断mac地址是否在教具箱中存在
 *
 *  @param 手表mac地址
 *
 *  @return
 */
-(BOOL)efGetBoxIsWatch:(NSString*)mac {
    
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:[NSString stringWithFormat:@"watchMAC = '%@'",mac] sortByKey:nil];

    if (watchArr.count > 0) {
        return YES;
    }
    return NO;
}

/**
 *  根据ipad标识获取手环列表
 *  @param ipad标识
 *  @return
 */
-(NSMutableArray *)efGetIpadIdentifyingAllWatchWith:(NSString*)ipadIdentifying{
    NSString *condition = [NSString stringWithFormat:@"ipadIdentifying = '%@'",ipadIdentifying];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:condition sortByKey:@"watchNo" limit:100 ascending:YES];
    return watchArr;
}


/**
 *  删除手表信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteWatchModel:(WatchModel *)watch{
    return  [[CoreDataManager shareInstance] deleteWithObject:watch];
}



/**
 *  清空所有手表信息
 *
 *  @return
 */
-(BOOL)efDeleteAllWatchModel{
    BOOL flag = YES;
    for (WatchModel* watch in [self efGetAllWatchModel]) {
        if (![self efDeleteWatchModel:watch]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 同步数据管理
//==============================================================================

/* 同步数据管理*/

//==============================================================================
/**
 *
 *
 *  @return LessonPlanModel
 */
-(BluetoothDataModel*)efCraterBluetoothDataModel{
    BluetoothDataModel *bluetoothDataModel = (BluetoothDataModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KBluetoothDataModel];
    return bluetoothDataModel;
}
/**
 *  获取所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetAllBluetoothDataModel{
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel sortByKey:nil];
    return bluetoothDataModelArr;
}


/**
 *  获取指定老师所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetTearcherAllBluetoothDataModel{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"teacherId=%@",[HJUserManager shareInstance].user.uTeacherId];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}
/**
 *  添加数据
 *
 *  @param BluetoothDataModel
 *
 *  @return
 */
-(BOOL)efAddBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel{
    BOOL isSuccess = NO;
    BluetoothDataModel *mo = [self efGetBluetoothDataModelWithDate:bluetoothDataModel.recordDate withDataType:bluetoothDataModel.dataType withMAC:bluetoothDataModel.watchMac];
    if (mo) {
        if (!(mo == bluetoothDataModel)) {
            [self efDeleteBluetoothDataModel:mo];
            mo = bluetoothDataModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}
/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param timeDate 指定时间
 *  @param DataType 指定的数据类型
 *  @param macStr 手表mac地址
 *  @return
 */
-(BluetoothDataModel *)efGetBluetoothDataModelWithDate:(NSDate*)timeDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr {
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@ and watchMac = %@ and (recordDate = %@)",dataType,macStr,timeDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (bluetoothDataModelArr.count > 0) {
        BluetoothDataModel *bluetoothDataModel = [bluetoothDataModelArr objectAtIndexWithSafety:0];
        return bluetoothDataModel;
    }
    BluetoothDataModel *bluetoothDataModel = (BluetoothDataModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KBluetoothDataModel];
    return bluetoothDataModel;
}

/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @param macStr 手表mac地址
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr {
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@ and watchMac = %@ and (recordDate > %@ and recordDate < %@)",dataType,macStr,startDate,endDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}

/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType{
    //查询查询条件 and (recordDate = %@
    if (dataType.length <=0 || dataType == nil) {
        dataType = @"";
    }
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@  and (recordDate > %@ and  recordDate < %@)",dataType,startDate,endDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}

/**
 *  删除指定的同步数据
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:bluetoothDataModel];
}

/**
 *  清空所有同步数据
 *
 *  @return
 */
-(BOOL)efDeleteAllBluetoothDataModel{
    BOOL flag = YES;
    for (BluetoothDataModel* bluetoothDataModel in [self efGetAllBluetoothDataModel]) {
        if (![self efDeleteBluetoothDataModel:bluetoothDataModel]) {
            flag = NO;
        }
    }
    return flag;
}



#pragma --mark-- 已经上课课程
//==============================================================================

/*已经上课课程*/

//==============================================================================
/**
 *  创建已上课程
 *
 *  @return HaveClassModel
 */
-(HaveClassModel*)efCraterHaveClassModel{
    HaveClassModel *haveClassModel = (HaveClassModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KHaveClassModel];
    return haveClassModel;
}
/**
 *  获取所有所有已经上课课程
 *
 *  @return [HaveClassModel]
 */
-(NSMutableArray*)efGetAllHaveClassModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    
    NSMutableArray *haveClassModelArr =[[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel  condition:conditionStr sortByKey:@"startDate" limit:100 ascending:YES];
    return haveClassModelArr;
}

/**
 *  添加课程到已上课程列表中
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efAddHaveClassModel:(HaveClassModel *)classModel{
    BOOL isSuccess = NO;
    HaveClassModel *mo = [self efGetHaveClassModelDetailedWithclassId:classModel.classId andStart:classModel.startDate];
    if (mo) {
        if (!(mo == classModel)) {
            [self efDeleteHaveClassModel:mo];
            mo = classModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
    
}
/**
 *  根据课程ID获取详情
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HaveClassModel *)efGetHaveClassModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"teacherId = %@ and classId = %@ and (startDate >= %@)",[HJUserManager shareInstance].user.uTeacherId,classId,startDate];
    NSString *key = @"startDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0 ) {
        for (HaveClassModel *haveClassModel in haveClassModelArr) {
            if ([haveClassModel.classId isEqualToString:classId] && [haveClassModel.startDate compare:startDate] == NSOrderedSame) {
                
                return haveClassModel;
            }
        }
    }
    HaveClassModel *haveClassModel = [self efCraterHaveClassModel];
    return haveClassModel;
}

/**
 *  根据课程来源和上课状态获取课程
 *
 *  @param sourceType    来源类型 课程来源类型（1 课程表 ,2 自定义）
 *  @param scheduleStatus  课程状态
 *  @return
 */
-(NSMutableArray *)efGetHaveClassModelWithSourceType:(NSNumber*)sourceType andScheduleStatus:(NSString*)scheduleStatus{
    NSString *predicateFormat = nil;
    if ([sourceType intValue] == 0) {
        predicateFormat = [NSString stringWithFormat:@"classStatus = %@ and teacherId = %@",scheduleStatus,[HJUserManager shareInstance].user.uTeacherId];
    }else {
        predicateFormat = [NSString stringWithFormat:@"classStatus = %@ and scheduleType = %@ and teacherId = %@",scheduleStatus,sourceType,[HJUserManager shareInstance].user.uTeacherId];
    }
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:predicateFormat];
    NSString *key = @"startDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    
    return haveClassModelArr;
}








/**
 *  删除课程表信息
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHaveClassModel:(HaveClassModel *)haveClassModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:haveClassModel];
}



/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllHaveClassModel{
    BOOL flag = YES;
    for (HaveClassModel* haveClassModel in [self efGetAllHaveClassModel]) {
        if (![self efDeleteHaveClassModel:haveClassModel]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 保存的测试班级信息
//==============================================================================

/*成绩未上传成功上课班级列表*/

//==============================================================================
/**
 *  创建未上传记录对象
 *
 *  @return TestModel
 */
-(TestModel*)efCraterTestModel{
    TestModel *testModel = (TestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KTestModel];
    return testModel;
}
/**
 *  获取所有未上传成绩的几率
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllTestModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:KTestModel condition:conditionStr sortByKey:@"startTime" limit:1000 ascending:YES];
    
}

/**
 *  添加未上传的记录到数据库中
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddTestModel:(TestModel *)testModel{
    BOOL isSuccess = NO;
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据时间和班级id获取
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(TestModel *)efGetTestModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"classId = %@ and (startTime >= %@)",classId,startDate];
    NSString *key = @"startTime";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0) {
        TestModel *testModel = [haveClassModelArr objectAtIndexWithSafety:0];
        return testModel;
    }
    TestModel *testModel = [self efCraterTestModel];
    return testModel;
}

/**
 *  删除测试记录
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteTestModel:(TestModel *)testModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:testModel];
}

/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllTestModel{
    BOOL flag = YES;
    for (TestModel* testModel in [self efGetAllTestModel]) {
        if (![self efDeleteTestModel:testModel]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 保存的测试历史数据
//==============================================================================

/*保存的测试历史数据*/

//==============================================================================
/**
 *  创建所有测试历史数据
 *
 *  @return TestModel
 */
-(HistoryTestModel*)efCraterHistoryTestModel{
    HistoryTestModel *testModel = (HistoryTestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KHistoryTestModel];
    return testModel;
}
/**
 *  获取所有测试历史
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllHistoryTestModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:KHistoryTestModel condition:conditionStr sortByKey:nil limit:1000 ascending:nil];
}

/**
 *  添加测试历史数据
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddHistoryTestModel:(HistoryTestModel *)historyTestModel{
    BOOL isSuccess = NO;
    HistoryTestModel *mo = [self efGetHistoryTestModelDetailedWithclassId:historyTestModel.teacherId andStart:historyTestModel.startDate];
    if (mo) {
        if (!(mo == historyTestModel)) {
            [self efDeleteHistoryTestModel:mo];
            mo = historyTestModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据时间和班级id获取
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HistoryTestModel *)efGetHistoryTestModelDetailedWithclassId:(NSString*)teachId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
    //    NSString *predicateStr = [NSString stringWithFormat:];
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"(teacherId = %@) and (startDate >= %@)",[HJUserManager shareInstance].user.uTeacherId,startDate];
    BOOL isAscending = NO;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHistoryTestModel PredicateCondition:predicateCondition sortByKey:nil limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0) {
        HistoryTestModel *historyTestModel = [haveClassModelArr objectAtIndexWithSafety:0];
        return historyTestModel;
    }
    HistoryTestModel *historyTestModel = [self efCraterHistoryTestModel];
    return historyTestModel;
}

/**
 *  删除测试历史数据
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHistoryTestModel:(HistoryTestModel *)historyTestModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:historyTestModel];
}


/**
 *  清空所有已测试历史数据
 *
 *  @return
 */
-(BOOL)efDeleteAllHistoryTestModel{
    BOOL flag = YES;
    for (HistoryTestModel* historyTestModel in [self efGetAllHistoryTestModel]) {
        if (![self efDeleteHistoryTestModel:historyTestModel]) {
            flag = NO;
        }
    }
    return flag;
}



#pragma mark - 新用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(MiUserDataModel*)efCraterMiUserModel{
    MiUserDataModel *MiuserModel = (MiUserDataModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KMiuserDataModel];
    return  MiuserModel;
    
}
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiUserModel{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KMiuserDataModel sortByKey:nil];
    return userArr;
    
}

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddMiUserModel:(MiUserDataModel *)user{
    
    BOOL isSuccess = NO;
    
    MiUserDataModel *mo = [self efGetMiUserModelMobile:user.pId andPassword:user.pPass];
//    NSLog(@"id   %@",mo.pId);
    
    if (user) {
        if (!(user == mo)) {
            [self efDeleteMiUserModel:mo];
            mo = user;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
}

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserModelWith:(NSString*)schoolId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"uSchoolId = '%@'",schoolId];
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KMiuserDataModel condition:conditionStr sortByKey:@"pId" limit:100 ascending:YES];
    return studentArr;
}

/**
 *  根据老师账号和密码获取用户信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiUserDataModel *) efGetMiUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KMiuserDataModel condition:[NSString stringWithFormat:@"pId = '%@' and pPass = '%@'",mobileStr,password] sortByKey:nil];
    if (userArr.count > 0) {
        MiUserDataModel *userModel = [userArr objectAtIndexWithSafety:0];
        
        return userModel;
    }
    return [self efCraterMiUserModel];
}

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteMiUserModel:(MiUserDataModel *)user{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:user];
    
}

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateMiUserModel:(MiUserDataModel *)user{
    return  [self efAddMiUserModel:user];
}

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllMiUserModel{
    BOOL flag = YES;
    for (MiUserDataModel* user in [self efGetAllMiUserModel]) {
        if (![self efDeleteMiUserModel:user]) {
            flag = NO;
        }
    }
    return flag;
    
}



#pragma mark - 团队信息
//==============================================================================

/*团队信息*/

//==============================================================================
/**
 *  创建团队信息
 *
 *  @return UserModel
 */
-(MiGroupModel*)efCraterMiGroupModel{
    
    MiGroupModel * GroupModel = (MiGroupModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiGroupModel];
    return  GroupModel;
    
    
}
/**
 *  获取所有团队
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiGroupModel{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiGroupModel sortByKey:nil];
    return userArr;
    
    
}

-(NSMutableArray*)efGetAllMemberWithMiGroupModelArry:(NSArray *)GroupArry{
    
    
    
//    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiGroupModel sortByKey:nil];
    
    NSMutableArray * myGroupArry = [[NSMutableArray alloc]init];
    
    for (MiGroupModel * groupModel in GroupArry) {
        
        NSLog(@"groupModel.groupID   %@",groupModel.groupID);
        
        NSMutableArray * teamerArry = [self efGetSchoolAllMiTeamerWith:groupModel.groupID];
        
        [myGroupArry addObject:teamerArry];
        
    }
    
    return myGroupArry;
    
}

/**
 *  添加团队到数据库
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efAddMiGroupModel:(MiGroupModel *)Group{
    
    BOOL isSuccess = NO;
    
    MiGroupModel *mo = [self efGetMiGroupModelGroupId:Group.groupID];
    NSLog(@"id   %@",mo.groupID);
    
    if (Group) {
        if (!(Group == mo)) {
            [self efDeleteMiGroupModel:mo];
            mo = Group;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
    
}

/**
 *  根据团队id获取团队成员
 *  @param 团队ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiGroupModelWith:(NSString*)GroupId{
    
    //    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiGroupModel condition:[NSString stringWithFormat:@"groupID = '%@'",GroupId] sortByKey:nil];
    //    if (userArr.count > 0) {
    //        MiGroupModel * groupModel = [userArr objectAtIndexWithSafety:0];
    //
    //        return userModel;
    //    }
    //    return [self efCraterMiUserModel];
    
    return  nil;
}

/**
 *  根据团队ID获取团队信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiGroupModel *)efGetMiGroupModelGroupId:(NSString *)GroupId{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiGroupModel condition:[NSString stringWithFormat:@"groupID = '%@'",GroupId] sortByKey:nil];
    if (userArr.count > 0) {
        MiGroupModel * groupModel = [userArr objectAtIndexWithSafety:0];
        
        return groupModel;
    }
    return [self efCraterMiGroupModel];
}

/**
 *  删除团队信息
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efDeleteMiGroupModel:(MiGroupModel *)GroupModel{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:GroupModel];
    
}

/**
 *  更新团队信息
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efUpdateMiGroupModel:(MiGroupModel *)groupModel{
    
     return  [self efAddMiGroupModel:groupModel];
    
}

/**
 *  清空所有群组
 *
 *  @return
 */
-(BOOL)efDeleteAllMiGroupModel{
    
    BOOL flag = YES;
    for (MiGroupModel* user in [self efGetAllMiUserModel]) {
        if (![self efDeleteMiGroupModel:user]) {
            flag = NO;
        }
    }
    return flag;

    
}



#pragma mark -成员信息
//==============================================================================

/*成员信息*/

//==============================================================================
/**
 *  创建成员信息
 *
 *  @return UserModel
 */
-(MiTeamer*)efCraterMiTeamer{
    
    MiTeamer * GroupModel = (MiTeamer*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiTeamer];
    return  GroupModel;
    
}
/**
 *  获取所有成员
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiTeamer{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTeamer sortByKey:nil];
    return userArr;
    
}

/**
 *  添加成员到数据库
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efAddMiTeamer:(MiTeamer *)teamerModel{
    
    BOOL isSuccess = NO;
    
    MiTeamer *mo = [self efGetMiTeamerteamerId:teamerModel.teamerId];
    NSLog(@"id   %@",mo.teamerId);
    
    if (teamerModel) {
        
        NSLog(@"%@   %@",teamerModel.teamerId,mo.teamerId);
           NSLog(@"%@   %@",teamerModel.teamerName,mo.teamerName);
        
        if (!(teamerModel == mo)) {
            
            NSLog(@"%@   %@",teamerModel.teamerName,mo.teamerName);
            
            [self efDeleteMiTeamer:mo];
            
            mo = teamerModel;
        }
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
    
    return isSuccess;
}

/**
 *  根据团队id获取成员
 *  @param成员ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiTeamerWith:(NSString*)GroupId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"teamerGroupId = '%@'",GroupId];
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTeamer condition:conditionStr sortByKey:@"teamerNo" limit:100 ascending:YES];
    return teamerArr;
}

/**
 *  根据成员ID获取成员信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiTeamer *)efGetMiTeamerteamerId:(NSString *)teamerId{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTeamer condition:[NSString stringWithFormat:@"teamerId = '%@'",teamerId] sortByKey:nil];
    
    if (userArr.count > 0) {
        MiTeamer *userModel = [userArr objectAtIndexWithSafety:0];
        return userModel;
    }
    return [self efCraterMiTeamer];
}

/**
 *  删除成员信息
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efDeleteMiTeamer:(MiTeamer *)teamerModel{
    
      return  [[CoreDataManager shareInstance] deleteWithObject:teamerModel];
}

/**
 *  更新成员信息
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efUpdateMiTeamer:(MiTeamer *)teamerModel{
    
    return  [self efAddMiTeamer:teamerModel];

    
}

/**
 *  清空所有成员
 *
 *  @return
 */
-(BOOL)efDeleteAllMiTeamer{
    
    BOOL flag = YES;
    for (MiTeamer* user in [self efGetAllMiTeamer]) {
        if (![self efDeleteMiTeamer:user]) {
            flag = NO;
        }
    }
    return flag;
    
}



#pragma mark -历史测试信息
//==============================================================================

/*历史测试信息*/

//==============================================================================
/**
 *  创建历史测试信息
 *
 *  @return UserModel
 */
-(MiHistoryTestModel*)efCraterMiHistoryTestModel{
    
    MiHistoryTestModel * HistoryTestModel = (MiHistoryTestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiHistoryTestModel];
    return  HistoryTestModel;
    
}

/**
 *  获取所有历史测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiHistoryTestModel{
    
    NSMutableArray *HistoryTestArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHistoryTestModel sortByKey:nil];
    
    for (int i = 0; i < HistoryTestArr.count; i ++) {
        MiHistoryTestModel * HistoryTest = [HistoryTestArr objectAtIndexWithSafety:i];
        if (HistoryTest.testID==NULL) {
            NSLog(@"%@",HistoryTest.testID);
            [HistoryTestArr removeObject:HistoryTest];
            [self efDeleteMiHistoryTestModel:HistoryTest];
            i--;
        }
    }
    
    for (int i = 0; i < HistoryTestArr.count; i ++) {
        MiHistoryTestModel * HistoryTest = [HistoryTestArr objectAtIndexWithSafety:i];
        for (int k = i; k < HistoryTestArr.count; k++) {
             MiHistoryTestModel * KHistoryTest = [HistoryTestArr objectAtIndexWithSafety:k];
  
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
            
            NSDate *date1 =[dateFormat dateFromString:HistoryTest.testBeginTime];
            
            NSDate *date2 =[dateFormat dateFromString:KHistoryTest.testBeginTime];

            if (date1 < date2) {
                
                [HistoryTestArr replaceObjectAtIndex:i withObject:KHistoryTest];
                [HistoryTestArr replaceObjectAtIndex:k withObject:HistoryTest];
                HistoryTest = KHistoryTest;
            }
            
        }
    }
    return HistoryTestArr;
    
}


/**
 *  添加历史测试到数据库
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel{
    
    BOOL isSuccess = NO;
    
    MiHistoryTestModel *mo = [self efGetMiHistoryTestModelHistoryTestModelId: HistoryTestModel.testID];
    
    if (HistoryTestModel) {

        if (!(HistoryTestModel == mo)) {
  
            [self efDeleteMiHistoryTestModel:mo];
            
            mo = HistoryTestModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
}


/**
 *  根据团队id获取历史测试
 *  @param历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiHistoryTestModelWith:(NSString*)groupId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHistoryTestModel condition:conditionStr sortByKey:@"" limit:100 ascending:YES];
    return teamerArr;
    
}

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiHistoryTestModelWith:(NSString*)searchText{
    
//    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    
    NSString *conditionStr = [NSString stringWithFormat:@"(groupName LIKE '*%@*' or testTittle LIKE '*%@*' or testBeginTime LIKE '*%@*') ",searchText,searchText,searchText];
    
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHistoryTestModel condition:conditionStr sortByKey:@"testBeginTime" limit:100 ascending:YES];
    return teamerArr;
    
}


/**
 *  根据测试ID获取测试信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiHistoryTestModel *)efGetMiHistoryTestModelHistoryTestModelId:(NSString *)HistoryTestModelId{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHistoryTestModel condition:[NSString stringWithFormat:@"testID = '%@'",HistoryTestModelId] sortByKey:nil];
    
    if (userArr.count > 0) {
        MiHistoryTestModel *HistoryTestModel = [userArr objectAtIndexWithSafety:0];
        return HistoryTestModel;
    }
    return [self efCraterMiHistoryTestModel];
}


/**
 *  删除历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:HistoryTestModel];
}

/**
 *  更新历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModelModel{
    
     return  [self efAddMiHistoryTestModel:HistoryTestModelModel];
}

/**
 *  清空所有历史测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiHistoryTestModel{
    
    BOOL flag = YES;
    for (MiHistoryTestModel* user in [self efGetAllMiHistoryTestModel]) {
        if (![self efDeleteMiHistoryTestModel:user]) {
            flag = NO;
        }
    }
    return flag;
}

#pragma mark -个人历史测试信息
//==============================================================================

/*个人历史测试信息*/

//==============================================================================
/**
 *  创建个人历史测试信息
 *
 *  @return UserModel
 */
-(MiUserTestModel*)efCraterMiUserTestModel{
    
    MiUserTestModel * UserTestModel = (MiUserTestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiUserTestModel];
    return  UserTestModel;
    
}

/**
 *  获取所有个人历史测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiUserTestModel{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiUserTestModel sortByKey:nil];
    return userArr;
    
}


/**
 *  添加个人历史测试到数据库
 *
 *  @param UserTestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiUserTestModel:(MiUserTestModel *)UserTestModel{
    
    BOOL isSuccess = NO;
    
    MiUserTestModel *mo = [self efGetMiUserTestModelUserTestModelId:UserTestModel.testID teamerID: UserTestModel.teamerId];
    
    if (UserTestModel) {
        
        if (!(UserTestModel == mo)) {
            
            [self efDeleteMiUserTestModel:mo];
            
            mo = UserTestModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
}


/**
 *  根据团队id获取个人历史测试
 *  @param个人历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserTestModelWith:(NSString*)groupId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"teamerGroupId = '%@'",groupId];
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiUserTestModel condition:conditionStr sortByKey:@"teamerNo" limit:100 ascending:NO];
    
    for (int i = 0; i < teamerArr.count; i ++) {
        MiUserTestModel * UserTestModel = [teamerArr objectAtIndexWithSafety:i];
        
//        NSLog(@"UserTestModel.teamerNo  %@",UserTestModel.teamerNo);
        for (int k = i; k < teamerArr.count; k++) {
             MiUserTestModel * KUserTestModel = [teamerArr objectAtIndexWithSafety:k];
            
            if (UserTestModel.teamerNo.integerValue > KUserTestModel.teamerNo.integerValue) {
                
                [teamerArr replaceObjectAtIndex:i withObject:KUserTestModel];
                [teamerArr replaceObjectAtIndex:k withObject:UserTestModel];
                UserTestModel = KUserTestModel;
            }
   
        }
    }
    
    
    
    
    return teamerArr;
    
}
/**
 *  根据测试id获取个人历史测试
 *  @param个人历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserTestModelWithTestId:(NSString*)TestId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"testID = '%@'",TestId];
    
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiUserTestModel condition:conditionStr sortByKey:@"teamerNo" limit:100 ascending:YES];
    
    for (int i = 0; i < teamerArr.count; i ++) {
        MiUserTestModel * UserTestModel = [teamerArr objectAtIndexWithSafety:i];
        
        
        
        
        for (int k = i; k < teamerArr.count; k++) {
            MiUserTestModel * KUserTestModel = [teamerArr objectAtIndexWithSafety:k];
            
            if (UserTestModel.teamerNo.integerValue > KUserTestModel.teamerNo.integerValue) {
                
                [teamerArr replaceObjectAtIndex:i withObject:KUserTestModel];
                [teamerArr replaceObjectAtIndex:k withObject:UserTestModel];
                UserTestModel = KUserTestModel;
                
//                NSLog(@"UserTestModel.teamerNo.integerValue   %ld",teamerArr.count);
            }
            
        }
    }

    return teamerArr;
    
}

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiUserTestModelWith:(NSString*)searchText{
    
    //    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    
    NSString *conditionStr = [NSString stringWithFormat:@"(groupName LIKE '*%@*' or testTittle LIKE '*%@*' or testBeginTime LIKE '*%@*') ",searchText,searchText,searchText];
    
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiUserTestModel condition:conditionStr sortByKey:@"" limit:100 ascending:YES];
    return teamerArr;
    
}

/**
 *  根据项目ID获取项目信息
 *
 *  @param uId
 *
 *  @return
 */


/**
 *  根据测试ID获取测试信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiUserTestModel *)efGetMiUserTestModelUserTestModelId:(NSString *)TestId teamerID:(NSString *)teamerID{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiUserTestModel condition:[NSString stringWithFormat:@"testID = '%@' AND teamerId = '%@' ",TestId,teamerID] sortByKey:nil];
    
    if (userArr.count > 0) {
        MiUserTestModel *UserTestModel = [userArr objectAtIndexWithSafety:0];
        return UserTestModel;
    }
    return [self efCraterMiUserTestModel];
}


/**
 *  删除个人历史测试信息
 *
 *  @param UserTestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiUserTestModel:(MiUserTestModel *)UserTestModel{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:UserTestModel];
}

/**
 *  更新个人历史测试信息
 *
 *  @param UserTestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiUserTestModel:(MiUserTestModel *)UserTestModelModel{
    
    return  [self efAddMiUserTestModel:UserTestModelModel];
}

/**
 *  清空项目所有个人历史测试
 *
 *  @return
 */
-(BOOL)efDeleteMiUserTestModelByTestID:(NSString *)testID {
    
    BOOL flag = YES;
    for (MiUserTestModel* user in [self efGetSchoolAllMiUserTestModelWithTestId:testID]) {
        if (![self efDeleteMiUserTestModel:user]) {
            flag = NO;
        }
    }
    return flag;
}



/**
 *  清空所有个人历史测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiUserTestModel{
    
    BOOL flag = YES;
    for (MiUserTestModel* user in [self efGetAllMiUserTestModel]) {
        if (![self efDeleteMiUserTestModel:user]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma mark -心跳测试信息
//==============================================================================

/*心跳测试信息*/

//==============================================================================
/**
 *  创建心跳测试信息
 *
 *  @return UserModel
 */
-(MiHeartModel*)efCraterMiHeartModel{
    
    MiHeartModel * HeartModel = (MiHeartModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiHeartModel];
    return  HeartModel;
    
}

/**
 *  获取所有心跳测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiHeartModel{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel sortByKey:nil];
    return userArr;
    
}


/**
 *  添加心跳测试到数据库
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efAddMiHeartModel:(MiHeartModel *)HeartModel{
    
    BOOL isSuccess = NO;
    
    MiHeartModel *mo = [self efGetMiHeartModelHeartModelId: HeartModel.heartId];
    
    if (HeartModel) {
        
        if (!(HeartModel == mo)) {
            
            [self efDeleteMiHeartModel:mo];
            
            mo = HeartModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
}


/**
 *  根据测试id获取心跳测试
 *  @param心跳测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiHeartModelWithTestId:(NSString*)testId withTeamerId:(NSString*)teamerId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"teamerID = '%@' and testID = '%@'",teamerId,testId];
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:conditionStr sortByKey:@"timePoint" limit:100000 ascending:YES];
    
    return teamerArr;
    
}

-(NSMutableDictionary *)efGetSchoolAllMiHeartModelGradeWithTestId:(NSString*)testId withTeamerId:(NSString*)teamerId{
    
    NSString *totalStr = [NSString stringWithFormat:@"testID = '%@'",testId];
    
    NSMutableArray *totalArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *totalStr1 = [NSString stringWithFormat:@"gradeNO = '1' and testID = '%@'",testId];
    NSMutableArray *totalArr1 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr1 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *totalStr2 = [NSString stringWithFormat:@"gradeNO = '2' and testID = '%@'",testId];
    NSMutableArray *totalArr2 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr2 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *totalStr3 = [NSString stringWithFormat:@"gradeNO = '3' and testID = '%@'",testId];
    NSMutableArray *totalArr3 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr3 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *totalStr4 = [NSString stringWithFormat:@"gradeNO = '4' and testID = '%@'",testId];
    NSMutableArray *totalArr4 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr4 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *totalStr5 = [NSString stringWithFormat:@"gradeNO = '5' and testID = '%@'",testId];
    NSMutableArray *totalArr5 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:totalStr5 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    
    
    NSString *perStr = [NSString stringWithFormat:@"teamerID = '%@' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *perStr1 = [NSString stringWithFormat:@"teamerID = '%@' and gradeNO = '1' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr1 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr1 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *perStr2 = [NSString stringWithFormat:@"teamerID = '%@' and gradeNO = '2' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr2 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr2 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *perStr3 = [NSString stringWithFormat:@"teamerID = '%@' and gradeNO = '3' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr3 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr3 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *perStr4 = [NSString stringWithFormat:@"teamerID = '%@' and gradeNO = '4' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr4 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr4 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSString *perStr5 = [NSString stringWithFormat:@"teamerID = '%@' and gradeNO = '5' and testID = '%@'",teamerId,testId];
    NSMutableArray *perArr5 = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:perStr5 sortByKey:@"gradeNO" limit:100000 ascending:YES];
    
    NSMutableDictionary * gradeDict = [[NSMutableDictionary alloc]init];

    [gradeDict setObject:[NSString stringWithFormat:@"%ld",totalArr1.count*10000/totalArr.count] forKey:@"total1"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",totalArr2.count*10000/totalArr.count] forKey:@"total2"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",totalArr3.count*10000/totalArr.count] forKey:@"total3"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",totalArr4.count*10000/totalArr.count] forKey:@"total4"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",totalArr5.count*10000/totalArr.count] forKey:@"total5"];
 
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perArr1.count*10000/perArr.count] forKey:@"per1"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perArr2.count*10000/perArr.count] forKey:@"per2"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perArr3.count*10000/perArr.count] forKey:@"per3"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perArr4.count*10000/perArr.count] forKey:@"per4"];
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perArr5.count*10000/perArr.count] forKey:@"per5"];
    
    NSInteger perMD = perArr5.count+perArr4.count+perArr3.count+perArr2.count/2;
    
    [gradeDict setObject:[NSString stringWithFormat:@"%ld",perMD*100/perArr.count] forKey:@"perMD"];
    
    return gradeDict;
    
}

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiHeartModelWith:(NSString*)searchText{
    
    //    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    
    NSString *conditionStr = [NSString stringWithFormat:@"(groupName LIKE '*%@*' or testTittle LIKE '*%@*' or testBeginTime LIKE '*%@*') ",searchText,searchText,searchText];
    
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:conditionStr sortByKey:@"" limit:100 ascending:YES];
    return teamerArr;
    
}


/**
 *  根据测试ID获取测试信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiHeartModel *)efGetMiHeartModelHeartModelId:(NSString *)HeartModelId{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:[NSString stringWithFormat:@"heartId = '%@'",HeartModelId] sortByKey:nil];
    
    if (userArr.count > 0) {
        MiHeartModel *HeartModel = [userArr objectAtIndexWithSafety:0];
        return HeartModel;
    }
    return [self efCraterMiHeartModel];
}


/**
 *  删除心跳测试信息
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiHeartModel:(MiHeartModel *)HeartModel{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:HeartModel];
}


/**
 *  根据测试id获取个人历史测试
 *  @param个人历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiHeartModelWithTestId:(NSString*)TestId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"testID = '%@'",TestId];
    
    NSMutableArray *HeartArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiHeartModel condition:conditionStr sortByKey:nil limit:1000000 ascending:YES];
    
    return HeartArr;
    
}
/**
 *  清空项目所有心跳历史测试
 *
 *  @return
 */
-(BOOL)efDeleteMiHeartModelByTestID:(NSString *)testID {
    
    BOOL flag = YES;
    for (MiHeartModel* user in [self efGetSchoolAllMiHeartModelWithTestId:testID]) {
        if (![self efDeleteMiHeartModel:user]) {
            flag = NO;
        }
    }
    return flag;
}
/**
 *  更新心跳测试信息
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiHeartModel:(MiHeartModel *)HeartModelModel{
    
    return  [self efAddMiHeartModel:HeartModelModel];
}

/**
 *  清空所有心跳测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiHeartModel{
    
    BOOL flag = YES;
    for (MiHeartModel* user in [self efGetAllMiHeartModel]) {
        if (![self efDeleteMiHeartModel:user]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma mark -进行中测试信息
//==============================================================================

/*进行中测试信息*/

//==============================================================================
/**
 *  创建进行中测试信息
 *
 *  @return UserModel
 */
-(MiTestModel*)efCraterMiTestModel{
    
    [self efDeleteAllMiTestModel];
    
    MiTestModel * TestModel = (MiTestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kMiTestModel];
    return  TestModel;
    
}

/**
 *  获取所有进行中测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiTestModel{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTestModel sortByKey:nil];
    return userArr;
    
}


/**
 *  添加进行中测试到数据库
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiTestModel:(MiTestModel *)TestModel{
    
    BOOL isSuccess = NO;
    
//    NSLog(@"%@",TestModel.testID);
    
    MiTestModel *mo = [self efGetMiTestModelTestModelId: TestModel.testID];
    
    if (TestModel) {
        
        if (!(TestModel == mo)) {
            
            [self efDeleteMiTestModel:mo];
            
            mo = TestModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    
//    NSLog( @ "%@ ",isSuccess?@"成功":@"失败");
    
    return isSuccess;
}


/**
 *  根据团队id获取进行中测试
 *  @param进行中测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiTestModelWith:(NSString*)groupId{
    
    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTestModel condition:conditionStr sortByKey:@"" limit:100 ascending:YES];
    return teamerArr;
    
}

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiTestModelWith:(NSString*)searchText{
    
    //    NSString *conditionStr = [NSString stringWithFormat:@"groupId = '%@'",groupId];
    
    NSString *conditionStr = [NSString stringWithFormat:@"(groupName LIKE '*%@*' or testTittle LIKE '*%@*' or testBeginTime LIKE '*%@*') ",searchText,searchText,searchText];
    
    NSMutableArray *teamerArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTestModel condition:conditionStr sortByKey:@"testBeginTime" limit:100 ascending:YES];
    return teamerArr;
    
}
/**
 *  根据测试ID获取测试信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiTestModel *)efGetMiTestModelTestModelId:(NSString *)TestModelId{
    
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kMiTestModel condition:[NSString stringWithFormat:@"testID LIKE '**' "] sortByKey:nil];
    
    if (userArr.count > 0) {
        MiTestModel *TestModel = [userArr objectAtIndexWithSafety:0];
        return TestModel;
    }
    return [self efCraterMiTestModel];
}

/**
 *  删除进行中测试信息
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiTestModel:(MiTestModel *)TestModel{
    
    return  [[CoreDataManager shareInstance] deleteWithObject:TestModel];
}

/**
 *  更新进行中测试信息
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiTestModel:(MiTestModel *)TestModelModel{
    
    return  [self efAddMiTestModel:TestModelModel];
}

/**
 *  清空所有进行中测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiTestModel{
    
    BOOL flag = YES;
    for (MiTestModel* user in [self efGetAllMiTestModel]) {
        if (![self efDeleteMiTestModel:user]) {
            flag = NO;
        }
    }
    return flag;
}



@end
