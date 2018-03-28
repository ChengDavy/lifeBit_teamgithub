//
//  SearchHisViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/25.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "SearchHisViewController.h"
#import "SearchHisTableViewCell.h"
#import "DetailsViewController.h"


@interface SearchHisViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UISearchBarDelegate>{
    NSMutableArray * _TestArry;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBu;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SearchHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self createData];
    // Do any additional setup after loading the view from its nib.
}
- (void)createData{
    
    _TestArry = [[NSMutableArray alloc]init];
    _TestArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiHistoryTestModel] mutableCopy];
    
    [_myTableView reloadData];
    
    
}

- (void)createView{
    
    [_myTableView registerNib:[UINib nibWithNibName:@"SearchHisTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchHisTableViewCell"];
    
}
- (IBAction)searchmode:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"检索类型" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:@"时间",@"团队",@"项目名", nil];
    actionSheet.tag = 999;
    [actionSheet showInView:self.view];
    
}
#pragma mark - 搜索框代理

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"%@  %@     %@  ",searchText,searchBar.text,_searchBar.text);
    
    _TestArry = [[[LifeBitCoreDataManager shareInstance] efSearchSchoolAllMiHistoryTestModelWith:_searchBar.text] mutableCopy];
    
    [_myTableView reloadData];
    
}


#pragma mark - tableView  代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _TestArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHisTableViewCell"];
    if (cell == nil) {
        cell = [[SearchHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchHisTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setlayercornerRadius:cell.backView Radius:10];
    
    MiHistoryTestModel * MiHistory = [_TestArry objectAtIndexWithSafety:indexPath.row];
    
    CHistoryTestModel * ChistoryModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:MiHistory];
    
    NSLog(@"ChistoryModel.testTittle %@",ChistoryModel.testTittle);
    
    cell.teamName.text = [NSString stringWithFormat:@"%@-%@",ChistoryModel.groupName,ChistoryModel.testTittle];
//    cell.sportTime.text = ChistoryModel.testBeginTime;
    
     cell.sportTime.text = [NSString getTimeFromSecondStr: ChistoryModel.testTimeLong];
    
    cell.dateLa.text = ChistoryModel.testBeginTime;
    cell.sportMode.text = ChistoryModel.sportMode;
    cell.avsStep.text = ChistoryModel.avsStep;
    cell.avsHeart.text = ChistoryModel.avsHeart;
    cell.maxHeart.text = ChistoryModel.maxHeart;
    cell.sportMD.text = [NSString stringWithFormat:@"%@%%",ChistoryModel.sportMD];
    cell.sportQD.text = [NSString stringWithFormat:@"%@%%",ChistoryModel.sportQD];
    cell.calorie.text = ChistoryModel.avscalorie;
    
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsViewController * detailsVc = [[DetailsViewController alloc]init];
    
    MiHistoryTestModel * MiHistory = [_TestArry objectAtIndexWithSafety:indexPath.row];
    
    CHistoryTestModel * ChistoryModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:MiHistory];
    
    
    NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
    
    [pushDict setObject:ChistoryModel.testID forKey:@"testID"];
    
    detailsVc .PushDict = pushDict;

    [self presentViewController:detailsVc animated:YES completion:nil];
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==999) {
        if (buttonIndex==0) {
            NSLog(@"时间");
        }else if (buttonIndex==1){
            NSLog(@"团队");
        }
        else if (buttonIndex==2){
            NSLog(@"项目名");
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
