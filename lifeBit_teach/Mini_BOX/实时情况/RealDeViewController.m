//
//  RealDeViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/29.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "RealDeViewController.h"
#import "RealDeCollectionViewCell.h"
#import "MiTeamerViewController.h"

@interface RealDeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDataSourcePrefetching,UIAlertViewDelegate>
{
    CTestModel * _cTestModel;
    CHistoryTestModel * _cHistoryTestModel;
    BOOL       _isDemo;
    NSMutableArray * _testArry;
    NSString * _testId;
}


@end

@implementation RealDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testArry = [[NSMutableArray alloc]init];
    
    [self createView];
    [self createData];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(getHeart:) name:KAddTestSuccess object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeart:) name:@"heartMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTimePoint:) name:KPostTime object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self getHeart: nil];
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
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
    
    [_myCollectionView reloadData];
    }
    
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
    if (tmpss.integerValue%2==0) {
        
        [self getHeart:nil];
    }
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    _timerun.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    
}

- (void)createView{
    [self setlayercornerRadius:_endBu Radius:5];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"RealDeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RealDeCollectionViewCell"];
    
}
- (void)createData{

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
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
    
    [_myCollectionView reloadData];
    }
    
}
- (void)loadData{
    
    
}
- (void)reFlashData:(NSNotification * )not{
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
    _testId = _cTestModel.testID;
    
    [self loadData];
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
    
    [_myCollectionView reloadData];
    
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)endClass:(id)sender {
    
    if (_isDemo) {
        
        [self showErroAlertWithTitleStr:@"示例测试项目,仅供参考"];
        
    }else{
    UIAlertView * endAl = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"你将提前结束本节课程,是否确认提前结束" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"取消",@"确认", nil];
    
    endAl.tag = 111;
    [endAl show];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 12;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RealDeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RealDeCollectionViewCell" forIndexPath:indexPath];
    
    [self setlayercornerRadius:cell.backView Radius:8];
    
    if (indexPath.row<_testArry.count) {
        MiUserTestModel * testModel = [_testArry objectAtIndexWithSafety:indexPath.row];
        
        cell.nameLa.text = testModel.teamerName;
        cell.heart.text = testModel.heart;
        cell.step.text = testModel.step;
        cell.sportQD.text = [NSString stringWithFormat:@"%@%%",testModel.sportQD];
        
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
    
    return CGSizeMake(238 , 212);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
            TeamerView.ShowType = teamerShowHistoryType;
        }
        
        [self presentViewController:TeamerView animated:YES completion:nil];
        
    }else{
        
        
        
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
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
                [[NSNotificationCenter defaultCenter]postNotificationName:KAddTestSuccess object:nil];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            };

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
