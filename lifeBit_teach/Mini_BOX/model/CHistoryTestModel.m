//
//  CHistoryTestModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/11.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CHistoryTestModel.h"

@implementation CHistoryTestModel

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

//数据库对象 测试转化为model

+(CHistoryTestModel*)createCHistoryTestModelWithMiHistoryTestModel:(MiHistoryTestModel *)HistoryTestModel{
    
    CHistoryTestModel * ChistoryModel = [[CHistoryTestModel alloc]init];
    
    ChistoryModel.avscalorie=HistoryTestModel.avscalorie;
    ChistoryModel.avsHeart=HistoryTestModel.avsHeart;
    ChistoryModel.avsStep=HistoryTestModel.avsStep;
    ChistoryModel.groupId=HistoryTestModel.groupId;
    ChistoryModel.groupName=HistoryTestModel.groupName;
    ChistoryModel.maxHeart=HistoryTestModel.maxHeart;
    
    ChistoryModel.sportMD=HistoryTestModel.sportMD;
    ChistoryModel.sportQD=HistoryTestModel.sportQD;
    ChistoryModel.teacherId=HistoryTestModel.teacherId;
    ChistoryModel.sportMode=HistoryTestModel.sportMode;
    ChistoryModel.testBeginTime=HistoryTestModel.testBeginTime;
    
    ChistoryModel.testID=HistoryTestModel.testID;
    ChistoryModel.testTimeLong=HistoryTestModel.testTimeLong;
    ChistoryModel.testTittle=HistoryTestModel.testTittle;
    ChistoryModel.testMiddleText=HistoryTestModel.testMiddleText;

    return ChistoryModel;
}

// 根据测试Model，转换成数据库中对象

+(MiHistoryTestModel*)createMiHistoryTestModelWithCHistoryTestModel:(CHistoryTestModel *)HistoryTestModel{
    
    MiHistoryTestModel * ChistoryModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHistoryTestModel];
    
    ChistoryModel.avscalorie=HistoryTestModel.avscalorie;
    ChistoryModel.avsHeart=HistoryTestModel.avsHeart;
    ChistoryModel.avsStep=HistoryTestModel.avsStep;
    ChistoryModel.groupId=HistoryTestModel.groupId;
    ChistoryModel.groupName=HistoryTestModel.groupName;
    ChistoryModel.maxHeart=HistoryTestModel.maxHeart;
    
    ChistoryModel.sportMD=HistoryTestModel.sportMD;
    ChistoryModel.sportQD=HistoryTestModel.sportQD;
    ChistoryModel.teacherId=HistoryTestModel.teacherId;
    ChistoryModel.sportMode=HistoryTestModel.sportMode;
    ChistoryModel.testBeginTime=HistoryTestModel.testBeginTime;
    
    ChistoryModel.testID=HistoryTestModel.testID;
    ChistoryModel.testTimeLong=HistoryTestModel.testTimeLong;
    ChistoryModel.testTittle=HistoryTestModel.testTittle;
    ChistoryModel.testMiddleText=HistoryTestModel.testMiddleText;
    
    return ChistoryModel;
}


@end
