//
//  MiUserDataModel+CoreDataProperties.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/6.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiUserDataModel+CoreDataProperties.h"

@implementation MiUserDataModel (CoreDataProperties)

+ (NSFetchRequest<MiUserDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MiUserDataModel"];
}

@dynamic pAccount;
@dynamic pId;
@dynamic pUserName;
@dynamic pPic;
@dynamic pMoble;
@dynamic pEmail;
@dynamic pPass;

@end
