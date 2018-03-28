//
//  MiTeamerViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/14.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiTeamerViewController.h"
#import "ZXView.h"


@interface MiTeamerViewController ()<UIAlertViewDelegate>{
    
    NSString * _teamerID;
    NSString * _testID;
    
    MiUserTestModel * _userTestModel;   //个人测试model
    
    MiTestModel * _TestModel;    //测试model
    
    MiHistoryTestModel * _HistoryTestModel;    //测试历史model
    NSMutableArray * _heartArry;
    NSMutableDictionary * _gradeDic;
    NSUInteger            _timeLong;
    NSUInteger            _timeNO1;
    NSUInteger            _timeNO2;
    NSUInteger            _timeNO3;
    NSUInteger            _timeNO4;
    NSUInteger            _timeNO5;
    
}
@property (nonatomic,strong) ZXView * zxView;

@end

@implementation MiTeamerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)getdata{
    _heartArry = [[NSMutableArray alloc]init];
    _gradeDic = [[NSMutableDictionary alloc]init];
    
    _testID = [_pushDict objectForKeyNotNull:@"testID"];
    
    _teamerID = [_pushDict objectForKeyNotNull:@"teamerId"];
    
    _userTestModel = [[LifeBitCoreDataManager shareInstance] efGetMiUserTestModelUserTestModelId:_testID teamerID:_teamerID];
    
    switch (_ShowType) {
        case teamerShowDemoType:
        {
            
            _HistoryTestModel = [[LifeBitCoreDataManager shareInstance] efGetMiHistoryTestModelHistoryTestModelId:kMiDemoModelID];
            
            _timeLong = [_HistoryTestModel.testTimeLong integerValue];
            

            
            _timelong.text = [NSString getTimeFromSecondStr:_HistoryTestModel.testTimeLong ];
            
             [self setzxXlineBytime:_timeLong];
            
            [self loadHistoryData];
            [self loadDemoModelTime];

        }
            break;
            
        case teamerShowTestType:
            
        {

            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTimePoint:) name:KPostTime object:nil];
            
            _TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:_testID];
            
            NSInteger time = [_TestModel.testTimeLong integerValue];

            [self setzxXlineBytime:time];
            
            [self loadTestData];

            [self reloadData:nil];
            
        }
            break;
        case teamerShowHistoryType:
        {
            
            _HistoryTestModel = [[LifeBitCoreDataManager shareInstance] efGetMiHistoryTestModelHistoryTestModelId:_testID];
            
            _timeLong = [_HistoryTestModel.testTimeLong integerValue];
            
            _timelong.text = [NSString getTimeFromSecondStr:_HistoryTestModel.testTimeLong ];

            [self setzxXlineBytime:_timeLong];

            [self loadHistoryData];
            
            [self reloadData:nil];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//重连表

- (IBAction)relinkWatch:(id)sender {
    
    UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确认重连手表,为保证重连结果请确保手环在平板附近." delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    
    [myAlert show];

}
#pragma mark - 获刷新界面

- (void)reloadData:(NSNotification*)not{
    
    _gradeDic = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelGradeWithTestId:_testID withTeamerId:_teamerID];
    _heartArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelWithTestId:_testID withTeamerId:_teamerID] mutableCopy] ;
    
    [self reloadView];
    
}

#pragma mark - 获取时间点

- (void)getTimePoint:(NSNotification*)not{
    
    _TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:_testID];
    [self loadTestData];
    [self reloadData:nil];
    
    NSDictionary * postDic = not.object;
    
    int timeRun = [[postDic objectForKeyNotNull:@"overTime"] intValue];
    
    _timeLong = timeRun;
    
    NSString *tmphh = [NSString stringWithFormat:@"%d",timeRun/3600];
    
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(timeRun/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",timeRun%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
     _timelong.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    
}

#pragma mark - 刷新页面
- (void)setzxXlineBytime:(NSInteger)time{
    if (time <= 1800) {
        [_zxView setViewTimeType:Time30];
    }else if (time>1800&&time<=3600){
        [_zxView setViewTimeType:Time60];
    }else{
        [_zxView setViewTimeType:Time90];
    }
    
}
- (void)reloadView{
    
    NSInteger total1 = [[_gradeDic objectForKeyNotNull:@"total1"] integerValue];
    NSInteger total2 = [[_gradeDic objectForKeyNotNull:@"total2"] integerValue];
    NSInteger total3 = [[_gradeDic objectForKeyNotNull:@"total3"] integerValue];
    NSInteger total4 = [[_gradeDic objectForKeyNotNull:@"total4"] integerValue];
    NSInteger total5 = [[_gradeDic objectForKeyNotNull:@"total5"] integerValue];
    
    NSInteger per1 = [[_gradeDic objectForKeyNotNull:@"per1"] integerValue];
    NSInteger per2 = [[_gradeDic objectForKeyNotNull:@"per2"] integerValue];
    NSInteger per3 = [[_gradeDic objectForKeyNotNull:@"per3"] integerValue];
    NSInteger per4 = [[_gradeDic objectForKeyNotNull:@"per4"] integerValue];
    NSInteger per5 = [[_gradeDic objectForKeyNotNull:@"per5"] integerValue];
    
    _layer1.constant = total1*500/10000;
    _layer2.constant = total2*500/10000;
    _layer3.constant = total3*500/10000;
    _layer4.constant = total4*500/10000;
    _layer5.constant = total5*500/10000;
    
    _Nulayer1.constant = per1*500/10000;
    _Nulayer2.constant = per2*500/10000;
    _Nulayer3.constant = per3*500/10000;
    _Nulayer4.constant = per4*500/10000;
    _Nulayer5.constant = per5*500/10000;
    
    _timeNO1 = _timeLong * per1 /10000;
    
    _time1.text = [self getTimeFromSecond:_timeNO1 ];
    
    _timeNO2 = _timeLong * per2 /10000;
    
    _time2.text = [self getTimeFromSecond:_timeNO2 ];

    _timeNO3 = _timeLong * per3 /10000;
    
    _time3.text = [self getTimeFromSecond:_timeNO3 ];

    _timeNO4 = _timeLong * per4 /10000;

    _time4.text = [self getTimeFromSecond:_timeNO4 ];
    
    _timeNO5 = _timeLong * per5 /10000;
    
    _time5.text = [self getTimeFromSecond:_timeNO5 ];

    _zxView.testID =_testID;
    
    _zxView.teamerID = _teamerID;
    
    [_zxView loadData:_heartArry Animated:YES timeLong:_timeLong];
    
}

#pragma mark - 秒转时间

- (NSString*)getTimeFromSecond:(NSInteger)Second{
    
    int timeRun = Second;
    
    NSString *tmphh = [NSString stringWithFormat:@"%d",timeRun/3600];
    
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(timeRun/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",timeRun%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
  
}
- (void)loadDemoModelTime{
    
    _layer1.constant = 1000*500/10000;
    _layer2.constant = 2000*500/10000;
    _layer3.constant = 4000*500/10000;
    _layer4.constant = 2500*500/10000;
    _layer5.constant = 500*500/10000;
    
    _Nulayer1.constant = 2500*500/10000;
    _Nulayer2.constant = 1000*500/10000;
    _Nulayer3.constant = 4000*500/10000;
    _Nulayer4.constant = 2000*500/10000;
    _Nulayer5.constant = 500*500/10000;
    
    _timeNO1 = _timeLong * 2500 /10000;
    
    _time1.text = [self getTimeFromSecond:_timeLong * 2500 /10000 ];
    
    _time2.text = [self getTimeFromSecond:_timeLong * 1000 /10000 ];
    
    _time3.text = [self getTimeFromSecond:_timeLong * 4000 /10000];
    
    _time4.text = [self getTimeFromSecond:_timeLong * 2000 /10000];
    
    _time5.text = [self getTimeFromSecond:_timeLong * 500 /10000 ];
 
    [_zxView loadDemoData];
}
- (void)loadHistoryData{
    
    _headimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"2.%@",_userTestModel.teamerNo]];
    _name.text = [NSString stringWithFormat:@"%@ 号",_userTestModel.teamerNo];
    _miniName.text = _userTestModel.teamerName;
    _date.text = _userTestModel.testBeginTime;
    _sportQD.text = [NSString stringWithFormat:@"%@%%",_userTestModel.sportQD];
    _sportMode.text = _userTestModel.sportMode;
    _heart.text = _userTestModel.avsHeart;
    _step.text = _userTestModel.step;
    
}

- (void)loadTestData{
    
    _headimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"2.%@",_userTestModel.teamerNo]];
    _name.text = [NSString stringWithFormat:@"%@ 号",_userTestModel.teamerNo];
    _miniName.text = _userTestModel.teamerName;
    _date.text = _userTestModel.testBeginTime;
    _sportQD.text = [NSString stringWithFormat:@"%@%%",_userTestModel.sportQD];
    _sportMode.text = _userTestModel.sportMode;
    _heart.text = _userTestModel.heart;
    _step.text = _userTestModel.step;
    
}
- (void)setView{
    [self setlayercornerRadius:_headBack Radius:10];
    [self setlayercornerRadius:_middeBack Radius:10];
    [self setlayercornerRadius:_footBack Radius:10];
    
    [self createLinChart];
}

- (void)createLinChart{
    
    _zxView = [[ZXView alloc]initWithFrame:CGRectMake(16, 22, 730, 285)];
    
    _zxView.backgroundColor = [UIColor clearColor];
    
    [_footBack addSubview:_zxView];
    
     [_zxView loadData:_heartArry Animated:YES timeLong:_timeLong];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1){
        
        _watchArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
        
        WatchModel * watchMode = [[LifeBitCoreDataManager shareInstance]efGetWatchModelBYwatchNo:_userTestModel.teamerNo];
        
        if ([MiRunWatchManager shareInstance].isRuning) {
            
            for (LBWatchPerModel * watchPerModel in _watchArry) {
                
                if ([[[watchPerModel.peripheral.name componentsSeparatedByString:@"-"] objectAtIndexWithSafety:1] isEqualToString:watchMode.watchMAC]) {
                    
                    [[MiRunWatchManager shareInstance].unconnArry addObject:_userTestModel];
                    
                    [[HJBluetootManager shareInstance] addReConnectWithWatch:watchPerModel];
                    
                    [self showSuccessAlertWithTitleStr:@"已提交重连队列成功"];
                    
                }
            }
        }else{
            [self showErroAlertWithTitleStr:@"项目未启动"];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
