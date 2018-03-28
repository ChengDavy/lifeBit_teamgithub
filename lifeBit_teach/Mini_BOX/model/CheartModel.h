//
//  CheartModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface CheartModel : BaseModel

@property (nonatomic, strong)  NSString *teamerID;
@property (nonatomic, strong)  NSString *groupID;
@property (nonatomic, strong)  NSString *testID;
@property (nonatomic, strong)  NSNumber *timePoint;
@property (nonatomic, strong)  NSString *heartNumber;
@property (nonatomic, strong)  NSString *beginTime;
@property (nonatomic, strong)  NSString *heartId;
@property (nonatomic, strong)  NSString *gradeNO;


//数据库对象 测试转化为model

+(CheartModel*)createCheartModelWithMiheartModel:(MiHeartModel *)heartModel;

// 根据测试Model，转换成数据库中对象

+(MiHeartModel*)createMiheartModelWithCheartModel:(CheartModel *)heartModel;


@end
