//
//  CUserModel.h
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/6.
// strongright © 2017年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
#import "NSString+Category.h"
@interface CUserModel : BaseModel
/*
 
 用户account
 *  用户登陆凭证
 */
//@property (nonatomic, strong) NSString *uSigner;
 
@property (nonatomic, strong) NSString *pAccount;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *pUserName;
@property (nonatomic, strong) NSString *pPic;
@property (nonatomic, strong) NSString *pMoble;
@property (nonatomic, strong) NSString *pEmail;
@property (nonatomic, strong) NSString *pPass;



/**
 *  用户账号
 */
@property (nonatomic, strong) NSString *uAccount;
/**
 *  用户登陆凭证
 */
@property (nonatomic, strong) NSString *uSigner;

/**
 *  用户密码
 */
@property (nonatomic, strong) NSString *uPassword;

/**
 *  id
 */
@property (nonatomic, strong) NSString * uId;
/**
 *  老师id
 */
@property (nonatomic, strong) NSString * uTeacherId;


/**
 *  老师真实姓名
 */
@property (nonatomic, strong) NSString * uTeacherName;

/**
 *  用户性别
 */
@property (nonatomic, strong) NSString * uSex;


/**
 *  学校ID
 */
@property (nonatomic, strong) NSString * uSchoolId;

/**
 *  学校名称
 */
@property (nonatomic, strong) NSString * uSchoolName;
/**
 *  老师编号
 */
@property (nonatomic, strong) NSString * uTeacher_No;


/**
 *  老师年龄
 */
@property (nonatomic, strong) NSString * uTeacherAge;

/**
 *  老师电话号码
 */
@property (nonatomic, strong) NSString * uTeacherMobile;

/**
 *  老师专业
 */
@property (nonatomic, strong) NSString * uTeacherProfessional;


/**
 *  老师职称
 */
@property (nonatomic, strong) NSString * uTeacherJobTitle;


/**
 *  老师头像
 */
@property (nonatomic, strong) NSString * uTeacherIco;


/**
 *  学校所属区域
 */
@property (nonatomic, strong) NSString * uSchoolAreaID;



-(void)setAttributes:(NSDictionary *)attributes;

+(CUserModel*)createCUserModelCoverUserData:(MiUserDataModel*)userModel;

+(MiUserDataModel*)coverUserDataWithUserMode:(CUserModel*)userInfo;

@end
