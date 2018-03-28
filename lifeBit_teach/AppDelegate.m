//
//  AppDelegate.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "APPIdentificationManage.h"
#import "MiNiMainViewController.h"
#import "LoginViewController.h"
//#import <PgySDK/PgyManager.h>      /
#import <PgyUpdate/PgyUpdateManager.h>

#define PGY_APPKEY @"072ffa9f30d39b8477b85910986cad64"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if ([[HJAppObject sharedInstance]getCode:@"DemoWatch"].length<1) {
        [self createDemo];
//        [self createWatch];
        [self createWatchNew];

        [[HJAppObject sharedInstance]storeCode:@"DemoWatch" andValue:@"DemoWatch"];
    }
    
    [[HJUserManager shareInstance] init_singleton_from_disk];
    
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(linkheart:) name:@"readread" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endTest:) name:KAddTestSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endTest:) name:KHoldTestSuccess object:nil];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    if ([[HJUserManager shareInstance] efIsLogin]) {
        
        self.window.rootViewController=[[MiNiMainViewController alloc]init];
   
    }else{
        
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        self.window.rootViewController = loginVc;
        
    }
    [self.window makeKeyAndVisible];
    
    [self checkUpdata];
    
    [[HJBluetootManager shareInstance] registerBlueToothManager];
    

    return YES;

}

- (void)checkUpdata{
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager]checkUpdate];


}
#pragma mark - Methods

- (void)setupViewControllers {
    
     self.window.rootViewController=[[MiNiMainViewController alloc]init];
    
}

- (void)linkheart:(NSNotification * )not{

    [[MiRunWatchManager shareInstance]getHeartfromWatch];
    
}
- (void)endTest:(NSNotification * )not{
    
    [[MiRunWatchManager shareInstance]praise];
    
//    [[MiRunWatchManager shareInstance]endWatchModel];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self updateScheduleMeg];
    
//    [[HJBluetootManager shareInstance] registerBlueToothManager];
    
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "JJ.lifeBit_teach" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"lifeBit_teach" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lifeBit_teach.sqlite"];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
-(void)createWatchNew{
    for (int i = 0 ; i<12;i++ ) {
        switch (i) {
            case 0:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"1"];
                
                watchModel.watchMAC = @"8030DCF53938";
                watchModel.watchNo =  [NSNumber numberWithInt: 1];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
                
            }
                break;
            case 1:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"2"];
                
                watchModel.watchMAC = @"8030DCF22400";
                watchModel.watchNo = [NSNumber numberWithInt: 2];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
                
            }
                break;
            case 2:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"3"];
                
                watchModel.watchMAC = @"8030DCF2501B";
                watchModel.watchNo = [NSNumber numberWithInt: 3];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 3:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"4"];
                
                watchModel.watchMAC = @"8030DCF2291A";
                watchModel.watchNo = [NSNumber numberWithInt: 4];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 4:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"5"];
                
                watchModel.watchMAC = @"8030DCF24A87";
                watchModel.watchNo = [NSNumber numberWithInt: 5];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 5:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"6"];
                
                watchModel.watchMAC = @"8030DCF232C5";
                watchModel.watchNo = [NSNumber numberWithInt: 6];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 6:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"7"];
                
                watchModel.watchMAC = @"8030DCF21FA9";
                watchModel.watchNo = [NSNumber numberWithInt: 7];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 7:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"8"];
                
                watchModel.watchMAC = @"8030DCF21FBA";
                watchModel.watchNo = [NSNumber numberWithInt: 8];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 8:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"9"];
                
                watchModel.watchMAC = @"8030DCF742B1";
                watchModel.watchNo = [NSNumber numberWithInt: 9];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 9:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"10"];
                
                watchModel.watchMAC = @"8030DCF2243C";
                watchModel.watchNo = [NSNumber numberWithInt: 10];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 10:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"11"];
                
                watchModel.watchMAC = @"8030DCF21BB3";
                watchModel.watchNo = [NSNumber numberWithInt: 11];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 11:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"12"];
                
                watchModel.watchMAC = @"8030DCF7538D";
                watchModel.watchNo = [NSNumber numberWithInt: 12];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)createWatch{
    for (int i = 0 ; i<12;i++ ) {
        switch (i) {
            case 0:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"1"];
                
                watchModel.watchMAC = @"8030DCF214A7";
                watchModel.watchNo = [NSNumber numberWithInt: 1];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
                
            }
                break;
            case 1:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"2"];
                
                watchModel.watchMAC = @"8030DCF73929";
                watchModel.watchNo =[NSNumber numberWithInt: 2];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
                
            }
                break;
            case 2:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"3"];
                
                watchModel.watchMAC = @"8030DCF21481";
                watchModel.watchNo =[NSNumber numberWithInt: 3];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 3:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"4"];
                
                watchModel.watchMAC = @"8030DCF21BD9";
                watchModel.watchNo =[NSNumber numberWithInt: 4];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 4:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"5"];
                
                watchModel.watchMAC = @"8030DCF74148";
                watchModel.watchNo = [NSNumber numberWithInt: 5];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 5:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"6"];
                
                watchModel.watchMAC = @"8030DCF5304D";
                watchModel.watchNo = [NSNumber numberWithInt: 6];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 6:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"7"];
                
                watchModel.watchMAC = @"8030DCF7450C";
                watchModel.watchNo = [NSNumber numberWithInt: 7];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 7:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"8"];
                
                watchModel.watchMAC = @"8030DCF232EB";
                watchModel.watchNo = [NSNumber numberWithInt: 8];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 8:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"9"];
                
                watchModel.watchMAC = @"8030DCF21FDC";
                watchModel.watchNo = [NSNumber numberWithInt: 9];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 9:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"10"];
                
                watchModel.watchMAC = @"8030DCF52934";
                watchModel.watchNo = [NSNumber numberWithInt: 10];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 10:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"11"];
                
                watchModel.watchMAC = @"8030DCF53630";
                watchModel.watchNo = [NSNumber numberWithInt: 11];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
            case 11:
            {
                WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchModelBYwatchNo:@"12"];
                
                watchModel.watchMAC = @"8030DCF53943";
                watchModel.watchNo = [NSNumber numberWithInt: 12];
                
                watchModel.ipadIdentifying = @"11";
                watchModel.teachBoxId = @"23";
                watchModel.teachBoxName = @"xiao";
                watchModel.teacherId = [HJUserManager shareInstance].user.uId;
                [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)createDemo{
    
    NSArray * nameArry = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
    
    //测试demo
    
    MiHistoryTestModel * demoTestModel = [[LifeBitCoreDataManager shareInstance]efCraterMiHistoryTestModel];
    
    demoTestModel.testID = kMiDemoModelID;
    demoTestModel.avscalorie = @"2000";
    demoTestModel.avsStep = @"7000";
    demoTestModel.avsHeart = @"130";
    demoTestModel.maxHeart = @"180";
    
    demoTestModel.sportMD = @"90";
    demoTestModel.groupId = @"kMiDemoModelID";
    demoTestModel.sportQD = @"80";
    demoTestModel.teacherId = @"abc";
    demoTestModel.testTimeLong = @"3600";
    
    demoTestModel.testTittle = @"示例训练项目";
    demoTestModel.sportMode = @"普通运动";
    demoTestModel.groupName = @"示例团队";
    demoTestModel.testMiddleText = @"这是一个测试项目,通过他让你快速的了解与上手我们的乐比教具,希望你能在下面的使用过程中一切顺利";
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSString *dateStr =[dateFormat stringFromDate:[NSDate date]];
    
    demoTestModel.testBeginTime = dateStr;
    
    [[LifeBitCoreDataManager shareInstance]efAddMiHistoryTestModel:demoTestModel];
    
    MiGroupModel * group = [[LifeBitCoreDataManager shareInstance]efCraterMiGroupModel];
    
    group.createDeful = [NSNumber numberWithInt:1];
    group.createTime = [NSDate date];
    group.groupCreater = @"abc";
    group.groupName = @"示例团队";
    group.groupID = kMiDemoModelID;
    group.sportMode = @"普通运动";
    
    [[LifeBitCoreDataManager shareInstance]efAddMiGroupModel:group];
    
    
    for (int i = 0; i < 12; i++) {
        MiUserTestModel * userTestModel = [[LifeBitCoreDataManager shareInstance]efCraterMiUserTestModel];
        
        userTestModel.step = [NSString stringWithFormat:@"%d",5000+arc4random()%5000];
        userTestModel.avsHeart = [NSString stringWithFormat:@"%d",80+arc4random()%40];
        userTestModel.heart = [NSString stringWithFormat:@"%d",80+arc4random()%40];
        userTestModel.maxHeart = [NSString stringWithFormat:@"%d",100+arc4random()%20];
        userTestModel.calorie = [NSString stringWithFormat:@"%d",5000+arc4random()%5000];
        userTestModel.teamerAge = [NSString stringWithFormat:@"%d",14+arc4random()%5];
        
        userTestModel.teamerheight = [NSString stringWithFormat:@"%d",160+arc4random()%30];
        userTestModel.teamerWeight = [NSString stringWithFormat:@"%d",60+arc4random()%20];
        userTestModel.sportQD = [NSString stringWithFormat:@"%d",50+arc4random()%50];
        userTestModel.sportMD = [NSString stringWithFormat:@"%d",50+arc4random()%50];
        userTestModel.teamerName = [nameArry objectAtIndexWithSafety:i];
        
        userTestModel.teamerId= [NSString stringWithFormat:@"%@%d",kMiDemoModelID,i];
        userTestModel.teamerSex = @"男";
        userTestModel.teamerGroupId = kMiDemoModelID;
        userTestModel.teamerNo = [NSString stringWithFormat:@"%d",i+1];
        userTestModel.teamerPic = [NSString stringWithFormat:@"%d",i+1];
        userTestModel.testID = kMiDemoModelID;
        userTestModel.sportMode= @"普通运动";
        
        userTestModel.testBeginTime = dateStr;
        
        [[LifeBitCoreDataManager shareInstance]efAddMiUserTestModel:userTestModel];
        
        MiTeamer * teamer = [[LifeBitCoreDataManager shareInstance]efCraterMiTeamer];
        
        teamer.teamerId = [NSString stringWithFormat:@"%@%d",kMiDemoModelID,i];
        teamer.teamerNo =  [NSNumber numberWithInt:i+1];
        teamer.teamerPic =  [NSString stringWithFormat:@"%d",i+1];
        teamer.teamerGroupId = kMiDemoModelID;
        teamer.teamerName = [nameArry objectAtIndexWithSafety:i];
        
        
        teamer.teamerSex =@"男";
        teamer.teamerheight = [NSString stringWithFormat:@"%d",160+arc4random()%30];
        teamer.teamerWeight = [NSString stringWithFormat:@"%d",60+arc4random()%20];
        teamer.teamerAge = [NSString stringWithFormat:@"%d",14+arc4random()%5];
        
        [[LifeBitCoreDataManager shareInstance]efAddMiTeamer:teamer];
        
    }
}

@end
