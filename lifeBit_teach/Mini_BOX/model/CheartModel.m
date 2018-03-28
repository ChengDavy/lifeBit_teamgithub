//
//  CheartModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CheartModel.h"

@implementation CheartModel

@synthesize teamerID;
@synthesize groupID;
@synthesize testID;
@synthesize timePoint;
@synthesize heartNumber;
@synthesize beginTime;
@synthesize heartId;
@synthesize gradeNO;

//数据库对象 测试转化为model

+(CheartModel*)createCheartModelWithMiheartModel:(MiHeartModel *)heartModel{
    CheartModel * pheartModel = [[CheartModel alloc]init];
    
    pheartModel.testID = heartModel.testID;
    pheartModel.groupID = heartModel.groupID;
    pheartModel.teamerID = heartModel.teamerID;
    
    pheartModel.timePoint = heartModel.timePoint;
    pheartModel.heartNumber = heartModel.heartNumber;
    pheartModel.beginTime = heartModel.beginTime;
    pheartModel.heartId = heartModel.heartId;
    pheartModel.gradeNO = heartModel.gradeNO;
    
    return pheartModel;
    
}

// 根据测试Model，转换成数据库中对象

+(MiHeartModel*)createMiheartModelWithCheartModel:(CheartModel *)heartModel{
    
    MiHeartModel * pheartModel = [[LifeBitCoreDataManager shareInstance] efCraterMiHeartModel] ;
    pheartModel.testID = heartModel.testID;
    pheartModel.groupID = heartModel.groupID;
    pheartModel.teamerID = heartModel.teamerID;
    pheartModel.timePoint = heartModel.timePoint;
    pheartModel.heartNumber = heartModel.heartNumber;
    pheartModel.beginTime = heartModel.beginTime;
    pheartModel.heartId = heartModel.heartId;
    pheartModel.gradeNO = heartModel.gradeNO;
    
    return pheartModel;
}


@end
