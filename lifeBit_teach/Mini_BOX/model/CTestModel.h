//
//  CTestModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface CTestModel : BaseModel

@property (nonatomic, strong) NSString *avscalorie;
@property (nonatomic, strong) NSString *avsHeart;
@property (nonatomic, strong) NSString *avsStep;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, strong) NSString *maxHeart;
@property (nonatomic, strong) NSString *sportMD;
@property (nonatomic, strong) NSString *sportMode;
@property (nonatomic, strong) NSString *sportQD;
@property (nonatomic, strong) NSString *teacherId;

@property (nonatomic, strong) NSString *testBeginTime;
@property (nonatomic, strong) NSString *testID;
@property (nonatomic, strong) NSString *testMiddleText;
@property (nonatomic, strong) NSString *testTimeLong;
@property (nonatomic, strong) NSString *testTittle;
@property (nonatomic, strong) NSString *isPause;


//数据库对象 测试转化为model

+(CTestModel*)createCTestModelWithMiTestModel:(MiTestModel *)TestModel;

// 根据测试Model，转换成数据库中对象

+(MiTestModel*)createMiTestModelWithCTestModel:(CTestModel *)TestModel;

@end
