//
//  LifeBitCoreDataManager.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#define  kStudentModel    @"StudentModel" //学生表
#define  kLessonPlanIdUnitModel    @"LessonPlanIdUnitModel" //教案单元
#define  kLessonPlanModel    @"LessonPlanModel" //教案
#define  kScheduleModel    @"ScheduleModel" //课程表
#define  kScoreModel    @"ScoreModel" //成绩表
#define  kWatchModel    @"WatchModel" //手表
#define KBluetoothDataModel @"BluetoothDataModel" // 数据
#define KHaveClassModel @"HaveClassModel" // 已上课程
#define KTestModel @"TestModel" // 已上课程
#define KHistoryTestModel @"HistoryTestModel" // 课程历史记录
#define KNotStudentModel @"NotStudentModel" // 未点名学生
#define KUserModel @"UserModel"
#define KVersionModel @"VersionModel"


#pragma mark - 新建数据库

#define KMiuserDataModel @"MiUserDataModel"  //教研员个人信息

#define kMiGroupModel @"MiGroupModel"        //团队信息

#define kMiTeamer @"MiTeamer"        //成员信息

#define kMiHistoryTestModel @"MiHistoryTestModel"  //测试项目历史信息

#define kMiTestModel @"MiTestModel"  //测试项目信息

#define kMiUserTestModel @"MiUserTestModel"  //个人测试项目历史信息

#define kMiHeartModel @"MiHeartModel"  //个人测试心跳历史信息

#define kMiDemoModelID @"MiDemoModelID"  //测试demoID


#define kMiBeginAction @"kMiBeginAction"  //开始测试

//#define kMiTestModelID @"MiTestModelID"  //测试中ID





@interface LifeBitCoreDataManager : NSObject
+(instancetype)shareInstance;

#pragma mark - 版本信息

//==============================================================================

/* 版本信息*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return VersionModel
 */
-(VersionModel*)efCraterVersionModel;
/**
 *  获取所有版本信息
 *
 *  @return VersionModel
 */
-(NSMutableArray*)efGetAllVersionModel;

/**
 *  添加版本信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddVersionModel:(VersionModel *)user;

/**
 *  根据老师id获取版本信息
 *
 *  @param 老师id
 *
 *  @return
 */
-(VersionModel*)efGetVersionModelWithTeacherId:(NSString*)teacherId;


/**
 *  删除指定老师的版本
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteVersionModel:(VersionModel *)versionModel;

/**
 *  更新老师版本信息
 *
 *  @param VersionModel
 *
 *  @return
 */
-(BOOL)efUpdateVersionModel:(VersionModel *)versionModel;

/**
 *  清空所有版本信息
 *
 *  @return
 */
-(BOOL)efDeleteAllVersionModel;



#pragma mark - 用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(UserModel*)efCraterUserModel;
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllUserModel;

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddUserModel:(UserModel *)user;

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllUserModelWith:(NSString*)schoolId;

/**
 *  根据老师账号和密码获取用户信息
 *
 *  @param uId
 *
 *  @return
 */
-(UserModel *)efGetUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password;

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteUserModel:(UserModel *)user;

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateUserModel:(UserModel *)user;

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllUserModel;


#pragma --mark-- 手表管理
//==============================================================================

/*手表管理*/

//==============================================================================
/**
 *  创建手环
 *
 *  @return WatchModel
 */
-(WatchModel*)efCraterWatchModel;
/**
 *  获取所有手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetAllWatchModel;


/**
 *  获取老师的手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetTearchAllWatchModel:(NSString*)tearchId;

/**
 *  删除老师的手环
 *
 *  @return [WatchModel]
 */
-(BOOL)efDeleteTearchAllWatchModel:(NSString*)tearchId;

/**
 *  添加手环到数据库
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efAddWatchModel:(WatchModel *)watch;
/**
 *  根据手表Id获取手表详情
 *
 *  @param watchId
 *
 *  @return
 */
-(WatchModel *)efGetWatchDetailedById:(NSString*)watchId;

/**
 *  ID 查找手环
 *
 *  @param watchId
 *
 *  @return
 */

-(WatchModel*)efGetWatchModelBYwatchNo:(NSString*)watchNo;

/**
 *  根据手表Id判断mac地址是否在教具箱中存在
 *
 *  @param 手表mac地址
 *
 *  @return
 */
-(BOOL)efGetBoxIsWatch:(NSString*)mac;

/**
 *  根据ipad标识获取手环列表
 *  @param ipad标识
 *  @return
 */
-(NSMutableArray *)efGetIpadIdentifyingAllWatchWith:(NSString*)ipadIdentifying;



/**
 *  删除手表信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteWatchModel:(WatchModel *)watch;



/**
 *  清空所有手表信息
 *
 *  @return
 */
-(BOOL)efDeleteAllWatchModel;



#pragma --mark-- 同步数据管理
//==============================================================================

/*同步数据管理*/

//==============================================================================
/**
 *  创建数据
 *
 *  @return BluetoothDataModel
 */
-(BluetoothDataModel*)efCraterBluetoothDataModel;
/**
 *  获取数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetAllBluetoothDataModel;

/**
 *  获取指定老师所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetTearcherAllBluetoothDataModel;

/**
 *  添加教案到数据库
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efAddBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel;
/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param timeDate 指定时间
 *  @param DataType 指定的数据类型
 *  @param macStr 手表mac地址
 *  @return
 */
-(BluetoothDataModel *)efGetBluetoothDataModelWithDate:(NSDate*)timeDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr;


/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @param macStr 手表mac地址
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr;


/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType;
/**
 *  删除指定的同步数据
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel;
/**
 *  清空所有同步数据
 *
 *  @return
 */
-(BOOL)efDeleteAllBluetoothDataModel;



#pragma --mark-- 已经上课课程
//==============================================================================

/*已经上课课程*/

//==============================================================================
/**
 *  创建已上课程
 *
 *  @return HaveClassModel
 */
-(HaveClassModel*)efCraterHaveClassModel;
/**
 *  获取所有所有已经上课课程
 *
 *  @return [HaveClassModel]
 */
-(NSMutableArray*)efGetAllHaveClassModel;

/**
 *  添加课程到已上课程列表中
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efAddHaveClassModel:(HaveClassModel *)classModel;
/**
 *  根据课程ID获取详情
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HaveClassModel *)efGetHaveClassModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate;


/**
 *  根据课程来源和上课状态获取课程
 *
 *  @param sourceType    来源类型 课程来源类型（1 课程表 ,2 自定义）
 *  @param scheduleStatus  课程状态
 *  @return
 */
-(NSMutableArray *)efGetHaveClassModelWithSourceType:(NSNumber*)sourceType andScheduleStatus:(NSString*)scheduleStatus;



/**
 *  删除课程表信息
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHaveClassModel:(HaveClassModel *)haveClassModel;



/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllHaveClassModel;

#pragma --mark-- 保存的测试班级信息
//==============================================================================

/*成绩未上传成功上课班级列表*/

//==============================================================================
/**
 *  创建未上传记录对象
 *
 *  @return TestModel
 */
-(TestModel*)efCraterTestModel;
/**
 *  获取所有未上传成绩的几率
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllTestModel;

/**
 *  添加未上传的记录到数据库中
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddTestModel:(TestModel *)testModel;
/**
 *  查看详情
 *
 *  @param TestModel
 *
 *  @return
 */
-(TestModel *)efGetTestModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate;
/**
 *  删除测试记录
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteTestModel:(TestModel *)testModel;


/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllTestModel;


#pragma --mark-- 保存的测试历史数据
//==============================================================================

/*保存的测试历史数据*/

//==============================================================================
/**
 *  创建所有测试历史数据
 *
 *  @return TestModel
 */
-(HistoryTestModel*)efCraterHistoryTestModel;
/**
 *  获取所有测试历史
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllHistoryTestModel;

/**
 *  添加测试历史数据
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddHistoryTestModel:(HistoryTestModel *)historyTestModel;

/**
 *  删除测试历史数据
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHistoryTestModel:(HistoryTestModel *)historyTestModel;


/**
 *  清空所有已测试历史数据
 *
 *  @return
 */
-(BOOL)efDeleteAllHistoryTestModel;



#pragma mark - 新用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(MiUserDataModel*)efCraterMiUserModel;
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiUserModel;

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddMiUserModel:(MiUserDataModel *)user;

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserModelWith:(NSString*)schoolId;

/**
 *  根据老师账号和密码获取用户信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiUserDataModel *)efGetMiUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password;

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteMiUserModel:(MiUserDataModel *)user;

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateMiUserModel:(MiUserDataModel *)user;

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllMiUserModel;



#pragma mark - 团队信息
//==============================================================================

/*团队信息*/

//==============================================================================
/**
 *  创建团队信息
 *
 *  @return UserModel
 */
-(MiGroupModel*)efCraterMiGroupModel;
/**
 *  获取所有团队
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiGroupModel;



-(NSMutableArray*)efGetAllMemberWithMiGroupModelArry:(NSArray *)GroupArry;

/**
 *  添加团队到数据库
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efAddMiGroupModel:(MiGroupModel *)Group;

/**
 *  根据团队id获取团队成员
 *  @param 团队ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiGroupModelWith:(NSString*)GroupId;

/**
 *  根据团队ID获取团队信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiGroupModel *)efGetMiGroupModelGroupId:(NSString *)GroupId;

/**
 *  删除团队信息
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efDeleteMiGroupModel:(MiGroupModel *)GroupModel;

/**
 *  更新团队信息
 *
 *  @param GroupModel
 *
 *  @return
 */
-(BOOL)efUpdateMiGroupModel:(MiGroupModel*)GroupModel;

/**
 *  清空所有群组
 *
 *  @return
 */
-(BOOL)efDeleteAllMiGroupModel;



#pragma mark -成员信息
//==============================================================================

/*成员信息*/

//==============================================================================
/**
 *  创建成员信息
 *
 *  @return UserModel
 */
-(MiTeamer*)efCraterMiTeamer;
/**
 *  获取所有成员
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiTeamer;

/**
 *  添加成员到数据库
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efAddMiTeamer:(MiTeamer *)teamerModel;

/**
 *  根据团队id获取成员
 *  @param成员ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiTeamerWith:(NSString*)teamerId;

/**
 *  根据团队ID获取团队信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiTeamer *)efGetMiTeamerteamerId:(NSString *)teamerId;

/**
 *  删除成员信息
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efDeleteMiTeamer:(MiTeamer *)teamerModel;

/**
 *  更新成员信息
 *
 *  @param teamerModel
 *
 *  @return
 */
-(BOOL)efUpdateMiTeamer:(MiTeamer *)teamerModel;

/**
 *  清空所有成员
 *
 *  @return
 */
-(BOOL)efDeleteAllMiTeamer;



#pragma mark -历史测试信息
//==============================================================================

/*历史测试信息*/

//==============================================================================
/**
 *  创建历史测试信息
 *
 *  @return UserModel
 */
-(MiHistoryTestModel*)efCraterMiHistoryTestModel;
/**
 *  获取所有历史测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiHistoryTestModel;

/**
 *  添加历史测试到数据库
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel;

/**
 *  根据团队id获取历史测试
 *  @param历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiHistoryTestModelWith:(NSString*)groupId;


/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiHistoryTestModelWith:(NSString*)searchText;

/**
 *  根据团队ID获取团队信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiHistoryTestModel *)efGetMiHistoryTestModelHistoryTestModelId:(NSString *)HistoryTestModelId;

/**
 *  删除历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel;

/**
 *  更新历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel;

/**
 *  清空所有历史测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiHistoryTestModel;


#pragma mark -个人历史测试信息
//==============================================================================

/*个人历史测试信息*/

//==============================================================================
/**
 *  创建个人历史测试信息
 *
 *  @return UserModel
 */
-(MiUserTestModel*)efCraterMiUserTestModel;
/**
 *  获取所有个人历史测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiUserTestModel;

/**
 *  添加个人历史测试到数据库
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiUserTestModel:(MiUserTestModel *)HistoryTestModel;

/**
 *  根据项目id获取个人历史测试
 *  @param个人历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserTestModelWith:(NSString*)groupId;

/**
 *  根据测试id获取个人历史测试
 *  @param个人历史测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiUserTestModelWithTestId:(NSString*)TestId;

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiUserTestModelWith:(NSString*)searchText;

/**
 *  根据项目ID获取项目信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiUserTestModel *)efGetMiUserTestModelUserTestModelId:(NSString *)TestId teamerID:(NSString *)teamerID;

/**
 *  删除个人历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiUserTestModel:(MiUserTestModel *)HistoryTestModel;

/**
 *  更新个人历史测试信息
 *
 *  @param HistoryTestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiUserTestModel:(MiUserTestModel *)HistoryTestModel;


/**
 *  清空项目所有个人历史测试
 *
 *  @return
 */
-(BOOL)efDeleteMiUserTestModelByTestID:(NSString *)testID;

/**
 *  清空所有个人历史测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiUserTestModel;

#pragma mark -心跳测试信息
//==============================================================================

/*心跳测试信息*/

//==============================================================================
/**
 *  创建心跳测试信息
 *
 *  @return UserModel
 */
-(MiHeartModel*)efCraterMiHeartModel;
/**
 *  获取所有心跳测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiHeartModel;

/**
 *  添加心跳测试到数据库
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efAddMiHeartModel:(MiHeartModel *)HeartModel;

/**
 *  根据测试id获取心跳测试
 *  @param心跳测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiHeartModelWithTestId:(NSString*)testId withTeamerId:(NSString*)teamerId;

/**
 *  根据测试id获取心跳测试 等级比例;
 *  @param心跳测试ID
 *  @return
 */

-(NSMutableDictionary *)efGetSchoolAllMiHeartModelGradeWithTestId:(NSString*)testId withTeamerId:(NSString*)teamerId;

/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiHeartModelWith:(NSString*)searchText;

/**
 *  根据测试ID获取测试信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiHeartModel *)efGetMiHeartModelHeartModelId:(NSString *)HeartModelId;

/**
 *  清空项目所有心跳历史测试
 *
 *  @return
 */
-(BOOL)efDeleteMiHeartModelByTestID:(NSString *)testID;/**
 *  删除心跳测试信息
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiHeartModel:(MiHeartModel *)HeartModel;

/**
 *  更新心跳测试信息
 *
 *  @param HeartModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiHeartModel:(MiHeartModel *)HeartModel;

/**
 *  清空所有心跳测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiHeartModel;

#pragma mark -进行中测试信息
//==============================================================================

/*进行中测试信息*/

//==============================================================================
/**
 *  创建进行中测试信息
 *
 *  @return UserModel
 */
-(MiTestModel*)efCraterMiTestModel;
/**
 *  获取所有进行中测试
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllMiTestModel;

/**
 *  添加进行中测试到数据库
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efAddMiTestModel:(MiTestModel *)TestModel;

/**
 *  根据团队id获取进行中测试
 *  @param进行中测试ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllMiTestModelWith:(NSString*)groupId;


/**
 *  模糊查询
 *  @param 模糊查询字段
 *  @return
 */
-(NSMutableArray *)efSearchSchoolAllMiTestModelWith:(NSString*)searchText;

/**
 *  根据团队ID获取团队信息
 *
 *  @param uId
 *
 *  @return
 */
-(MiTestModel *)efGetMiTestModelTestModelId:(NSString *)TestModelId;

/**
 *  删除进行中测试信息
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efDeleteMiTestModel:(MiTestModel *)TestModel;

/**
 *  更新进行中测试信息
 *
 *  @param TestModelModel
 *
 *  @return
 */
-(BOOL)efUpdateMiTestModel:(MiTestModel *)TestModel;

/**
 *  清空所有进行中测试
 *
 *  @return
 */
-(BOOL)efDeleteAllMiTestModel;

@end
