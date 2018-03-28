//
//  CuserTestModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CuserTestModel.h"

@implementation CuserTestModel

@synthesize step;
@synthesize avsHeart;
@synthesize heart;
@synthesize maxHeart;
@synthesize calorie;
@synthesize teamerAge;
@synthesize teamerGroupId;
@synthesize teamerheight;
@synthesize teamerId;
@synthesize teamerName;
@synthesize teamerNo;
@synthesize teamerPic;
@synthesize teamerSex;
@synthesize teamerWeight;
@synthesize sportMD;
@synthesize testID;
@synthesize sportQD;
@synthesize testBeginTime;
@synthesize sportMode;
//数据库对象 测试转化为model

+(CuserTestModel*)createCUserTestModelWithMiUserTestModel:(MiUserTestModel *)UserTestModel{
    CuserTestModel * TestModel = [[CuserTestModel alloc]init];
    
    TestModel.step = UserTestModel.step;
    TestModel.avsHeart = UserTestModel.avsHeart;
    TestModel.heart = UserTestModel.heart;
    TestModel.maxHeart = UserTestModel.maxHeart;
    TestModel.calorie = UserTestModel.calorie;
    TestModel.teamerAge = UserTestModel.teamerAge;
    
    TestModel.teamerGroupId = UserTestModel.teamerGroupId;
    TestModel.teamerheight = UserTestModel.teamerheight;
    TestModel.teamerId = UserTestModel.teamerId;
    TestModel.teamerName = UserTestModel.teamerName;
    TestModel.teamerNo = UserTestModel.teamerNo;
    
    TestModel.teamerPic = UserTestModel.teamerPic;
    TestModel.teamerSex = UserTestModel.teamerSex;
    TestModel.teamerWeight = UserTestModel.teamerWeight;
    TestModel.sportQD = UserTestModel.sportQD;
    TestModel.sportMD = UserTestModel.sportMD;
    TestModel.testBeginTime = UserTestModel.testBeginTime;
    
     TestModel.sportMode = UserTestModel.sportMode;
    
    TestModel.testID = UserTestModel.testID;
    
    return TestModel;
    
    
}

// 根据测试Model，转换成数据库中对象

+(MiUserTestModel*)createMiUserTestModelWithCUserTestModel:(CuserTestModel *)UserTestModel{
    MiUserTestModel * TestModel = [[LifeBitCoreDataManager shareInstance]efCraterMiUserTestModel];
    
    TestModel.step = UserTestModel.step;
    TestModel.avsHeart = UserTestModel.avsHeart;
    TestModel.heart = UserTestModel.heart;
    TestModel.maxHeart = UserTestModel.maxHeart;
    TestModel.calorie = UserTestModel.calorie;
    TestModel.teamerAge = UserTestModel.teamerAge;
    
    TestModel.teamerGroupId = UserTestModel.teamerGroupId;
    TestModel.teamerheight = UserTestModel.teamerheight;
    TestModel.teamerId = UserTestModel.teamerId;
    TestModel.teamerName = UserTestModel.teamerName;
    TestModel.teamerNo = UserTestModel.teamerNo;
    
    TestModel.teamerPic = UserTestModel.teamerPic;
    TestModel.teamerSex = UserTestModel.teamerSex;
    TestModel.teamerWeight = UserTestModel.teamerWeight;
    TestModel.sportQD = UserTestModel.sportQD;
    TestModel.sportMD = UserTestModel.sportMD;
    TestModel.testBeginTime = UserTestModel.testBeginTime;
    TestModel.sportMode = UserTestModel.sportMode;
    
    TestModel.testID = UserTestModel.testID;
    
    return TestModel;
}


@end
