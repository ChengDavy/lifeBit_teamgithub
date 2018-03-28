//
//  addTeamViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/28.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "addTeamViewController.h"
#import "addTeamTableViewCell.h"

@interface addTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    
    NSMutableArray * _groupArry;
    
    CmemberModel * _memberModel;
    
    NSInteger  _selectButton;
    
    
    BOOL   _isAdd;
    
}
@end

@implementation addTeamViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    _addTeamerback.hidden=YES;
    
    
    [self createView];
    [self createData];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

}

- (void)createData{
    
    _isNew = [[_PushDict objectForKeyNotNull:@"isNew"] integerValue];
    
    _groupArry = [[NSMutableArray alloc]init];
    _memberModel = [[CmemberModel alloc]init];
    
    if (_isNew) {
        
#pragma mark 新建
        
        _groupmodel = [[CGroupModel alloc]init];
        
        _groupId = [NSString getStrArc4randomWithSize:10];
        
        _groupmodel.groupID = _groupId;
        
        _groupArry = [[[LifeBitCoreDataManager shareInstance] efGetSchoolAllMiTeamerWith:_groupId] mutableCopy];
        
        _BottLayout.constant= 790 - _groupArry.count * 59;
        
        [_myTableView reloadData];

    }else{
        
        _groupId = [_PushDict objectForKeyNotNull:@"groupID"];
        
        _Migroupmodel = [[LifeBitCoreDataManager shareInstance]efGetMiGroupModelGroupId:_groupId];
        
        _groupmodel = [CGroupModel  createCGroupModelWithMiGroupModel:_Migroupmodel];
        
        _teamName.text = _groupmodel.groupName;
        

        
        _sportName.text = _groupmodel.sportMode;
        
        _groupArry = [[[LifeBitCoreDataManager shareInstance] efGetSchoolAllMiTeamerWith:_groupId] mutableCopy];
        
        _BottLayout.constant= 790 - _groupArry.count * 59;
        
        [_myTableView reloadData];
        
#pragma mark 编辑
        
        NSLog(@"_PushDict   %@",_PushDict);
        //新增成员
        BOOL add = [[_PushDict objectForKeyNotNull:@"isAdd"] integerValue];
        
        BOOL change = [[_PushDict objectForKeyNotNull:@"isChange"] integerValue];
        
        if (add) {
            
            _isAdd = YES;
            
            _selectButton = 0;
            
            _addTeamerback.hidden=NO;
            
            _nameF.text = @"";
            _ageF.text = @"";
            _highF.text = @"";
            _weightF.text = @"";
            _nameF.text = @"";
            _nameF.text = @"";
            
            [self setWatchButton:YES];

            NSLog(@"添加队员");
            
        }
        
        if (change) {
            
            _isAdd = NO;
            

            MiTeamer * teamer = [[LifeBitCoreDataManager shareInstance] efGetMiTeamerteamerId:[_PushDict objectForKeyNotNull:@"teamerId"]];
            
            NSLog(@"teamer.teamerName  %@",teamer.teamerName);
            
            _addTeamerback.hidden=NO;
            
            _memberModel.teamerId = teamer.teamerId;
            _memberModel.teamerNo = [teamer.teamerNo integerValue];
            
            _nameF.text = teamer.teamerName;
            _ageF.text = teamer.teamerAge;
            _highF.text = teamer.teamerheight;
            _weightF.text = teamer.teamerWeight;
            
            [self setWatchButton:NO];
            
            NSLog(@"编辑队员");
    
        }


    }
    
    
}
- (void)setWatchButton:(BOOL)add{
    
    NSMutableArray * interArry = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"] mutableCopy];
    
    for (int k = 10; k< 22; k++) {
        
        UIButton * but = (UIButton *) [self.view viewWithTag:k] ;
        
        but.enabled = YES;
    }
    
    for (MiTeamer * teamer in _groupArry) {
    
        NSLog(@"teamer.teamerNo   %@    %@  ",teamer.teamerNo,teamer.teamerName);
        
        for (int i =0;i<interArry.count ;i++) {
            
            NSString * inter = [interArry objectAtIndexWithSafety:i];
            
            if ([inter integerValue] == teamer.teamerNo) {
                
                [interArry removeObject:inter];
            }
            
        }
            UIButton * but = (UIButton *) [self.view viewWithTag:[teamer.teamerNo integerValue] +9  ];
            
            but.enabled = NO;
  
    }
    
    if (add) {
        
        _selectButton = [[interArry objectAtIndexWithSafety:0] integerValue];
        
        _memberModel.teamerNo = [[interArry objectAtIndexWithSafety:0] integerValue];
        
    }
    
     _MyHeadPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"3.%ld",_memberModel.teamerNo]];
    
    
}
- (void)reloadTableView{
    
    _groupArry = [[[LifeBitCoreDataManager shareInstance] efGetSchoolAllMiTeamerWith:_groupId] mutableCopy];
    
    NSLog(@"%@    %@",_groupId   ,_groupArry);
    
    [_myTableView reloadData];
    
    _BottLayout.constant= 790 - _groupArry.count * 59;
    
}

- (void)createView{
    
    [self setlayercornerRadius:_seleBack Radius:5];
    [self setlayercornerRadius:_watchBac Radius:5];
    [self setlayercornerRadius:_addteamer Radius:5];
    [self setlayercornerRadius:_flashWatch Radius:5];
    [self setlayercornerRadius:_exchangback Radius:10];
    [self setlayercornerRadius:_addteamer Radius:5];
    [self setlayercornerRadius:_exchangeDone Radius:5];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"addTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"addTeamTableViewCell"];
    [self setlayercornerRadius:_backView Radius:10];
    
    _W1.tag = 0+10;
    _W2.tag = 1+10;
    _W3.tag = 2+10;
    _W4.tag = 3+10;
    _W5.tag = 4+10;
    _W6.tag = 5+10;
    _W7.tag = 6+10;
    _W8.tag = 7+10;
    _W9.tag = 8+10;
    _W10.tag = 9+10;
    _W11.tag = 10+10;
    _W12.tag = 11+10;
    
}
- (IBAction)sexSele:(id)sender {
    
    NSLog(@"numberOfSegments   %ld",_sexSele.selectedSegmentIndex);
    
}
- (IBAction)addteamBack:(id)sender {
    
    
}

- (IBAction)close:(id)sender {
    
     _addTeamerback.hidden=YES;
}
- (void)deleteTeamer:(UIButton*)button{
     MiTeamer * teamer = [_groupArry objectAtIndexWithSafety:button.tag-10000];
    
    UIAlertView * myalert = [[UIAlertView alloc]initWithTitle:@"提醒" message:[NSString stringWithFormat:@"确认删除%@号成员%@",teamer.teamerNo,teamer.teamerName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    myalert.tag = button.tag * 10;
    
    [myalert show];

}

- (void)changeTeamer:(UIButton*)button{
    _isAdd = NO;
    
    MiTeamer * teamer = [_groupArry objectAtIndexWithSafety:button.tag-1000];

    _addTeamerback.hidden=NO;
    
    _memberModel.teamerId = teamer.teamerId;
    _memberModel.teamerNo = [teamer.teamerNo integerValue];
    
    _nameF.text = teamer.teamerName;
    _ageF.text = teamer.teamerAge;
    _highF.text = teamer.teamerheight;
    _weightF.text = teamer.teamerWeight;

    NSLog(@"编辑队员");
    
    [self setWatchButton:NO];
    
}

- (IBAction)addTeamer:(id)sender {
    
    
    if (_groupArry.count>11) {
        [self showErroAlertWithTitleStr:@"团队成员已满12人,无法添加"];
        return;
    }
    
    _isAdd = YES;
    
    _addTeamerback.hidden=NO;
    
    _nameF.text = @"";
    _ageF.text = @"";
    _highF.text = @"";
    _weightF.text = @"";
    _nameF.text = @"";
    _nameF.text = @"";
    
    NSLog(@"添加队员");
    
    [self setWatchButton:YES];
    
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 确认添加 修改
- (IBAction)upData:(id)sender {
    
    if (_isNew) {
        
    if (_teamName.text.length<1) {
        [self showErroAlertWithTitleStr:@"请输入团队名称"];
        return;
    }
    if (_sportName.text.length<1) {
        [self showErroAlertWithTitleStr:@"请选择运动模式"];
        return;
    }
    
        _groupmodel.groupID = _groupId;
        _groupmodel.groupName = _teamName.text;
        _groupmodel.createTime = [NSDate date];
        _groupmodel.createDeful = nil ;
        _groupmodel.sportMode = _sportName.text;
        _groupmodel.groupCreater = [HJUserManager shareInstance].user.pId;
        
        
        MiGroupModel * groupDataM = [CGroupModel createGroupModelWithCGroupModel:_groupmodel];
        
        if ([[LifeBitCoreDataManager shareInstance]efAddMiGroupModel:groupDataM]) {
             NSLog(@"创建成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:KAddGroupSuccess object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self showErroAlertWithTitleStr:@"创建失败"];
        }
        

    NSLog(@"提交修改");
    
    }else{
        
        if (_teamName.text.length<1) {
            [self showErroAlertWithTitleStr:@"请输入团队名称"];
            return;
        }
        if (_sportName.text.length<1) {
            [self showErroAlertWithTitleStr:@"请选择运动模式"];
            return;
        }
        MiGroupModel * groupDataM = [[LifeBitCoreDataManager shareInstance]efGetMiGroupModelGroupId:_groupId];
        
        groupDataM.groupID = _groupId;
        groupDataM.groupName = _teamName.text;
        groupDataM.createTime = [NSDate date];
        groupDataM.createDeful = nil ;
        groupDataM.sportMode = _sportName.text;
        groupDataM.groupCreater = [HJUserManager shareInstance].user.pId;
        
        NSLog(@"MiGroupModel %@   %@    %@",groupDataM.groupID,groupDataM.groupName,groupDataM.groupCreater);
        
        if ([[LifeBitCoreDataManager shareInstance]efUpdateMiGroupModel:groupDataM]) {
            NSLog(@"创建成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:KAddGroupSuccess object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self showErroAlertWithTitleStr:@"创建失败"];
        }
        
        
        NSLog(@"提交修改");
        
    }
//    _addTeamerback.hidden=YES;
    
}
#pragma mark - 选择运动模式
- (IBAction)choiceSportmode:(id)sender {
    
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"选择运动模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"普通运动",@"上肢运动", nil];
    action.tag = 1111;
    [action showInView:self.view];
}


#pragma mark 选择手表

- (IBAction)Watchsele1:(id)sender {
    
    _MyHeadPic.image = [UIImage imageNamed:@"3.1"];
    _memberModel.teamerNo = 1;
//    _W1.highlighted=YES;
    _W2.selected=YES;
    
//    _W1.enabled = NO;
    
    
}
- (IBAction)Watchsele2:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.2"];

    
    _memberModel.teamerNo = 2;

    _W2.selected=YES;
}
- (IBAction)Watchsele3:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.3"];

    _memberModel.teamerNo = 3;
}
- (IBAction)Watchsele4:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.4"];

    _memberModel.teamerNo = 4;
}
- (IBAction)Watchsele5:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.5"];

    _memberModel.teamerNo = 5;
}
- (IBAction)Watchsele6:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.6"];

    _memberModel.teamerNo = 6;
}
- (IBAction)Watchsele7:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.7"];

    _memberModel.teamerNo = 7;
}
- (IBAction)Watchsele8:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.8"];

    _memberModel.teamerNo = 8;
}
- (IBAction)Watchsele9:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.9"];

    _memberModel.teamerNo = 9;
}
- (IBAction)Watchsele10:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.10"];

    _memberModel.teamerNo = 10;
}
- (IBAction)Watchsele11:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.11"];

    _memberModel.teamerNo = 11;
}
- (IBAction)Watchsele12:(id)sender {
    _MyHeadPic.image = [UIImage imageNamed:@"3.12"];

    _memberModel.teamerNo = 12;
}



- (IBAction)exchangeDone:(id)sender {

    
        if (_isAdd) {
      
        _memberModel.teamerId = [NSString getStrArc4randomWithSize:9];
        _memberModel.teamerAge = _ageF.text;
            
          
        _memberModel.teamerNo = _selectButton;

            
        _memberModel.teamerPic = [NSString stringWithFormat:@"%ld", _memberModel.teamerNo ] ;
        _memberModel.teamerSex = [NSString stringWithFormat:@"%ld",_sexSele.selectedSegmentIndex];
        _memberModel.teamerGroupId = _groupId;
        _memberModel.teamerName = _nameF.text;
        _memberModel.teamerheight = _highF.text;
        _memberModel.teamerWeight = _weightF.text;
        
        
        MiTeamer * teamber = [CmemberModel createMiTeamerWithCmemberModel:_memberModel];
        
        if ([[LifeBitCoreDataManager shareInstance]efAddMiTeamer:teamber] ) {
            NSLog(@"添加成功");
            
            _addTeamerback.hidden=YES;
            
            [self reloadTableView];
            
        }else{
             NSLog(@"添加失败");
        }
        
    
        }else{
            
            MiTeamer * teamber = [[LifeBitCoreDataManager shareInstance]efGetMiTeamerteamerId:_memberModel.teamerId];

            teamber.teamerAge = _ageF.text;
            teamber.teamerNo = [NSNumber numberWithInteger: _memberModel.teamerNo];
            teamber.teamerPic = _memberModel.teamerPic;
            teamber.teamerSex = [NSString stringWithFormat:@"%ld",_sexSele.selectedSegmentIndex];
            teamber.teamerGroupId = _groupId;
            teamber.teamerName = _nameF.text;
            teamber.teamerheight = _highF.text;
            teamber.teamerWeight = _weightF.text;
        
            if ([[LifeBitCoreDataManager shareInstance]efUpdateMiTeamer:teamber] ) {
                NSLog(@"修改成功");
                
                _addTeamerback.hidden=YES;
                
                [self reloadTableView];
                
            }else{
                NSLog(@"修改失败");
            }
  
        }
//    }
  
}

//TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _groupArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addTeamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addTeamTableViewCell"];
    if (cell==nil) {
        cell = [[addTeamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTeamTableViewCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [self setlayercornerRadius:cell.backView Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    [self setlayercornerRadius:cell.changeB Radius:5];
    [self setlayercornerRadius:cell.deleteB Radius:5];
    
    MiTeamer * teamer = [_groupArry objectAtIndexWithSafety:indexPath.row];
    
    cell.name.text = teamer.teamerName;
    cell.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
    
    cell.changeB.tag = 1000 + indexPath.row;
    
    [cell.changeB addTarget:self action:@selector(changeTeamer:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleteB.tag = 10000 + indexPath.row;
    
    [cell.deleteB addTarget:self action:@selector(deleteTeamer:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTap:(id)sender {
    
     [self.view endEditing:NO];
}
- (IBAction)addTap2:(id)sender {
    
    [self.view endEditing:NO];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:NO];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else if(buttonIndex==1){
        NSInteger integer = alertView.tag/10-10000;
        MiTeamer * teamer = [_groupArry objectAtIndexWithSafety:integer];
        
        if ( [[LifeBitCoreDataManager shareInstance]efDeleteMiTeamer:teamer]) {
            
            [self reloadTableView];
            
        }
    }
}
#pragma mark - 运动模式选定
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (actionSheet.tag == 1111) {
        if (buttonIndex==0) {
            _sportName.text = @"普通运动";
            
        }else if (buttonIndex==1){
            
            _sportName.text = @"上肢运动";
            
        }
    }
    
    
    
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
