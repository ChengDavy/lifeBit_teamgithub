//
//  MiGroupModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/7.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiGroupModel+CoreDataProperties.h"

@implementation MiGroupModel (CoreDataProperties)

+ (NSFetchRequest<MiGroupModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiGroupModel"];
}

@dynamic createDeful;
@dynamic createTime;
@dynamic groupCreater;
@dynamic groupID;
@dynamic groupName;
@dynamic sportMode;

@end
