//
//  GroupModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/31.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "GroupModel+CoreDataProperties.h"

@implementation GroupModel (CoreDataProperties)

+ (NSFetchRequest<GroupModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GroupModel"];
}

@dynamic groupID;
@dynamic groupName;
@dynamic sportMode;
@dynamic groupCreater;
@dynamic createTime;
@dynamic createDeful;

@end
