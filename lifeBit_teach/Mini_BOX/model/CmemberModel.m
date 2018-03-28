//
//  CmemberModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CmemberModel.h"

@implementation CmemberModel

@synthesize teamerAge;
@synthesize teamerheight;
@synthesize teamerSex;
@synthesize teamerId;
@synthesize teamerName;
@synthesize teamerNo;
@synthesize teamerGroupId;
@synthesize teamerPic;

//数据库对象 团队成员转化为model

+(CmemberModel*)createCmemberModelWithMiTeamer:(MiTeamer *)miTeamer{
    CmemberModel * member = [[CmemberModel alloc]init];
    
    member.teamerId = miTeamer.teamerId;
    member.teamerheight = miTeamer.teamerheight;
    member.teamerSex = miTeamer.teamerSex;
    member.teamerNo = [miTeamer.teamerNo integerValue];
    member.teamerName = miTeamer.teamerName;
    member.teamerGroupId = miTeamer.teamerGroupId;
    member.teamerPic = miTeamer.teamerPic;
    member.teamerAge = miTeamer.teamerAge;
    member.teamerWeight = miTeamer.teamerWeight;

    return member;
    
}

// 根据团队成员Model，转换成数据库中对象

+(MiTeamer *)createMiTeamerWithCmemberModel:(CmemberModel *)memberModel{
    
    MiTeamer * teamber = [[LifeBitCoreDataManager shareInstance]efCraterMiTeamer];
    
    teamber.teamerId = memberModel.teamerId;
    teamber.teamerheight = memberModel.teamerheight;
    teamber.teamerSex = memberModel.teamerSex;
    teamber.teamerNo = [NSNumber numberWithInteger: memberModel.teamerNo ];
    teamber.teamerName = memberModel.teamerName;
    teamber.teamerGroupId = memberModel.teamerGroupId;
    teamber.teamerPic = memberModel.teamerPic;
    teamber.teamerAge = memberModel.teamerAge;
    teamber.teamerWeight = memberModel.teamerWeight;
    
    return teamber;
    
}

@end
