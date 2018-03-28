//
//  MiHistoryTestModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/11.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiHistoryTestModel+CoreDataProperties.h"

@implementation MiHistoryTestModel (CoreDataProperties)

+ (NSFetchRequest<MiHistoryTestModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiHistoryTestModel"];
}

@dynamic avscalorie;
@dynamic avsHeart;
@dynamic avsStep;
@dynamic groupId;
@dynamic groupName;
@dynamic maxHeart;
@dynamic sportMD;
@dynamic sportMode;
@dynamic sportQD;
@dynamic teacherId;
@dynamic testBeginTime;
@dynamic testID;
@dynamic testMiddleText;
@dynamic testTimeLong;
@dynamic testTittle;

@end
