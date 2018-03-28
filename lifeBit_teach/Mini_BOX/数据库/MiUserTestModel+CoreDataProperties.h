//
//  MiUserTestModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/13.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiUserTestModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiUserTestModel (CoreDataProperties)

+ (NSFetchRequest<MiUserTestModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *step;
@property (nullable, nonatomic, copy) NSString *avsHeart;
@property (nullable, nonatomic, copy) NSString *heart;
@property (nullable, nonatomic, copy) NSString *maxHeart;
@property (nullable, nonatomic, copy) NSString *calorie;
@property (nullable, nonatomic, copy) NSString *teamerAge;
@property (nullable, nonatomic, copy) NSString *teamerGroupId;
@property (nullable, nonatomic, copy) NSString *teamerheight;
@property (nullable, nonatomic, copy) NSString *teamerId;
@property (nullable, nonatomic, copy) NSString *teamerName;
@property (nullable, nonatomic, copy) NSString *teamerNo;
@property (nullable, nonatomic, copy) NSString *teamerPic;
@property (nullable, nonatomic, copy) NSString *teamerSex;
@property (nullable, nonatomic, copy) NSString *teamerWeight;
@property (nullable, nonatomic, copy) NSString *sportMD;
@property (nullable, nonatomic, copy) NSString *testID;
@property (nullable, nonatomic, copy) NSString *sportQD;
@property (nullable, nonatomic, copy) NSString *testBeginTime;
@property (nullable, nonatomic, copy) NSString *sportMode;

@end

NS_ASSUME_NONNULL_END
