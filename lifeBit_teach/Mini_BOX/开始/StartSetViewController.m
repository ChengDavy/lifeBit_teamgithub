//
//  StartSetViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "StartSetViewController.h"
#import "addTeamViewController.h"
#import "WatchManagerViewController.h"
#import "CTestModel.h"

@interface StartSetViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>{
    
    NSMutableArray * _GroupArry;
    
    NSMutableArray * _TeamArry;
    
    NSMutableArray * _GroupName;
    
    NSString * _groupID;
    
    NSInteger _reSetTime;
    
}
@property (weak, nonatomic) IBOutlet UITextField *tittleTf;
@property (weak, nonatomic) IBOutlet UIView *tittleBack;
@property (weak, nonatomic) IBOutlet UIView *dateBack;
@property (weak, nonatomic) IBOutlet UIView *timeBack;
@property (weak, nonatomic) IBOutlet UIView *sportModel;
@property (weak, nonatomic) IBOutlet UIView *teamSet;
@property (weak, nonatomic) IBOutlet UIView *heartSet;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartLabel;
@property (weak, nonatomic) IBOutlet UIButton *dataBU;
@property (weak, nonatomic) IBOutlet UIButton *timeBu;
@property (weak, nonatomic) IBOutlet UIButton *modelBU;
@property (weak, nonatomic) IBOutlet UIButton *teamBU;
@property (weak, nonatomic) IBOutlet UIButton *startBU;
@property (weak, nonatomic) IBOutlet UIButton *heartBU;


@end

@implementation StartSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];
    
    [self createData];
    
    [self checkClean];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerAdd:) name:KAddGroupSuccess object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)createData{
    
    _TeamArry = [[NSMutableArray alloc]init];
    _GroupArry = [[NSMutableArray alloc]init];
    _GroupName = [[NSMutableArray alloc]init];
    
    _GroupArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiGroupModel] mutableCopy];
    
    _GroupName = [[self GroupNameArrByGroupArry:_GroupArry] mutableCopy];
    
    if (_GroupName.count>0) {
        
        _teamLabel.text = [_GroupName objectAtIndexWithSafety:0];
        MiGroupModel * groupModel = [_GroupArry objectAtIndexWithSafety:0];
        
        _groupID = groupModel.groupID;
        
    }else{
        _teamLabel.text = @"点击新建团队";
    }
    NSString * heartNo = [[NSUserDefaults standardUserDefaults]objectForKey:KUseHeart];
    if (heartNo.length<2) {
        heartNo = @"90";
        [[NSUserDefaults standardUserDefaults]setObject:heartNo forKey:KUseHeart];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    _heartLabel.text = [NSString stringWithFormat:@"%@bpm",heartNo];
    
}
- (IBAction)ReSetWatch:(id)sender {
    
    UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确认重置全部手表" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    
    myAlert.tag = 44444;
    
    [myAlert show];
    
}

- (void)checkClean{
    NSString * Date = [[NSUserDefaults standardUserDefaults]objectForKey:KCleanTime];
    
    NSDate * today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"dd"];
    // 使用日期格式器格式化日期、时间
    NSString *DateString = [dateFormatter stringFromDate:today];
    
    if ([DateString isEqualToString:Date]) {
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"为保证测试精准度,将对设备进行重置,该操作将在20s内完成" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        alert.tag = 66666;
        [alert show];
        
        [[NSUserDefaults standardUserDefaults]setObject:DateString forKey:KCleanTime];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

//监听添加群组
- (void)observerAdd:(NSNotification *)notification{
    _GroupArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiGroupModel] mutableCopy];
    
    _GroupName = [[self GroupNameArrByGroupArry:_GroupArry] mutableCopy];
    
    if (_GroupName.count>0) {
        
        _teamLabel.text = [_GroupName objectAtIndexWithSafety:0];
        MiGroupModel * groupModel = [_GroupArry objectAtIndexWithSafety:0];
        
        _groupID = groupModel.groupID;
        
    }else{
        _teamLabel.text = @"点击新建团队";
    }
   
}

- (void)creatView{
    
    //后视图
    
    _dateBack.layer.masksToBounds=YES;
    _dateBack.layer.cornerRadius=5;
    _tittleBack.layer.masksToBounds=YES;
    _tittleBack.layer.cornerRadius=5;
    _timeBack.layer.masksToBounds=YES;
    _timeBack.layer.cornerRadius=5;
    _sportModel.layer.masksToBounds=YES;
    _sportModel.layer.cornerRadius=5;
    _teamSet.layer.masksToBounds=YES;
    _teamSet.layer.cornerRadius=5;
    _backDateB.layer.masksToBounds=YES;
    _backDateB.layer.cornerRadius=5;
    _heartSet.layer.masksToBounds=YES;
    _heartSet.layer.cornerRadius=5;
  
    
    _selectBack.hidden = YES;
    
    //按钮
    [self setlayercornerRadius:_dataBU Radius:5];
    [self setlayercornerRadius:_timeBu Radius:5];
    [self setlayercornerRadius:_modelBU Radius:5];
    [self setlayercornerRadius:_teamBU Radius:5];
    [self setlayercornerRadius:_heartBU Radius:5];
    [self setlayercornerRadius:_startBU Radius:5];
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [NSDate date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    _dateLabel.text = destDateString;
    
    
}
- (void) addTeam:(NSNotification*)Not{
    
    addTeamViewController * addTeam = [[addTeamViewController alloc]init];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"1" forKey:@"isNew"];
    
    addTeam.PushDict = dict;
    
    [self presentViewController:addTeam animated:YES completion:nil];
}

- (IBAction)dateSelect:(id)sender {
    
    _selectBack.hidden = NO;
    
    _myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    
}
- (IBAction)timeSelect:(id)sender {
    
    UIActionSheet * timeSheet = [[UIActionSheet alloc]initWithTitle:@"选择运动时长" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"15分钟",@"30分钟",@"45分钟",@"60分钟",@"自定义时间", nil];
    timeSheet.tag = 33333;
    
    [timeSheet showInView:self.view];
    
}
- (IBAction)modelSelect:(id)sender {
    
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"运动模式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"普通运动",@"上肢运动", nil];
    action.tag = 11111;
    [action showInView:self.view];
    
}
- (IBAction)teamSelect:(id)sender {
    
    if (_GroupName.count==0) {
        [self addTeam:nil];
    }else{
        
        UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"运动模式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (NSString * item in _GroupName) {
            
            [action addButtonWithTitle:item];
            
        }
        
        action.tag = 22222;
        [action showInView:self.view];
    }

}
- (IBAction)heartSet:(id)sender {
    
    UIActionSheet * timeSheet = [[UIActionSheet alloc]initWithTitle:@"选择有效运动心率标准" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"90bpm",@"95bpm",@"100bpm",@"105bpm",@"110bpm",@"115bpm",@"120bpm", nil];
    timeSheet.tag = 77777;
    
    [timeSheet showInView:self.view];
    
}

- (IBAction)startSelect:(id)sender {
    
    if (_tittleTf.text.length<1) {
        [self showErroAlertWithTitleStr:@"项目名不能为空"];
        return;
    }
    if ([HJBluetootManager shareInstance].blueTools.scanWatchArray.count>11) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KWaitData];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self creatTestModel];
    
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"手表未能全部链接,将会影响测试效果,请检查手表链接状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"开始项目",@"手表管理", nil];
        alert.tag = 55555;
        [alert show];
        
    }
  
}
- (void)creatTestModel{
    
    CTestModel * Model = [[CTestModel alloc]init];
    
    Model.testTittle=_tittleTf.text;
    Model.avscalorie=@"0";
    Model.avsHeart=@"0";
    Model.avsStep=@"0";
    Model.groupId=_groupID;
    Model.groupName=_teamLabel.text;
    Model.maxHeart=@"0";
    
    Model.sportMD=@"0";
    Model.sportQD=@"0";
    Model.teacherId=[HJUserManager shareInstance].user.pId;
    Model.sportMode=_modelLabel.text;
    
    
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [NSDate date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    Model.testBeginTime= destDateString;
    
    Model.testID=[NSString getStrArc4randomWithSize:16];
    
    [MiRunWatchManager shareInstance].testId = Model.testID;
    
    Model.testTimeLong=[self getSecondByDateStr:_timeLabel.text];
    Model.testMiddleText=@"";
    
    MiTestModel * TestModel = [CTestModel createMiTestModelWithCTestModel:Model];
    
    _TeamArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiTeamerWith:_groupID] mutableCopy] ;
    
    if ( [[LifeBitCoreDataManager shareInstance] efAddMiTestModel:TestModel] ) {
        
        [self createUerTestModeltestId:Model.testID];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"测试项目已启动,手环将在30秒内配置完成" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kMiBeginAction object:nil];
        
    }else{
        [self showErroAlertWithTitleStr: @"创建失败,"];
    }
}
//时间变成秒

- (NSString *)getSecondByDateStr:(NSString*)dateStr{
    
    NSString *strTime = dateStr;
    NSArray *array = [strTime componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *HH = array[0];
    NSString *MM= array[1];
    NSString *ss = array[2];
    NSInteger h = [HH integerValue];
    NSInteger m = [MM integerValue];
    NSInteger s = [ss integerValue];
    NSInteger zonghms = h*3600 + m*60 +s;
    
    //需要的在转 NSString类型
    return [NSString stringWithFormat:@"%ld",(long)zonghms];//转字符串
}

//创建个人测试数据

- (void)createUerTestModeltestId:(NSString *)testId{
        
    if (_TeamArry.count>0) {
        for (int i =0; i<_TeamArry.count; i++) {
            NSLog(@"%ld",_TeamArry.count);
        MiTeamer * teamer = [_TeamArry objectAtIndexWithSafety:i];
            
        MiUserTestModel * testModel = [[LifeBitCoreDataManager shareInstance]efCraterMiUserTestModel];

        testModel.testID = [MiRunWatchManager shareInstance].testId;
        testModel.step = @"0";
        testModel.avsHeart = @"0";
        testModel.heart = @"0";
        testModel.maxHeart = @"0";
        testModel.calorie = @"0";
        
        testModel.teamerAge = teamer.teamerAge;
        testModel.teamerGroupId = teamer.teamerGroupId;
        testModel.teamerheight = teamer.teamerheight;
        testModel.teamerId = teamer.teamerId;
        testModel.teamerName = teamer.teamerName;
        testModel.testBeginTime = _dateLabel.text;
        testModel.sportMode = _modelLabel.text;
        
        testModel.teamerNo = [NSString stringWithFormat:@"%@", teamer.teamerNo];
        testModel.teamerPic = teamer.teamerPic;
        testModel.teamerSex = teamer.teamerSex;
        testModel.teamerWeight = teamer.teamerWeight;
        testModel.sportQD = @"0";
            
        testModel.sportMD = @"0";

        if ( [[LifeBitCoreDataManager shareInstance] efAddMiUserTestModel:testModel] ) {
            
            
        }else{
            [self showErroAlertWithTitleStr: @"创建个人失败,"];
        }
        
        }
    }else{
        [self showSuccessAlertWithTitleStr:@"创建成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KAddRunTestSuccess object:nil];
        
    }

    [[MiRunWatchManager shareInstance]setWatchModel];
    
}

- (IBAction)cancelDate:(id)sender {
    
    _selectBack.hidden=YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    if (alertView.tag == 44444){
        
        if (buttonIndex == 1) {
            
            [NSTimer ibLocalInvertedTimekeeping:20 timing:^(int value, BOOL isArriving) {
                _reSetTime = value;
                
                if (value>0) {
                    _resetButton.enabled = NO;
                    _startBU.enabled = NO;
                    
                    [_resetButton setTitle:@"重置中" forState:UIControlStateNormal];
                    [_startBU setTitle:[NSString stringWithFormat:@"重置中还剩 %d 秒",value]forState:UIControlStateNormal];
                }else{
                    _resetButton.enabled = YES;
                    _startBU.enabled = YES;
                    [_resetButton setTitle:@"重置手表" forState:UIControlStateNormal];
                    [_startBU setTitle:[NSString stringWithFormat:@"开始训练"]forState:UIControlStateNormal];
                }
   
            }];

            [[MiRunWatchManager shareInstance] reSetWatchModel];
            
        }
    }
  
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 55555){
        
        if (buttonIndex == 0) {
            
            [self creatTestModel];
        }
        
        if (buttonIndex == 1) {
            
            WatchManagerViewController *  WatchManager = [[WatchManagerViewController alloc]init];
            
            [self presentViewController:WatchManager animated:YES completion:nil];
        }
    }
    
    if (alertView.tag == 66666){
    
        [self ReSetWatch:nil];
        
    }
 
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 11111) {
        if (buttonIndex == 0) {
            NSLog(@"普通运动");
            _modelLabel.text = @"普通运动";
        }else  if (buttonIndex == 1) {
            _modelLabel.text = @"上肢运动";
            NSLog(@"上肢运动");
        }
    }else if (actionSheet.tag == 22222){
        
        if (buttonIndex >= 0) {
            
            NSString * groupName = [_GroupName objectAtIndexWithSafety:buttonIndex];
            
            _teamLabel.text = groupName;
            
            MiGroupModel * groupModel = [_GroupArry objectAtIndexWithSafety:buttonIndex];
            
            _groupID = groupModel.groupID;
            
        }
    }else if (actionSheet.tag == 33333){
        
        if (buttonIndex == 0) {
            NSLog(@"15");
            _timeLabel.text = @"00:15:00";
        }else  if (buttonIndex == 1) {
            _timeLabel.text = @"00:30:00";
            NSLog(@"30");
        }else  if (buttonIndex == 2) {
            _timeLabel.text = @"00:45:00";
            NSLog(@"45");
        }
        else  if (buttonIndex == 3) {
            _timeLabel.text = @"01:00:00";
            NSLog(@"60");
        }
        else  if (buttonIndex == 4) {
            
            _selectBack.hidden = NO;
            _myDatePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }
        NSLog(@"%@",[self getSecondByDateStr:_timeLabel.text]);
    }else if (actionSheet.tag == 77777){
        
        if (buttonIndex == 0) {
            NSLog(@"90");
            _heartLabel.text = @"90bpm";
            [[NSUserDefaults standardUserDefaults]setObject:@"90" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else  if (buttonIndex == 1) {
            _heartLabel.text = @"95bpm";
            NSLog(@"95");
            [[NSUserDefaults standardUserDefaults]setObject:@"95" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else  if (buttonIndex == 2) {
            _heartLabel.text = @"100bpm";
            NSLog(@"100");
            [[NSUserDefaults standardUserDefaults]setObject:@"100" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else  if (buttonIndex == 3) {
            _heartLabel.text = @"105bpm";
            NSLog(@"105");
            [[NSUserDefaults standardUserDefaults]setObject:@"105" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else  if (buttonIndex == 4) {
            _heartLabel.text = @"110bpm";
            NSLog(@"110");
            [[NSUserDefaults standardUserDefaults]setObject:@"110" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];

        } else  if (buttonIndex == 5) {
            _heartLabel.text = @"115bpm";
            NSLog(@"115");
            [[NSUserDefaults standardUserDefaults]setObject:@"115" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else  if (buttonIndex == 6) {
            _heartLabel.text = @"120bpm";
            NSLog(@"120");
            [[NSUserDefaults standardUserDefaults]setObject:@"120" forKey:KUseHeart];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
//        [self showSuccessAlertWithTitleStr:@"设置成功"];
    }
    
}
- (IBAction)selectDate:(id)sender {
    
    _selectBack.hidden=YES;
    
    if (_myDatePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        // 获取用户通过UIDatePicker设置的日期和时间
        NSDate *selected = [_myDatePicker date];
        // 创建一个日期格式器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        
        _dateLabel.text = destDateString;
    }
    else if (_myDatePicker.datePickerMode == UIDatePickerModeCountDownTimer)
    {
        
        // 获取用户通过UIDatePicker设置的日期和时间
        NSDate *selected = [_myDatePicker date];
        // 创建一个日期格式器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"HH:mm:ss "];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        
        _timeLabel.text = destDateString;
    }
}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  团队数组---团队数组
- (NSArray *)GroupNameArrByGroupArry:(NSArray*)groupArry{
    
    NSMutableArray * NameArry = [[NSMutableArray alloc]init];
    
    for (MiGroupModel * groupModel in groupArry) {
        
        [NameArry addObject:[NSString stringWithFormat:@"%@",groupModel.groupName]];
        
    }
    return NameArry;
    
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
