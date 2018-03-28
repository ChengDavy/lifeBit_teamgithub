//
//  MiHeartModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/20.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiHeartModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiHeartModel (CoreDataProperties)

+ (NSFetchRequest<MiHeartModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *beginTime;
@property (nullable, nonatomic, copy) NSString *gradeNO;
@property (nullable, nonatomic, copy) NSString *groupID;
@property (nullable, nonatomic, copy) NSString *heartId;
@property (nullable, nonatomic, copy) NSString *heartNumber;
@property (nullable, nonatomic, copy) NSString *teamerID;
@property (nullable, nonatomic, copy) NSString *testID;
@property (nullable, nonatomic, copy) NSNumber *timePoint;

@end

NS_ASSUME_NONNULL_END
