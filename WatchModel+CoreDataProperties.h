//
//  WatchModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/20.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "WatchModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WatchModel (CoreDataProperties)

+ (NSFetchRequest<WatchModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ipadIdentifying;
@property (nullable, nonatomic, copy) NSString *teachBoxId;
@property (nullable, nonatomic, copy) NSString *teachBoxName;
@property (nullable, nonatomic, copy) NSString *teachBoxNo;
@property (nullable, nonatomic, copy) NSString *teacherId;
@property (nullable, nonatomic, copy) NSString *watchId;
@property (nullable, nonatomic, copy) NSString *watchMAC;
@property (nullable, nonatomic, copy) NSNumber *watchNo;

@end

NS_ASSUME_NONNULL_END
