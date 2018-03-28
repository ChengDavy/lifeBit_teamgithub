//
//  MiTestModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiTestModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiTestModel (CoreDataProperties)

+ (NSFetchRequest<MiTestModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avscalorie;
@property (nullable, nonatomic, copy) NSString *avsHeart;
@property (nullable, nonatomic, copy) NSString *avsStep;
@property (nullable, nonatomic, copy) NSString *groupId;
@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, copy) NSString *maxHeart;
@property (nullable, nonatomic, copy) NSString *sportMD;
@property (nullable, nonatomic, copy) NSString *sportMode;
@property (nullable, nonatomic, copy) NSString *sportQD;
@property (nullable, nonatomic, copy) NSString *teacherId;
@property (nullable, nonatomic, copy) NSString *testBeginTime;
@property (nullable, nonatomic, copy) NSString *testID;
@property (nullable, nonatomic, copy) NSString *testMiddleText;
@property (nullable, nonatomic, copy) NSString *testTimeLong;
@property (nullable, nonatomic, copy) NSString *testTittle;
@property (nullable, nonatomic, copy) NSString *isPause;

@end

NS_ASSUME_NONNULL_END
