//
//  GroupModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/31.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "GroupModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupModel (CoreDataProperties)

+ (NSFetchRequest<GroupModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *groupID;
@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, copy) NSString *sportMode;
@property (nullable, nonatomic, copy) NSString *groupCreater;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSNumber *createDeful;

@end

NS_ASSUME_NONNULL_END
