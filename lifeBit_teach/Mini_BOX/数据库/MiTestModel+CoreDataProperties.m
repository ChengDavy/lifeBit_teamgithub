//
//  MiTestModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiTestModel+CoreDataProperties.h"

@implementation MiTestModel (CoreDataProperties)

+ (NSFetchRequest<MiTestModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiTestModel"];
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
@dynamic isPause;

@end
