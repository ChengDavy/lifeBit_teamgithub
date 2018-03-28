//
//  MiUserTestModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiUserTestModel+CoreDataProperties.h"

@implementation MiUserTestModel (CoreDataProperties)

+ (NSFetchRequest<MiUserTestModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiUserTestModel"];
}

@dynamic step;
@dynamic avsHeart;
@dynamic heart;
@dynamic maxHeart;
@dynamic calorie;
@dynamic teamerAge;
@dynamic teamerGroupId;
@dynamic teamerheight;
@dynamic teamerId;
@dynamic teamerName;
@dynamic teamerNo;
@dynamic teamerPic;
@dynamic teamerSex;
@dynamic teamerWeight;
@dynamic sportMD;
@dynamic testID;
@dynamic sportQD;
@dynamic testBeginTime;
@dynamic sportMode;

@end
