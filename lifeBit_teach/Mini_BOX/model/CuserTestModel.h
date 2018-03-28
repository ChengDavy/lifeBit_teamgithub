//
//  CuserTestModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface CuserTestModel : BaseModel

@property (nonatomic, strong) NSString *step;
@property (nonatomic, strong) NSString *avsHeart;
@property (nonatomic, strong) NSString *heart;
@property (nonatomic, strong) NSString *maxHeart;
@property (nonatomic, strong) NSString *calorie;
@property (nonatomic, strong) NSString *teamerAge;
@property (nonatomic, strong) NSString *teamerGroupId;
@property (nonatomic, strong) NSString *teamerheight;
@property (nonatomic, strong) NSString *teamerId;
@property (nonatomic, strong) NSString *teamerName;
@property (nonatomic, strong) NSString *teamerNo;
@property (nonatomic, strong) NSString *teamerPic;
@property (nonatomic, strong) NSString *teamerSex;
@property (nonatomic, strong) NSString *teamerWeight;
@property (nonatomic, strong) NSString *sportMD;
@property (nonatomic, strong) NSString *testID;
@property (nonatomic, strong) NSString *sportQD;
@property (nonatomic, strong) NSString *testBeginTime;
@property (nonatomic, strong) NSString *sportMode;


//数据库对象 测试转化为model

+(CuserTestModel*)createCUserTestModelWithMiUserTestModel:(MiUserTestModel *)UserTestModel;

// 根据测试Model，转换成数据库中对象

+(MiUserTestModel*)createMiUserTestModelWithCUserTestModel:(CuserTestModel *)UserTestModel;



@end
