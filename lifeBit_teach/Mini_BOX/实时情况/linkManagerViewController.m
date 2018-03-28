//
//  linkManagerViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/23.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "linkManagerViewController.h"
#import "watchTableViewCell.h"

@interface linkManagerViewController ()<UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate>{
    NSMutableArray * _watchArry;
    
    NSMutableArray * _scanArry;
    
    NSTimer * _timer;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@end

@implementation linkManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _watchArry = [[NSMutableArray alloc]init];
    _scanArry = [[NSMutableArray alloc]init];
    
    [self createView];
    [self createData];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)reloadRssi{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_myTableview reloadData];
    
}
- (void)createView{
    
    [_myTableview registerNib:[UINib nibWithNibName:@"watchTableViewCell" bundle:nil] forCellReuseIdentifier:@"watchTableViewCell"];
    
    [self setlayercornerRadius:_myTableview Radius:10];
    
}
- (void)createData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_myTableview reloadData];
    
}
- (void)reloadData{
    
    _watchArry = [[[LifeBitCoreDataManager shareInstance]efGetAllWatchModel] mutableCopy];
    
    _scanArry = [[HJBluetootManager shareInstance].blueTools.scanWatchArray mutableCopy];
    
    [_myTableview reloadData];
    
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
    
    cell.watchName.text = [NSString stringWithFormat:@"%@", watchMode.watchNo];
    
    cell.mac.text = watchMode.watchMAC;
    
    [self setlayercornerRadius:cell.exChange Radius:5];
    
    cell.exChange.tag = 300+indexPath.row;
    
//    [cell.exChange addTarget:self action:@selector(exChangeWatch:) forControlEvents:UIControlEventTouchUpInside];
    
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
            
        }
        
    }
    
    
    return cell;
    
}

-(void)connWatch:(UIButton*)bu{
    
    NSLog(@"重连%ld",bu.tag);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
