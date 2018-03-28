//
//  MiGroupModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiGroupModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiGroupModel (CoreDataProperties)

+ (NSFetchRequest<MiGroupModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *createDeful;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSString *groupCreater;
@property (nullable, nonatomic, copy) NSString *groupID;
@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, copy) NSString *sportMode;

@end

NS_ASSUME_NONNULL_END
