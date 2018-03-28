//
//  MiHeartModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/20.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiHeartModel+CoreDataProperties.h"

@implementation MiHeartModel (CoreDataProperties)

+ (NSFetchRequest<MiHeartModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiHeartModel"];
}

@dynamic beginTime;
@dynamic gradeNO;
@dynamic groupID;
@dynamic heartId;
@dynamic heartNumber;
@dynamic teamerID;
@dynamic testID;
@dynamic timePoint;

@end
