//
//  CmemberModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface CmemberModel : BaseModel

@property (nonatomic, strong) NSString *teamerAge;
@property (nonatomic, strong) NSString *teamerheight;
@property (nonatomic, strong) NSString *teamerSex;
@property (nonatomic, strong) NSString *teamerId;
@property (nonatomic, strong) NSString *teamerName;
@property (nonatomic, assign) NSInteger teamerNo;
@property (nonatomic, strong) NSString *teamerGroupId;
@property (nonatomic, strong) NSString * teamerPic;
@property (nonatomic, strong) NSString *teamerWeight;


//数据库对象 团队成员转化为model

+(CmemberModel*)createCmemberModelWithMiTeamer:(MiTeamer *)miTeamer;

// 根据团队成员Model，转换成数据库中对象

+(MiTeamer *)createMiTeamerWithCmemberModel:(CmemberModel *)memberModel;


@end
