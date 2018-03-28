//
//  MiTeamer+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/15.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiTeamer.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiTeamer (CoreDataProperties)

+ (NSFetchRequest<MiTeamer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *teamerAge;
@property (nullable, nonatomic, copy) NSString *teamerGroupId;
@property (nullable, nonatomic, copy) NSString *teamerheight;
@property (nullable, nonatomic, copy) NSString *teamerId;
@property (nullable, nonatomic, copy) NSString *teamerName;
@property (nullable, nonatomic, copy) NSNumber *teamerNo;
@property (nullable, nonatomic, copy) NSString *teamerPic;
@property (nullable, nonatomic, copy) NSString *teamerSex;
@property (nullable, nonatomic, copy) NSString *teamerWeight;

@end

NS_ASSUME_NONNULL_END
