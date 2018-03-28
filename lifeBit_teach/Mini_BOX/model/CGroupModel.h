//
//  CGroupModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  strongright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"


@interface CGroupModel : BaseModel

@property (nonatomic, strong) NSNumber *createDeful;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSString *groupCreater;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *sportMode;

//数据库对象 团队转化为model

+(CGroupModel*)createCGroupModelWithMiGroupModel:(MiGroupModel *)MiGroupModel;

// 根据团队Model，转换成数据库中对象

+(MiGroupModel *)createGroupModelWithCGroupModel:(CGroupModel *)cGroup;


//// 根据记录的测试记录，转换成班级
//
//+(HJClassInfo*)createClassInfoWithTestModel:(TestModel *)testModel;
//
//// 课程表转换成班级
//+(HJClassInfo*)createClassInfoWithScheduleModel:(ScheduleModel *)scheduleModel;
//
//// 班级转换成课程表
//+(ScheduleModel*)conversionScheduleModelWithClassInfo:(HJClassInfo *)classInfo;


@end
