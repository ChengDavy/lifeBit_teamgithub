//
//  MiNiRealViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiRealViewController.h"
#import "MiNiRealCollectionViewCell.h"
#import "RealDeViewController.h"
#import "classNoteViewController.h"
#import "MiTeamerViewController.h"
#import "linkManagerViewController.h"
#import "WatchManagerViewController.h"
@interface MiNiRealViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    CTestModel * _cTestModel;
    CHistoryTestModel * _cHistoryTestModel;
    NSMutableArray * _testArry;
    NSString * _testId;
    BOOL       _isDemo;
    
    NSMutableArray * _watchArry;
}

@end

@implementation MiNiRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    _watchArry = [[NSMutableArray alloc]init];
    
    [self createView];
    [self createData];

    
//    
     [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(getHeart:) name:KAddTestSuccess object:nil];

    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reFlashData:) name:KHoldTestSuccess object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTimePoint:) name:KPostTime object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self reFlashData:nil];
}
- (void)getTimePoint:(NSNotification*)not{
    
    NSDictionary * postDic = not.object;
    
    int timeRun = [[postDic objectForKeyNotNull:@"overTime"] intValue];
    
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
    
    _timeRun.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    
    if (tmpss.integerValue%2==0) {
        
        [self getHeart:nil];
    }
    
    
}
- (void)getHeart:(NSNotification * )not{
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    
    if (TestModel.testID==NULL) {
        
        MiHistoryTestModel * HistoryModel=[[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:kMiDemoModelID];
        
        _cHistoryTestModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:HistoryModel];
        _isDemo =YES;
        _testId = _cHistoryTestModel.testID;
        [self loadData];
        
        _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:kMiDemoModelID] mutableCopy];
        
        [_myCollectionView reloadData];
        
    }else{
        _isDemo = NO;
    
    _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
    _testId = _cTestModel.testID;
    
    [self loadData];
    
    _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId] mutableCopy];
    
    
    [_myCollectionView reloadData];
    }
}


- (void)createData{
    
    _testArry = [[NSMutableArray alloc]init];
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
    
    if (TestModel.testID==NULL) {
        
        MiHistoryTestModel * HistoryModel=[[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:kMiDemoModelID];
        
        _cHistoryTestModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:HistoryModel];
        _isDemo =YES;
        _testId = _cHistoryTestModel.testID;
        
        [self loadData];
        
        _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:kMiDemoModelID] mutableCopy];
        
        [_myCollectionView reloadData];
        
    }else{
        
        _isDemo = NO;
    
    
    _testId = _cTestModel.testID;

    [self loadData];
    
    _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId] mutableCopy];
    
    
    [_myCollectionView reloadData];
        
    }
    
}

- (void)loadData{
    
    if (_isDemo) {
        
        _groupName.text = [NSString stringWithFormat:@"%@",_cHistoryTestModel.testTittle];
        _date.text = _cHistoryTestModel.testBeginTime;
        _sportMode.text = _cHistoryTestModel.sportMode;
        _timeRun.text = [NSString getTimeFromSecondStr:_cHistoryTestModel.testTimeLong];
        _heart.text = _cHistoryTestModel.avsHeart;
//        _heart.text = _cHistoryTestModel.maxHeart;
        _step.text = _cHistoryTestModel.avsStep;
        
        _sportHi.text = [NSString stringWithFormat:@"%@%%",_cHistoryTestModel.sportQD];
        
    }else{
    
    _groupName.text = [NSString stringWithFormat:@"%@-%@",_cTestModel.groupName,_cTestModel.testTittle];
    _date.text = _cTestModel.testBeginTime;
    _sportMode.text = _cTestModel.sportMode;
//    _timeRun.text = _cTestModel.testTimeLong;
    _heart.text = _cTestModel.avsHeart;
//    _heart.text = _cTestModel.maxHeart;
    _step.text = _cTestModel.avsStep;
    
    _sportHi.text = [NSString stringWithFormat:@"%@%%",_cTestModel.sportQD];
    }

    
}

- (void)reFlashData:(NSNotification * )not{
    
    [self getHeart:nil];
}
-(void)createView{
    [self setlayercornerRadius:_groupBack Radius:5];
    [self setlayercornerRadius:_groupBack2 Radius:5];
    [self setlayercornerRadius:_endBU Radius:5];
    [self setlayercornerRadius:_linkButton Radius:5];
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"MiNiRealCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MiNiRealCollectionViewCell"];
    
}
- (IBAction)EnterDetail:(id)sender {
    RealDeViewController * realDe = [[RealDeViewController alloc]init];
    [self.navigationController presentViewController:realDe animated:YES completion:nil];
    
    
}
- (IBAction)classEdit:(id)sender {
//    
    classNoteViewController * realDe = [[classNoteViewController alloc]init];
    
    NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
    
    [pushDict setObject:_testId forKey:@"testID"];
    if (_isDemo) {
        [pushDict setObject:@"1" forKey:@"isDemo"];
    }else{
        [pushDict setObject:@"0" forKey:@"isDemo"];
    }
    
    realDe.pushDict = pushDict;
    
    [self.navigationController presentViewController:realDe animated:YES completion:nil];
    
//    [self scan];

    NSLog(@"课中备注");
    
}

- (IBAction)endClass:(id)sender {
    
    
    if (_isDemo) {
        
        [self showErroAlertWithTitleStr:@"示例测试项目,仅供参考"];
        
    }else{
    
    UIAlertView * endAl = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"你将提前结束本节课程,是否确认提前结束" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"取消",@"确认", nil];
    
    endAl.tag = 111;
    [endAl show];
        
    }
    
    NSLog(@"结束课程");
}

//链接管理
- (IBAction)linkManager:(id)sender {
    
    if (_isDemo) {
        
        [self showErroAlertWithTitleStr:@"示例测试项目,仅供参考"];
        
    }else{
        
        if ([HJBluetootManager shareInstance].blueTools.scanWatchArray.count>11) {
            
            UIAlertView * endAl = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确认重连所有手表,该操作将会重连所有手表,单个手表链接可进入测试详情进行重连" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"取消",@"确认", nil];
            
            endAl.tag = 222;
            [endAl show];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"手表未能全部链接,现在重连将会影响测试效果,请检查手表链接状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续重连",@"手表管理", nil];
            alert.tag = 55555;
            [alert show];
        }
    }
    
    NSLog(@"重连");
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MiNiRealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MiNiRealCollectionViewCell" forIndexPath:indexPath];
    
    [self setlayercornerRadius:cell.backView Radius:5];
   
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row<_testArry.count) {
        
        MiUserTestModel * testModel = [_testArry objectAtIndexWithSafety:indexPath.row];
    
        cell.nameLa.text = [NSString stringWithFormat:@"%@号-%@",testModel.teamerNo,testModel.teamerName];
        cell.heart.text = testModel.heart;
        cell.step.text = testModel.step;
        
        cell.sportH.text = [NSString stringWithFormat:@"%@%%",testModel.sportQD];
        
        NSInteger sportQ = testModel.sportQD.integerValue;
        
        if (sportQ>=90) {
            cell.backView.backgroundColor = UIColorFromRGB(0xb13760);
        }else if (sportQ>=80){
            cell.backView.backgroundColor = UIColorFromRGB(0xc08c42);
        }else if (sportQ>=70){
            cell.backView.backgroundColor = UIColorFromRGB(0x8a9e57);
        }else if (sportQ>=60){
            cell.backView.backgroundColor = UIColorFromRGB(0x5ea6b4);
        }else{
            cell.backView.backgroundColor = UIColorFromRGB(0xa0a4a5);
        }
        

    }else{
    cell.backView.backgroundColor = UIColorFromRGB(0xa0a4a5);
    }
    
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(315, 108);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<_testArry.count) {
        
        MiUserTestModel * testModel = [_testArry objectAtIndexWithSafety:indexPath.row];
        
        MiTeamerViewController * TeamerView = [[MiTeamerViewController alloc]init];
        
        NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
        
        [pushDict setObject:testModel.testID forKey:@"testID"];
        
        [pushDict setObject:testModel.teamerId forKey:@"teamerId"];
        
        [pushDict setObject:@"0" forKey:@"isHistory"];

        TeamerView.pushDict = pushDict;
        
        if ([_testId isEqualToString:kMiDemoModelID]) {
            TeamerView.ShowType = teamerShowDemoType;
        }else{
            TeamerView.ShowType = teamerShowTestType;
        }
        
        [self presentViewController:TeamerView animated:YES completion:nil];
        
    }else{
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//}
//同步时间
-(void)syncRealTimeWithWatch:(LBWatchPerModel*)watch{
    [watch syncRealTimeWithSuccess:^(NSObject *anyObj) {
        
        
        
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        
        [[HJBluetootManager shareInstance].blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex==0) {
            NSLog(@"0");
            
        }else if(buttonIndex==1){
            
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
                [[NSNotificationCenter defaultCenter]postNotificationName:KAddTestSuccess object:nil];
                
            };
        }
    }
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
   
    if (alertView.tag == 222) {
        if (buttonIndex==0) {
            NSLog(@"0");
            
        }else if(buttonIndex==1){
            
            [[MiRunWatchManager shareInstance]reStartTest];
            
        }
    }
    if (alertView.tag == 55555) {
        if (buttonIndex==0) {
            
            NSLog(@"0");
            UIAlertView * endAl = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确认重连所有手表,该操作将会重连所有手表,单个手表链接可进入测试详情进行重连" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"取消",@"确认", nil];
            
            endAl.tag = 222;
            [endAl show];

            
        }else if(buttonIndex==1){
            
            WatchManagerViewController *  WatchManager = [[WatchManagerViewController alloc]init];
            
            [self presentViewController:WatchManager animated:YES completion:nil];
    
        }
    }
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
