//
//  MiNiStartViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiStartViewController.h"
#import "StartSetViewController.h"
#import "LoginViewController.h"
#import "addTeamViewController.h"
#import "endDataViewController.h"
#import "DetailsViewController.h"
#import "WebViewViewController.h"
@interface MiNiStartViewController ()<UIAlertViewDelegate,Updatadelegate>

@end

@implementation MiNiStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;

    [self createView];
//    [self checkTest];
    // Do any additional setup after loading the view from its nib.
}

-(void) createView{
    [self setlayercornerRadius:_headIm Radius:10];
    [self setlayercornerRadius:_backView1 Radius:10];
    [self setlayercornerRadius:_backView2 Radius:10];
    [self setlayercornerRadius:_backView3 Radius:10];
    [self setlayercornerRadius:_beginBu Radius:10];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
     [self checkTest];
    
}
-(void)upData:(NSString *)testId{
    
    DetailsViewController * detailsVc = [[DetailsViewController alloc]init];
    
    NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
    
    [pushDict setObject:testId forKey:@"testID"];
    
    detailsVc .PushDict = pushDict;
    
    [self.navigationController presentViewController:detailsVc animated:YES completion:nil];
}

- (IBAction)action1:(id)sender {
    NSString * htmlstr = [[NSBundle mainBundle] pathForResource:@"IPE"
                                                      ofType:@"pdf"];

    WebViewViewController * webView = [[WebViewViewController alloc]init];
    webView.headTittle = @"使用介绍";
    webView.UrlStr = htmlstr;
    [self presentViewController:webView animated:YES completion:nil];
    
    
    
}
- (IBAction)action2:(id)sender {
    
    addTeamViewController * addTeam = [[addTeamViewController alloc]init];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"1" forKey:@"isNew"];
    //    [dict setObject:groupModel.groupID forKey:@"groupID"];
    
    addTeam.PushDict = dict;
    
    [self.navigationController presentViewController:addTeam animated:YES completion:nil];
    

    NSLog(@"222");
}
- (IBAction)action3:(id)sender {
    NSLog(@"33");
}

- (IBAction)start:(id)sender {
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    
    if (TestModel.testID==NULL) {
        
        StartSetViewController * start = [[StartSetViewController alloc]init];
        [self.navigationController presentViewController:start animated:YES completion:nil];
        
    }else{

    UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"当前有未完成测试项目 %@",TestModel.testTittle] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续测试",@"新建测试", nil];
        
        myAlert .tag = 100;
        
        [myAlert show];
        
    }
    
}
- (IBAction)login:(id)sender {
    LoginViewController * login = [[LoginViewController alloc]init];
    [self.navigationController presentViewController:login animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex==0) {
            NSLog(@"0");
            
            
        }else if(buttonIndex==1){
            
            NSLog(@"1");
            
            MiHistoryTestModel * historyModel = [[LifeBitCoreDataManager shareInstance]efCraterMiHistoryTestModel];
            
            MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
            
            historyModel.avscalorie=TestModel.avscalorie;
            historyModel.avsHeart=TestModel.avsHeart;
            historyModel.avsStep=TestModel.avsStep;
            historyModel.groupId=TestModel.groupId;
            historyModel.groupName=TestModel.groupName;
            historyModel.maxHeart=TestModel.maxHeart;
            
            historyModel.sportMD=TestModel.sportMD;
            historyModel.sportQD=TestModel.sportQD;
            historyModel.teacherId=TestModel.teacherId;
            historyModel.sportMode=TestModel.sportMode;
            historyModel.testBeginTime=TestModel.testBeginTime;
            
            historyModel.testID=TestModel.testID;
            historyModel.testTimeLong=TestModel.testTimeLong;
            historyModel.testTittle=TestModel.testTittle;
            historyModel.testMiddleText=TestModel.testMiddleText;
            
            if ([[LifeBitCoreDataManager shareInstance]efAddMiHistoryTestModel:historyModel]) {
                
                [[LifeBitCoreDataManager shareInstance]efDeleteMiTestModel:TestModel];
                
                [self showSuccessAlertWithTitleStr:@"测试项目已结束,请在历史记录中查看"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:KHoldTestSuccess object:nil];
                
                StartSetViewController * start = [[StartSetViewController alloc]init];
                
                [self.navigationController presentViewController:start animated:YES completion:nil];
                
            };


        }
    }
    if (alertView.tag == 111) {
        if (buttonIndex==0) {
            NSLog(@"0");
            
            
        }else if(buttonIndex==1){
            
            NSLog(@"1");
            
            [[MiRunWatchManager shareInstance] reStartTest];
            
        }
    }
    if (alertView.tag == 222) {
        if (buttonIndex==0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KWaitData];
            [[NSUserDefaults standardUserDefaults]synchronize];
        
        }else if(buttonIndex==1){
            
            
        }else if(buttonIndex==2){
            endDataViewController * dataView = [[endDataViewController alloc]init];
            _testID = [[NSUserDefaults standardUserDefaults]objectForKey:KWaitData];
            dataView.delegate=self;
            [self.navigationController presentViewController:dataView animated:YES completion:nil];
            
            NSLog(@"2");
            
        }
    }

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

-(void)checkTest{
    
    MiTestModel * testmodel =  [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:@""];

    
    if (testmodel.testID.length>5) {
        
        int testLong = [testmodel.testTimeLong intValue];
        
        int setTimeLong = [[self getTimeRun:testmodel.testBeginTime] intValue];
        
        if (setTimeLong > testLong) {
            
            MiHistoryTestModel * historyModel = [[LifeBitCoreDataManager shareInstance]efCraterMiHistoryTestModel];
            
            MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
            
            historyModel.avscalorie=TestModel.avscalorie;
            historyModel.avsHeart=TestModel.avsHeart;
            historyModel.avsStep=TestModel.avsStep;
            historyModel.groupId=TestModel.groupId;
            historyModel.groupName=TestModel.groupName;
            historyModel.maxHeart=TestModel.maxHeart;
            
            historyModel.sportMD=TestModel.sportMD;
            historyModel.sportQD=TestModel.sportQD;
            historyModel.teacherId=TestModel.teacherId;
            historyModel.sportMode=TestModel.sportMode;
            historyModel.testBeginTime=TestModel.testBeginTime;
            
            historyModel.testID=TestModel.testID;
            historyModel.testTimeLong=TestModel.testTimeLong;
            historyModel.testTittle=TestModel.testTittle;
            historyModel.testMiddleText=TestModel.testMiddleText;
            
            if ([[LifeBitCoreDataManager shareInstance]efAddMiHistoryTestModel:historyModel]) {
                
                [[LifeBitCoreDataManager shareInstance]efDeleteMiTestModel:TestModel];
                
                [[NSUserDefaults standardUserDefaults]setObject:historyModel.testID forKey:KWaitData];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            };
 
            NSString * message =  [NSString stringWithFormat:@"检测到\n团队:%@\n时间:%@\n项目:%@\n项目已结束,是否同步手表测试数据",testmodel.groupName,testmodel.testBeginTime,testmodel.testTittle];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"不在提醒",@"稍后再试",@"现在同步", nil];
            alert.tag = 222;
            
            [alert show];
         
            
        }else{
            if ([MiRunWatchManager shareInstance].isRuning) {
   
            }else{

                NSString * message =  [NSString stringWithFormat:@"检测到\n团队:%@\n时间:%@\n项目:%@\n异常中断,是否恢复该项目",testmodel.groupName,testmodel.testBeginTime,testmodel.testTittle];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消测试",@"恢复项目", nil];
                alert.tag = 111;
                
                [alert show];
                
            }
            
        }
        
        
    }else{
        NSString * testId = [[NSUserDefaults standardUserDefaults]objectForKey:KWaitData];
        if (testId.length>1) {
            MiHistoryTestModel * historyTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:testId];
            if (historyTestModel.testID.length>1) {
                
                NSString * message =  [NSString stringWithFormat:@"检测到\n团队:%@\n时间:%@\n项目:%@\n项目已结束,是否同步手表测试数据",historyTestModel.groupName,historyTestModel.testBeginTime,historyTestModel.testTittle];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"不在提醒",@"稍后再试",@"现在同步", nil];
                alert.tag = 222;
                
                [alert show];
                
            }
            
        }
        
    }
    
    
}

- (NSString *)getTimeRun:(NSString *)beganTime{
    
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:beganTime];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:nowDate options:0];
    NSInteger second = [comps second];//时间差
    
    return  [NSString stringWithFormat:@"%ld",second];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
