//
//  Header.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#ifndef Header_h
#define Header_h



#define KAddGroupSuccess @"KAddGroupSuccess"

#define KAddTestSuccess @"KAddTestSuccess"

#define KDeleteTestSuccess @"KDeleteTestSuccess"

#define KHoldTestSuccess @"KHoldTestSuccess"

#define KAddRunTestSuccess @"KAddRunTestSuccess"

#define KheartMessage @"heartMessage"

#define KPassWord @"KPassWord"

#define KPassWordAdmin @"KPassWordAdmin"

#define KHeadImage @"KHeadImage"

#define KPostTime @"KPostTime"

#define KCleanTime @"KCleanTime"

#define KWaitData @"KWaitData"

#define KUseHeart @"KUseHeart"



//==============================================================================


/*CoreData*/

//==============================================================================
/**
 *  CoreDataModel头文件
 *
 *  @return
 */
#import "MiUserDataModel.h"
#import "MiGroupModel.h"
#import "MiTeamer.h"
#import "MiHistoryTestModel.h"
#import "MiTestModel.h"
#import "MiUserTestModel.h"
#import "MiHeartModel.h" 

/*NormalData*/

//==============================================================================
/**
 *  NormalData头文件
 *
 *  @return
 */

#import "CUserModel.h"
#import "CGroupModel.h"
#import "CmemberModel.h"
#import "CHistoryTestModel.h"
#import "CTestModel.h"
#import "CuserTestModel.h"
#import "CHeartModel.h"



//==============================================================================




/*CoreData*/

//==============================================================================
/**
 *  CoreDataModel头文件
 *
 *  @return
 */
//#import "StudentModel.h"
#import "WatchModel.h"
//#import "LessonPlanModel.h"
//#import "LessonPlanIdUnitModel.h"
//#import "ScoreModel.h"
//#import "ScheduleModel.h"
#import "BluetoothDataModel.h"
#import "HaveClassModel.h"
#import "TestModel.h"
#import "HistoryTestModel.h"
#import "NotStudentModel.h"
#import "UserModel.h"
#import "VersionModel.h"
/*NormalData*/

//==============================================================================
/**
 *  NormalData头文件
 *
 *  @return
 */

#import "HJUserInfo.h"
//#import "HJStudentInfo.h"
#import "HJProjectInfo.h"
#import "HJGreadInfo.h"
//#import "HJLessonPlanInfo.h"
//#import "HJLessonPlanPhaseInfo.h"
//#import "HJLessonPlanUnitInfo.h"
#import "HJVersionInfo.h"

//==============================================================================

/*控制器*/

//==============================================================================
/**
 *  VC头文件
 *
 *  @return
 */

#import "HJUserManager.h"
#import "HJBaseVC.h"
#import "MyTool.h"





//==============================================================================

/*帮助类*/

//==============================================================================
/**
 *  帮助类头文件
 *
 *  @return
 */

#import "HJAppObject.h"

#import "NSArray+Extended.h"
#import "UIViewController+AMNoticeAlertView.h"
#import "UIViewController+AMAutoKeyBoardVC.h"
#import "HJBluetootManager.h"
#import "LifeBitCoreDataManager.h"
#import "APPIdentificationManage.h"
#import "MJRefresh.h"
#import "NSString+Category.h"
#import "JSON+Helpers.h"
#import "MiWatchManager.h"

#import "MiRunWatchManager.h"

#endif /* Header_h */
