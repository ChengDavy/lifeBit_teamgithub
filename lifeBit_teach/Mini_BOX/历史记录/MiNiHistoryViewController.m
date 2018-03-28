//
//  MiNiHistoryViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiHistoryViewController.h"
#import "MiNiHisTableViewCell.h"
#import "SearchHisViewController.h"
#import "DetailsViewController.h"

@interface MiNiHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * _TestArry;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (weak, nonatomic) IBOutlet UIView *searchBack;

@end

@implementation MiNiHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reFlashData:) name:KAddTestSuccess object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reFlashData:) name:KHoldTestSuccess object:nil];
     [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reFlashData:) name:KDeleteTestSuccess object:nil];
    
    [self createView];
    [self createData];
}
#pragma mark 加载数据
- (void)createData{
    
    _TestArry = [[NSMutableArray alloc]init];
    _TestArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiHistoryTestModel] mutableCopy];
    
    [_myTableview reloadData];
    
  
}
- (void)reFlashData:(NSNotification * )not{
    
    _TestArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiHistoryTestModel] mutableCopy];
    
    [_myTableview reloadData];
    
}
#pragma mark 加载页面
- (void)createView{

    [self setlayercornerRadius:_searchBack Radius:10];
    [_myTableview registerNib:[UINib nibWithNibName:@"MiNiHisTableViewCell" bundle:nil] forCellReuseIdentifier:@"MiNiHisTableViewCell"];
    
}
#pragma mark 跳转搜索
- (IBAction)searchHistory:(id)sender {
    SearchHisViewController * searchVc = [[SearchHisViewController alloc]init ];
    
    [self.navigationController presentViewController:searchVc animated:YES completion:nil];
    
}

//tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _TestArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiNiHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MiNiHisTableViewCell"];
    if (cell == nil) {
        cell = [[MiNiHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MiNiHisTableViewCell"];
    }
    [self setlayercornerRadius:cell.backView Radius:10];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor = UIColorFromRGB(0xEBEBF1);
    
    MiHistoryTestModel * MiHistory = [_TestArry objectAtIndexWithSafety:indexPath.row];
    
    CHistoryTestModel * ChistoryModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:MiHistory];
  
    NSLog(@"ChistoryModel.testTittle %@",ChistoryModel.testTittle);
    
    cell.teamName.text = [NSString stringWithFormat:@"%@-%@",ChistoryModel.groupName,ChistoryModel.testTittle];
    
    cell.sportTime.text = [NSString getTimeFromSecondStr: ChistoryModel.testTimeLong];
    
    cell.dateLa.text = ChistoryModel.testBeginTime;
    cell.sportMode.text = ChistoryModel.sportMode;
    cell.avsStep.text = ChistoryModel.avsStep;
    cell.avsHeart.text = ChistoryModel.avsHeart;
    cell.maxHeart.text = ChistoryModel.maxHeart;
    cell.sportMD.text = [NSString stringWithFormat:@"%@%%",ChistoryModel.sportMD];
    cell.sportQD.text = [NSString stringWithFormat:@"%@%%",ChistoryModel.sportQD];
    cell.calorie.text = ChistoryModel.avscalorie;

    return  cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsViewController * detailsVc = [[DetailsViewController alloc]init];
    
    MiHistoryTestModel * MiHistory = [_TestArry objectAtIndexWithSafety:indexPath.row];
    
    CHistoryTestModel * ChistoryModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:MiHistory];
    

    NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
    
    [pushDict setObject:ChistoryModel.testID forKey:@"testID"];
    
    detailsVc .PushDict = pushDict;
    [self.navigationController presentViewController:detailsVc animated:YES completion:nil];
    
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
