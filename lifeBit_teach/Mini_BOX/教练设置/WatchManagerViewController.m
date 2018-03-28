//
//  WatchManagerViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/10.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "WatchManagerViewController.h"
#import "scanViewController.h"
#import "watchTableViewCell.h"
#import "NSTimer+Expand.h"
@interface WatchManagerViewController ()<ScanDelegate,UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate,UIActionSheetDelegate>{
    NSMutableArray * _watchArry;
    
    NSMutableArray * _scanArry;
    
    NSNumber * _watchNo;
    
    NSTimer * _timer;
    
     NSTimer * _timer2;
}

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UIView *SetWatchback;
@property (weak, nonatomic) IBOutlet UIView *enterBack;
@property (weak, nonatomic) IBOutlet UITextField *macTf;

@property (weak, nonatomic) IBOutlet UIButton *enterBU;
@property (weak, nonatomic) IBOutlet UIButton *scanBU;
@property (weak, nonatomic) IBOutlet UIButton *backBU;
@end

@implementation WatchManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      _watchArry = [[NSMutableArray alloc]init];
      _scanArry = [[NSMutableArray alloc]init];
    
    [self createView];
    [self createData];
    
    //定时刷新数据
//    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadRssi) userInfo:nil repeats:YES];

    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(reloadRssi) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self createData];
//    [self reblue:nil];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_timer invalidate];
}
- (IBAction)reblue:(id)sender {
    
    [[HJBluetootManager shareInstance]refreshScanAllWatch];
    
}

- (void)reloadRssi{
    
    NSLog(@"NSDate  %@",[NSDate date]);
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];

    [_mytableView reloadData];
    
}
- (void)reloadRssi2{
    
    NSLog(@"NSDate 22222   %@",[NSDate date]);
    
}
- (void)createView{
    
    [_mytableView registerNib:[UINib nibWithNibName:@"watchTableViewCell" bundle:nil] forCellReuseIdentifier:@"watchTableViewCell"];
    
    [self setlayercornerRadius:_mytableView Radius:10];
    [self setlayercornerRadius:_enterBack Radius:10];
    
    [self setlayercornerRadius:_enterBU Radius:5];
    
    _SetWatchback.hidden=YES;
}
- (void)createData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_mytableView reloadData];
    
}
- (void)reloadData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_mytableView reloadData];
    
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
    
    watchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"watchTableViewCell"];
    
    if (cell == nil) {
        cell = [[watchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"watchTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WatchModel * watchMode = [_watchArry objectAtIndexWithSafety:indexPath.row];

    cell.watchName.text = [NSString stringWithFormat:@"%@",watchMode.watchNo];
    
    cell.mac.text = watchMode.watchMAC;
    
    [self setlayercornerRadius:cell.exChange Radius:5];
    
    cell.exChange.tag = 300+indexPath.row;
    
    [cell.exChange addTarget:self action:@selector(exChangeWatch:) forControlEvents:UIControlEventTouchUpInside];
    
     cell.conType.text = @"蓝牙未连接";
     cell.MyRSSI.text = @"0";
    
    for (LBWatchPerModel* watch in _scanArry) {
        
//        NSLog(@"%@   %@",watch.peripheral.name,watchMode.watchMAC);
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
                    
                default:
                    break;
            }
            
        }else{
            
           
            
        }
        
    }
    
    
    return cell;
    
}
- (IBAction)endsetTap:(id)sender {
    
    _SetWatchback.hidden=YES;
    [self.view endEditing:YES];
//    _macTf.text=@"";
    
}

- (IBAction)enSet:(id)sender {
    
    _SetWatchback.hidden=YES;
    [self.view endEditing:YES];
    _macTf.text=@"";
    
}

- (IBAction)UpdateSet:(id)sender {
    [self.view endEditing:YES];
        WatchModel * watchmode = [[LifeBitCoreDataManager shareInstance]efGetWatchModelBYwatchNo:[NSString stringWithFormat:@"%@", _watchNo]];
    
        WatchModel * NewWatchmodel = [[LifeBitCoreDataManager shareInstance]efCraterWatchModel];
    
        NewWatchmodel.watchMAC = _macTf.text;
        NewWatchmodel.watchNo = [NSNumber numberWithInteger: _watchNo.integerValue];
        NewWatchmodel.ipadIdentifying = watchmode.ipadIdentifying;
        NewWatchmodel.teacherId = watchmode.teacherId;
        NewWatchmodel.teachBoxId = watchmode.teachBoxId;
        NewWatchmodel.teachBoxName = watchmode.teachBoxName;
    
        [[LifeBitCoreDataManager shareInstance] efAddWatchModel:NewWatchmodel];
    
        [[LifeBitCoreDataManager shareInstance] efDeleteWatchModel:watchmode];

    _SetWatchback.hidden=YES;
    
}

- (IBAction)scanQR:(id)sender {
    [self.view endEditing:YES];
    scanViewController * scan = [[scanViewController alloc]init];

    scan.delegate =self;
    
    [self presentViewController:scan animated:YES completion:nil];
    
}


-(void)connWatch:(UIButton*)bu{
    
    
    
}
-(void)scanData:(NSString *)message{
    
    NSLog(@"message  %@",message);
    
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadRssi) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer2 forMode:NSRunLoopCommonModes];

    
    _macTf.text = message;
    
}
-(void)exChangeWatch:(UIButton*)bu{
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"手表管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重连手表",@"更换手表", nil];
    
    actionSheet.tag = 10000 + bu.tag-300;
    
    [actionSheet showInView:self.view];
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag/10000==1) {
        if (buttonIndex==0) {
            NSLog(@"1");
            WatchModel * watchmodel = [_watchArry objectAtIndexWithSafety:actionSheet.tag-10000];
            
            for (LBWatchPerModel* watch in _scanArry) {
                
                if ([watch.peripheral.name rangeOfString:watchmodel.watchMAC].length>0) {
                    
                    NSLog(@"watchmodel.peripheral.name  %@",watch.peripheral.name);
                    [[HJBluetootManager shareInstance]relongConnectWithWatch:watch];
                    
                }
            }
            [self showSuccessAlertWithTitleStr:@"正在连接手表"];
        }else if (buttonIndex==1){
            NSLog(@"2");
            
            MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
            
            
            if (TestModel.testID==NULL) {
                
                _SetWatchback.hidden=NO;
                
                WatchModel * watchModel = [_watchArry objectAtIndexWithSafety:actionSheet.tag-10000];
                
                _watchNo = watchModel.watchNo;
                
            }else{
                
                [self showErroAlertWithTitleStr:@"当前有未完成项目,无法进行手表管理"];
            }
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
