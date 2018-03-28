//
//  CHistoryTestModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/11.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface CHistoryTestModel : BaseModel

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

//数据库对象 测试转化为model

+(CHistoryTestModel*)createCHistoryTestModelWithMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel;

// 根据测试Model，转换成数据库中对象

+(MiHistoryTestModel*)createMiHistoryTestModelWithCHistoryTestModel:(CHistoryTestModel *)HistoryTestModel;



@end
