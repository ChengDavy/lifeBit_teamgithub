//
//  endDataViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/9.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "endDataViewController.h"
#import "endDataTableViewCell.h"

@interface endDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSMutableArray * _watchArry;
    
    NSMutableArray * _scanArry;
    
    NSMutableArray * _scyArry;

    
    NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *asyButton;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@end

@implementation endDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _watchArry = [[NSMutableArray alloc]init];
    _scanArry = [[NSMutableArray alloc]init];
    _scyArry = [[NSMutableArray alloc]init];
    
    [self createView];
    [self createData];
    
    //定时刷新数据
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(reloadRssi) userInfo:nil repeats:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self createData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_timer invalidate];
}

- (void)reloadRssi{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_mytableView reloadData];
    
}

- (void)createView{
    
    [_mytableView registerNib:[UINib nibWithNibName:@"endDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"endDataTableViewCell"];
    
    [self setlayercornerRadius:_mytableView Radius:10];
    [self setlayercornerRadius:_asyButton Radius:10];

    
}
#pragma mark - 创建加载数据
- (void)createData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    _testId = [[NSUserDefaults standardUserDefaults]objectForKey:KWaitData];
    
    [_mytableView reloadData];
    
}
#pragma mark - 同步数据
- (IBAction)AsyData:(id)sender {
  
    
    if ([HJBluetootManager shareInstance].blueTools.scanWatchArray.count>11) {
        
        if ([HJBluetootManager shareInstance].ReadyConnectArray.count>11) {
            
            NSLog(@"[HJBluetootManager shareInstance].ReadyConnectArray.count %ld",[HJBluetootManager shareInstance].ReadyConnectArray.count);
            
              [self showNetWorkAlertWithTitleStr:@"同步中"];
            _scyArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
            
            [self MarkWatch:[_scyArry objectAtIndexWithSafety:0]];

        }else{
          NSLog(@"[HJBluetootManager shareInstance].ReadyConnectArray.count %ld",[HJBluetootManager shareInstance].ReadyConnectArray.count);
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"未能链接到全部手表,部分手表将不能同步" delegate:self cancelButtonTitle:nil otherButtonTitles:@"仍要同步",@"取消同步",@"蓝牙管理", nil];
            alert.tag = 111;
            
            [alert show];
        }

    }else{
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"未能检测到全部手表,部分手表将不能同步" delegate:self cancelButtonTitle:nil otherButtonTitles:@"仍要同步",@"取消同步",@"蓝牙管理", nil];
        alert.tag = 111;
        
        [alert show];
    }
}
#pragma mark - 设置手表用户信息

-(void)MarkWatch:(LBWatchPerModel*)watch{
    
    MiHistoryTestModel * historyTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:_testId];
    
    NSMutableArray * teamerArray = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiTeamerWith:historyTestModel.groupId];
    
    for (WatchModel * watchModel in _watchArry) {
        if ([watch.peripheral.name rangeOfString:watchModel.watchMAC].length>1) {
            for (MiTeamer * teamer in teamerArray) {
                if ([teamer.teamerNo isEqualToNumber: watchModel.watchNo]) {
                   
                    watch.testID = _testId;
                    watch.teamberID = teamer.teamerId;
                    watch.groupID = historyTestModel.groupId;
                    watch.beginTime = historyTestModel.testBeginTime;
                    watch.FailTime = 0;
                    
                    NSLog(@"teamer.teamerNo %@",teamer.teamerNo);
                    
                    [self toSyncHearContinueWithWatch:watch];
                    
                }
            }
            
        }
    }


}

#pragma mark - 同步连续心率
-(void)toSyncHearContinueWithWatch:(LBWatchPerModel*)watch{
    
    __weak endDataViewController* blockSelf = self;
    
    watch.type = LBWatchTypeHearting;
 
    
    [watch syncHeartContinueWithProgress:^(NSObject *anyObj) {
        
    } Success:^(NSObject *anyObj) {
        
        watch.upDateHeartData = (NSData*)anyObj;

        [self toSyncWalkWithWathch:watch];
        
    } fail:^(NSString * errorStr) {
        
        NSLog(@"心率失败 %@",watch.peripheral.name);
        watch.FailTime ++ ;
        
        if (watch.FailTime > 5) {
            watch.FailTime = 0;
             [self toSyncWalkWithWathch:watch];
            
        }else{
            if (watch.FailTime==2) {
                [[HJBluetootManager shareInstance]relongConnectWithWatch:watch];
            }
        [blockSelf toSyncHearContinueWithWatch:watch];
        }
    }];
}

#pragma mark - 同步计步数据
-(void)toSyncWalkWithWathch:(LBWatchPerModel*)watch {
    
    #pragma mark - 已同步过步数数据
    
    watch.type = LBWatchTypeSteping;
    
    
    [watch syncWalkWithProgress:^(NSObject *anyObj) {
        
        if ([[NSString stringWithFormat:@"%@",anyObj] integerValue]>0) {
            
            MiUserTestModel * userTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiUserTestModelUserTestModelId:_testId teamerID:watch.teamberID];
            
            if ([[NSString stringWithFormat:@"%@",anyObj] integerValue]>  [userTestModel.step integerValue]) {
                
                userTestModel.step = [NSString stringWithFormat:@"%@",anyObj];
                
                 NSString * calor = [NSString stringWithFormat:@"%ld",[userTestModel.teamerheight integerValue]*6*[userTestModel.step integerValue]/1500];
                
                userTestModel.calorie = calor;
                
                [[LifeBitCoreDataManager shareInstance] efUpdateMiUserTestModel:userTestModel];
            }
            
        }
        NSLog(@"步数成功 %@ \n %@ \n",watch.peripheral.name, anyObj);
        
    } Success:^(NSObject *anyObj) {
        
        watch.upDateWalkData = (NSData*)anyObj;
        watch.progressStr = @"";
        
//        NSString * base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
     
        NSLog(@"步数成功 %@ \n %@ \n",watch.peripheral.name, anyObj);
        
         watch.type = LBWatchTypeDataDone;
        
        if (_scyArry.count>1) {
            [_scyArry removeObject:watch];

            [self MarkWatch:[_scyArry objectAtIndexWithSafety:0]];
        }else {
            [_scyArry removeObject:watch];

            [self setTeamMessage];
            
            [self showSuccessAlertWithTitleStr:@"同步完成"];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KWaitData];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[MiRunWatchManager shareInstance]dealHeartWithTestID:_testId];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"同步完成\n是否上传数据到系统" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
            alert.tag = 222;
            
            [alert show];
            
        }
        
    } fail:^(NSString *errorStr) {
        
        NSLog(@"步数失败 %@",watch.peripheral.name);
        watch.FailTime ++;
        if (watch.FailTime>5) {
            watch.FailTime = 0;
            watch.type = LBWatchTypeDataFail;
            
            if (_scyArry.count>1) {
                [_scyArry removeObject:watch];
                
                [self MarkWatch:[_scyArry objectAtIndexWithSafety:0]];
            }else {
                [_scyArry removeObject:watch];
                
                [self setTeamMessage];
                
                [self showSuccessAlertWithTitleStr:@"同步完成"];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KWaitData];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否上传数据到系统" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
                alert.tag = 222;
                
                [alert show];
                
            }
            
        }else{
            if (watch.FailTime==2) {
                [[HJBluetootManager shareInstance]relongConnectWithWatch:watch];
            }
            
        [self toSyncWalkWithWathch:watch];
        }
       
    }];
}

#pragma mark - 重新加载数据

- (void)reloadData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_mytableView reloadData];
    
}
#pragma mark - 链接手表
- (void)exLinkWatchWithBU:(UIButton*)bu{
    
    WatchModel * watchmodel = [_watchArry objectAtIndexWithSafety:bu.tag-300];
    
    for (LBWatchPerModel* watch in _scanArry) {
        
        if ([watch.peripheral.name rangeOfString:watchmodel.watchMAC].length>0) {
            
            NSLog(@"watchmodel.peripheral.name  %@",watch.peripheral.name);
            [[HJBluetootManager shareInstance]relongConnectWithWatch:watch];
        
        }
    }
    [self showSuccessAlertWithTitleStr:@"正在连接手表"];
}
#pragma mark - 链接手表
- (void)exLinkWatchWithWatch:(LBWatchPerModel*)watch{

    [[HJBluetootManager shareInstance]relongConnectWithWatch:watch];
    
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _watchArry.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    endDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"endDataTableViewCell"];
    
    if (cell == nil) {
        cell = [[endDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endDataTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WatchModel * watchMode = [_watchArry objectAtIndexWithSafety:indexPath.row];
    
    cell.watchName.text = [NSString stringWithFormat:@"%@", watchMode.watchNo];
    
    cell.mac.text = watchMode.watchMAC;
    
    [self setlayercornerRadius:cell.exChange Radius:5];
    
    cell.exChange.tag = 300+indexPath.row;
    
    [cell.exChange addTarget:self action:@selector(exLinkWatchWithBU:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.conType.text = @"蓝牙未连接";
    cell.MyRSSI.text = @"0";
    
    for (LBWatchPerModel* watch in _scanArry) {
        
        if ([watch.peripheral.name rangeOfString:watchMode.watchMAC].length>0) {
            if (watch.waRSSI == NULL || watch.waRSSI.length<1) {
                cell.MyRSSI.text = @"0";
            }else{
                cell.MyRSSI.text = watch.waRSSI;
            }
            
            switch (watch.type) {
                    //                    LBWatchTypeUnConnected          = 0, // 没有连接
                case 0:
                {
                    cell.conType.text = @"点击重连";
                    
                }
                    break;
                    //                    LBWatchTypeConnecting           = 1, // 连接中
                case 1:
                {
                    cell.conType.text = @"连接中";
                    
                }
                    break;
                    //                    LBWatchTypeConnected            = 2, // 连接
                case 2:
                {
                    cell.conType.text = @"已连接";
                    
                }
                    break;
                    //                    LBWatchTypeDisConnected         = 3, // 连接失败
                case 3:
                {
                    cell.conType.text = @"点击重连";
                    
                }
                    break;
                    //                    LBWatchTypeSyncHeart             = 4,
                case 4:
                {
                    cell.conType.text = @"心率模式";
                    
                }
                    break;
                    //                    LBWatchTypeupDataHeart           = 5,
                case 5:
                {
                    cell.conType.text = @"上传心率数据";
                    
                }
                    break;
                    //                    LBWatchTypeSyncWalk             = 6,
                case 6:
                {
                    cell.conType.text = @"记步模式";
                    
                }
                    break;
                    //                    LBWatchTypeupDataWalk           = 7,
                case 7:
                {
                    cell.conType.text = @"上传记步数据";
                    
                }
                    break;
                    //                    LBWatchTypeNetError             =8,
                case 8:
                {
                    cell.conType.text = @"网络错误";
                    
                }
                    break;
                    //                    LBWatchTypeDone                 =9,    // 同步完成
                case 9:
                {
                    cell.conType.text = @"同步完成";
                    
                }
                    break;
                    //                    LBWatchTypeClean                =10,   //清除数据
                case 10:
                {
                    cell.conType.text = @"清除数据";
                    
                }
                    break;
                    //                    LBWatchTypeWait                 =11, // 等待连接
                case 11:
                {
                    cell.conType.text = @"等待链接";
                    
                }
                    break;
                    //                    LBWatchTypeClearDone                 =12,    // 清除数据同步完成
                    
                case 12:
                {
                    cell.conType.text = @"清除数据同步完成";
                    
                }
                    break;
                case 13:
                {
                    cell.conType.text = @"同步心率中";
                    
                }
                    break;
                case 14:
                {
                    cell.conType.text = @"同步步数中";
                    
                }
                    break;
                case 15:
                {
                    cell.conType.text = @"数据同步完成";
                    
                }
                    break;
                case 16:
                {
                    cell.conType.text = @"数据同步失败";
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            
        }
        
    }
    
    return cell;
}
- (void)setTeamMessage{
    
    MiHistoryTestModel * testmodel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:_testId];
    
    NSMutableArray * testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId] mutableCopy];
    
    //心率
    NSInteger avsHeart=0;
    
    NSInteger avsHeartNo=0;
    
    NSInteger MaxHeart=0;
    
    //卡路里
    
    NSInteger avscalorie=0;
    
    NSInteger avscalorieNO=0;
    
    //步数
    NSInteger avsStep=0;
    
    NSInteger avsStepNO=0;
    
    //运动密度
    NSInteger sportMD=0;
    
    NSInteger sportMDNO=0;
    
    //运动强度
    NSInteger sportQD=0;
    
    NSInteger sportQDNO=0;
    
    
    for (int i = 0; i < testArry.count; i++) {
        
        MiUserTestModel * userTestModel = [testArry objectAtIndexWithSafety:i];
        
        avsHeart = avsHeart + userTestModel.avsHeart.integerValue;
        
        if (userTestModel.avsHeart.integerValue) {
            avsHeartNo = avsHeartNo +1;
        }
        
        avscalorie = avscalorie + userTestModel.calorie.integerValue;
        
        if (userTestModel.calorie.integerValue) {
            avscalorieNO = avscalorieNO +1;
        }
        
        avsStep = avsStep + userTestModel.step.integerValue;
        
        if (userTestModel.step.integerValue) {
            avsStepNO = avsStepNO +1;
        }
        
        sportQD = sportQD + userTestModel.sportQD.integerValue;
        
        if (userTestModel.sportQD.integerValue) {
            sportQDNO = sportQDNO +1;
        }
        
        sportMD = sportMD + userTestModel.sportMD.integerValue;
        
        if (userTestModel.sportMD.integerValue) {
            sportMDNO = sportMDNO +1;
        }
        
        if (MaxHeart <  userTestModel.maxHeart.integerValue) {
            
            MaxHeart =userTestModel.maxHeart.integerValue;
        }
    }
    
    testmodel.avsStep = [NSString stringWithFormat:@"%ld",avsStep/avsStepNO];
    
    testmodel.avscalorie = [NSString stringWithFormat:@"%ld",avscalorie/avscalorieNO];
    
    testmodel.avsHeart = [NSString stringWithFormat:@"%ld",avsHeart/avsHeartNo];
    
    testmodel.sportQD = [NSString stringWithFormat:@"%ld",sportQD/sportQDNO];
    
    testmodel.sportMD = [NSString stringWithFormat:@"%ld",sportMD/sportMDNO];
    
    testmodel.maxHeart = [NSString stringWithFormat:@"%ld",MaxHeart];
    
    
    if ([[LifeBitCoreDataManager shareInstance] efAddMiHistoryTestModel:testmodel] ) {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==0) {
            [self showNetWorkAlertWithTitleStr:@"同步中"];
            
            _scyArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
            
            [self MarkWatch:[_scyArry objectAtIndexWithSafety:0]];
            
        }else if (buttonIndex==1){
            
        }else if (buttonIndex==2){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
     }
    if (alertView.tag==222) {
        if (buttonIndex==0) {
            [self showSuccessAlertWithTitleStr:@"同步完成"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (buttonIndex==1){
            [self showSuccessAlertWithTitleStr:@"同步完成"];
        
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self.delegate upData:_testId];
            
        }else if (buttonIndex==2){
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
