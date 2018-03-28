//
//  CTestModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CTestModel.h"

@implementation CTestModel
@synthesize  avscalorie;
@synthesize  avsHeart;
@synthesize  avsStep;
@synthesize  groupId;
@synthesize  maxHeart;

@synthesize  sportMD;
@synthesize  sportMode;
@synthesize  sportQD;
@synthesize  teacherId;
@synthesize  testBeginTime;

@synthesize  testID;
@synthesize  testMiddleText;
@synthesize  testTimeLong;
@synthesize  testTittle;
@synthesize  isPause;

//数据库对象 测试转化为model

+(CTestModel*)createCTestModelWithMiTestModel:(MiTestModel *)TestModel{
    
    CTestModel * CModel = [[CTestModel alloc]init];
    
    CModel.avscalorie=TestModel.avscalorie;
    CModel.avsHeart=TestModel.avsHeart;
    CModel.avsStep=TestModel.avsStep;
    CModel.groupId=TestModel.groupId;
    CModel.groupName=TestModel.groupName;
    CModel.maxHeart=TestModel.maxHeart;
    
    CModel.sportMD=TestModel.sportMD;
    CModel.sportQD=TestModel.sportQD;
    CModel.teacherId=TestModel.teacherId;
    CModel.sportMode=TestModel.sportMode;
    CModel.testBeginTime=TestModel.testBeginTime;
    
    CModel.testID=TestModel.testID;
    CModel.testTimeLong=TestModel.testTimeLong;
    CModel.testTittle=TestModel.testTittle;
    CModel.testMiddleText=TestModel.testMiddleText;
    CModel.isPause=TestModel.isPause;
    
    return CModel;
}

// 根据测试Model，转换成数据库中对象

+(MiTestModel*)createMiTestModelWithCTestModel:(CTestModel *)TestModel{
    
    MiTestModel * CModel = [[LifeBitCoreDataManager shareInstance] efCraterMiTestModel];
    
    CModel.avscalorie=TestModel.avscalorie;
    CModel.avsHeart=TestModel.avsHeart;
    CModel.avsStep=TestModel.avsStep;
    CModel.groupId=TestModel.groupId;
    CModel.groupName=TestModel.groupName;
    CModel.maxHeart=TestModel.maxHeart;
    
    CModel.sportMD=TestModel.sportMD;
    CModel.sportQD=TestModel.sportQD;
    CModel.teacherId=TestModel.teacherId;
    CModel.sportMode=TestModel.sportMode;
    CModel.testBeginTime=TestModel.testBeginTime;
    
    CModel.testID=TestModel.testID;
    CModel.testTimeLong=TestModel.testTimeLong;
    CModel.testTittle=TestModel.testTittle;
    CModel.testMiddleText=TestModel.testMiddleText;
    CModel.isPause=TestModel.isPause;
    
    return CModel;
}


@end
