//
//  WatchModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/20.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "WatchModel+CoreDataProperties.h"

@implementation WatchModel (CoreDataProperties)

+ (NSFetchRequest<WatchModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WatchModel"];
}

@dynamic ipadIdentifying;
@dynamic teachBoxId;
@dynamic teachBoxName;
@dynamic teachBoxNo;
@dynamic teacherId;
@dynamic watchId;
@dynamic watchMAC;
@dynamic watchNo;

@end
