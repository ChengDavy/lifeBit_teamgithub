//
//  CGroupModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CGroupModel.h"

@implementation CGroupModel

@synthesize createDeful;
@synthesize createTime;
@synthesize groupCreater;
@synthesize groupID;
@synthesize groupName;
@synthesize sportMode;

//数据库对象 团队转化为model

+(CGroupModel*)createCGroupModelWithMiGroupModel:(MiGroupModel *)miGroupModel{
    CGroupModel * groupModel = [[CGroupModel alloc]init];
    
    groupModel.groupID = miGroupModel.groupID;
    groupModel.groupName = miGroupModel.groupName;
    groupModel.groupCreater = miGroupModel.groupCreater;
    groupModel.sportMode = miGroupModel.sportMode;
    groupModel.createTime = miGroupModel.createTime;
    groupModel.createDeful = miGroupModel.createDeful;
   
    
    return  groupModel;
    
    
}

// 根据团队Model，转换成数据库中对象

+(MiGroupModel *)createGroupModelWithCGroupModel:(CGroupModel *)cGroup{
    
    MiGroupModel * groupModel = [[LifeBitCoreDataManager shareInstance]efCraterMiGroupModel];
    
    groupModel.groupID =cGroup.groupID;
    groupModel.groupName = cGroup.groupName;
    groupModel.groupCreater = cGroup.groupCreater;
    groupModel.createDeful = cGroup.createDeful;
    groupModel.createTime = cGroup.createTime;
    groupModel.sportMode = cGroup.sportMode;

    return groupModel;
    
}

@end
