//
//  CUserModel.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/6.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "CUserModel.h"

@implementation CUserModel

@synthesize pAccount;
@synthesize pId;
@synthesize pUserName;
@synthesize pPic;
@synthesize pMoble;
@synthesize pEmail;
@synthesize pPass;

-(void)setAttributes:(NSDictionary *)attributes{
    
    self.pId = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pId"]]];
    self.pAccount = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pAccount"]]];
    self.pPass = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pPass"]]];
    self.pMoble = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pMoble"]]];
    self.pUserName = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pUserName"]]];
    self.pPic = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pPic"]]];
    self.pEmail = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"pEmail"]]];
    
    
   
}

+(CUserModel*)createCUserModelCoverUserData:(MiUserDataModel*)userModel{
    
    CUserModel * myUserModel = [[CUserModel alloc]init];
    
    myUserModel.pId = userModel.pId;
    myUserModel.pEmail= userModel.pEmail;
    myUserModel.pMoble = userModel.pMoble;
    myUserModel.pPass = userModel.pPass;
    myUserModel.pPic = userModel.pPic;
    myUserModel.pAccount = userModel.pAccount;
    myUserModel.pUserName = userModel.pUserName;

    return myUserModel;
}

+(MiUserDataModel*)coverUserDataWithUserMode:(CUserModel*)userInfo{
    
    MiUserDataModel * UserDataModel = [[LifeBitCoreDataManager shareInstance]efCraterMiUserModel];
    
     UserDataModel.pId = userInfo.pId;
     UserDataModel.pPass = userInfo.pPass;
     UserDataModel.pPic = userInfo.pPic;
     UserDataModel.pUserName = userInfo.pUserName;
     UserDataModel.pAccount = userInfo.pAccount;
     UserDataModel.pEmail = userInfo.pEmail;
     UserDataModel.pMoble = userInfo.pMoble;
    
    
    return UserDataModel;
    
    
}

@end
