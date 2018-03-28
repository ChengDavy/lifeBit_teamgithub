//
//  MiUserDataModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/6.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiUserDataModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MiUserDataModel (CoreDataProperties)

+ (NSFetchRequest<MiUserDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *pAccount;
@property (nullable, nonatomic, copy) NSString *pId;
@property (nullable, nonatomic, copy) NSString *pUserName;
@property (nullable, nonatomic, copy) NSString *pPic;
@property (nullable, nonatomic, copy) NSString *pMoble;
@property (nullable, nonatomic, copy) NSString *pEmail;
@property (nullable, nonatomic, copy) NSString *pPass;

@end

NS_ASSUME_NONNULL_END
