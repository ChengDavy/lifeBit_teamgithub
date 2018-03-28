//
//  MiNiSportsStViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiSportsStViewController.h"
#import "STTableViewCell.h"
#import "MiTeamerViewController.h"

@interface MiNiSportsStViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CTestModel * _cTestModel;
    CHistoryTestModel * _cHistoryTestModel;
    NSMutableArray * _testArry;
    NSString * _testId;
    BOOL   _isDemo;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (weak, nonatomic) IBOutlet UIView *headBack;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *sportModel;
@property (weak, nonatomic) IBOutlet UILabel *timeRun;
@property (weak, nonatomic) IBOutlet UILabel *avsHeart;
@property (weak, nonatomic) IBOutlet UILabel *maxheart;
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UILabel *calore;
@property (weak, nonatomic) IBOutlet UILabel *sportMD;
@property (weak, nonatomic) IBOutlet UILabel *sportQD;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btom;

@end

@implementation MiNiSportsStViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
    
    [self createView];
    [self createData];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reFlashData:) name:KAddTestSuccess object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTimePoint:) name:KPostTime object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getHeart:nil];
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
    
    if (tmpss.integerValue %2==0) {
        
        [self reFlashData:nil];
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
        
        _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:kMiDemoModelID];
        
        _btom.constant = 810 - 60* _testArry.count;
        
        [_myTableview reloadData];
        
    }else{
        _isDemo =NO;
        _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
        _testId = _cTestModel.testID;
        
        [self loadData];
        
        _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
        
        _btom.constant = 810 - 60* _testArry.count;
        
        [_myTableview reloadData];
    }

}

- (void)createData{
    
    _testArry = [[NSMutableArray alloc]init];
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    
    if (TestModel.testID==NULL) {
        
        MiHistoryTestModel * HistoryModel=[[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:kMiDemoModelID];
        
        _cHistoryTestModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:HistoryModel];
        _isDemo =YES;
        _testId = _cHistoryTestModel.testID;
        [self loadData];
        
        _testArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:kMiDemoModelID] mutableCopy];
        
        _btom.constant = 810 - 60* _testArry.count;
        
        [_myTableview reloadData];
   
    }else{
    _isDemo =NO;
    _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
    _testId = _cTestModel.testID;
    
    [self loadData];
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
     _btom.constant = 810 - 60* _testArry.count;
    
    [_myTableview reloadData];
    }
    
}
- (void)loadData{
    
    if (_isDemo) {
        
        _teamName.text = [NSString stringWithFormat:@"%@",_cHistoryTestModel.testTittle];
        _dateLable.text = _cHistoryTestModel.testBeginTime;
        _sportModel.text = _cHistoryTestModel.sportMode;
        _timeRun.text = [NSString getTimeFromSecondStr:_cHistoryTestModel.testTimeLong];
         _calore.text = _cHistoryTestModel.avscalorie;
        _avsHeart.text = _cHistoryTestModel.avsHeart;
        _maxheart.text = _cHistoryTestModel.maxHeart;
        _step.text = _cHistoryTestModel.avsStep;
        
        _sportQD.text = [NSString stringWithFormat:@"%@%%",_cHistoryTestModel.sportQD];
        
        _sportMD.text = [NSString stringWithFormat:@"%@%%",_cHistoryTestModel.sportMD];
        
    }else{
    
    _teamName.text = [NSString stringWithFormat:@"%@-%@",_cTestModel.groupName,_cTestModel.testTittle];
    _dateLable.text = _cTestModel.testBeginTime;
    _sportModel.text = _cTestModel.sportMode;
    _calore.text = _cTestModel.avscalorie;
    _avsHeart.text = _cTestModel.avsHeart;
    _maxheart.text = _cTestModel.maxHeart;
    _step.text = _cTestModel.avsStep;
    
    _sportQD.text = [NSString stringWithFormat:@"%@%%",_cTestModel.sportQD];
    _sportMD.text = [NSString stringWithFormat:@"%@%%",_cTestModel.sportMD];
    }
    
}
- (void)reFlashData:(NSNotification * )not{
    
    MiTestModel * TestModel = [[LifeBitCoreDataManager shareInstance] efGetMiTestModelTestModelId:@""];
    _cTestModel = [CTestModel createCTestModelWithMiTestModel:TestModel];
    _testId = _cTestModel.testID;
    
    [self loadData];
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
    [_myTableview reloadData];
    
}

- (void)createView{
    [self setlayercornerRadius:_headBack Radius:10];
    [self setlayercornerRadius:_myTableview Radius:10];
    [_myTableview registerNib:[UINib nibWithNibName:@"STTableViewCell" bundle:nil] forCellReuseIdentifier:@"STTableViewCell"];
}
//TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _testArry.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
    STTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"STTableViewCell"];
    
    if (cell==nil) {
        
        cell = [[STTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STTableViewCell"];
    }
    
    MiUserTestModel * testModel = [_testArry objectAtIndexWithSafety:indexPath.row];
    
    cell.teamName.text =testModel.teamerName;
    cell.heartAv.text =testModel.avsHeart;
    cell.heartMax.text =testModel.maxHeart;
    cell.step.text =testModel.step;
    cell.calor.text =testModel.calorie;
    cell.sportMD.text = [NSString stringWithFormat:@"%@%%",testModel.sportMD];
    cell.sportQD.text = [NSString stringWithFormat:@"%@%%",testModel.sportQD];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",indexPath.row);
    
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
