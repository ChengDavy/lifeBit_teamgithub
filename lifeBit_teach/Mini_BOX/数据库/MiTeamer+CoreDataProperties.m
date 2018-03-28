//
//  MiTeamer+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/15.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiTeamer+CoreDataProperties.h"

@implementation MiTeamer (CoreDataProperties)

+ (NSFetchRequest<MiTeamer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiTeamer"];
}

@dynamic teamerAge;
@dynamic teamerGroupId;
@dynamic teamerheight;
@dynamic teamerId;
@dynamic teamerName;
@dynamic teamerNo;
@dynamic teamerPic;
@dynamic teamerSex;
@dynamic teamerWeight;

@end
