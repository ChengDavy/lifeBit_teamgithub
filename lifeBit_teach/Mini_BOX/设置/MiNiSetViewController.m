//
//  MiNiSetViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiSetViewController.h"
#import "MiNiSetTableViewCell.h"
#import "addTeamViewController.h"

@interface MiNiSetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray * _groupArry;
    NSMutableArray * _groupMemberArry;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MiNiSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self createView];
    [self createData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerAdd:) name:KAddGroupSuccess object:nil];
    // Do any additional setup after loading the view from its nib.
}

//监听添加群组
- (void)observerAdd:(NSNotification *)notification{
    
    _groupArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiGroupModel] mutableCopy];
    
    NSLog(@"_groupArry   %@",_groupArry);
    _groupMemberArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMemberWithMiGroupModelArry:_groupArry] mutableCopy] ;
    
    for (MiGroupModel * groupModel in _groupArry) {
        
        NSLog(@"groupModel.groupID   %@",groupModel.groupID);
        
        NSMutableArray * teamerArry = [[LifeBitCoreDataManager shareInstance] efGetSchoolAllMiTeamerWith:groupModel.groupID];
        
        [_groupMemberArry addObject:teamerArry];
        
        [_myTableView reloadData];
    }


    [_myTableView reloadData];
}

//加载数据
- (void)createData{
    
    _groupArry = [[NSMutableArray alloc]init];
    
    _groupMemberArry = [[NSMutableArray alloc]init];
    
    _groupArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMiGroupModel] mutableCopy];
    
    _groupMemberArry = [[[LifeBitCoreDataManager shareInstance]efGetAllMemberWithMiGroupModelArry:_groupArry] mutableCopy] ;
    
    for (MiGroupModel * groupModel in _groupArry) {
        
        NSLog(@"groupModel.groupID   %@",groupModel.groupID);
        
        NSMutableArray * teamerArry = [[LifeBitCoreDataManager shareInstance] efGetSchoolAllMiTeamerWith:groupModel.groupID];
        
        [_groupMemberArry addObject:teamerArry];
        
        [_myTableView reloadData];
    }

    [_myTableView reloadData];
    
}

- (void)createView{
    
    [_myTableView registerNib:[UINib nibWithNibName:@"MiNiSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"MiNiSetTableViewCell"];
}

#pragma mark - 新建群组
- (IBAction)addTeam:(id)sender {
    
    addTeamViewController * addTeam = [[addTeamViewController alloc]init];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"1" forKey:@"isNew"];
//    [dict setObject:groupModel.groupID forKey:@"groupID"];
    
    addTeam.PushDict = dict;
    
    [self.navigationController presentViewController:addTeam animated:YES completion:nil];
    
}
#pragma mark - 删除群组
- (void)deleteGroup:(UIButton*)Button{
    
    MiGroupModel * groupModel = [_groupArry objectAtIndexWithSafety:Button.tag-1000];
    
    NSString * noticeStr = [NSString stringWithFormat:@"确认删除群组--%@",groupModel.groupName];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:noticeStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
    
    alert .tag = Button.tag * 10;
    
    [alert show];
    
    
    NSLog(@"  %ld",Button.tag);
    
}


#pragma mark 查看更多

- (void)dselemoreGroup:(UIButton*)Button{
    
     MiGroupModel * groupModel = [_groupArry objectAtIndexWithSafety:Button.tag-10000];
    
    addTeamViewController * addteam  = [[addTeamViewController alloc]init];
  
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"0" forKey:@"isNew"];
    [dict setObject:[NSString stringWithFormat:@"%@",groupModel.groupID] forKey:@"groupID"];
    
    addteam.PushDict = dict;
    
    
    [self.navigationController presentViewController:addteam animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - 修改成员
- (void)exchangeMember:(UIButton*)Button{
     NSLog(@"  %ld",Button.tag/10);
    
    NSInteger row = Button.tag/10;
    
    NSInteger item = Button.tag%10-1;
    
    MiGroupModel * groupModel = [_groupArry objectAtIndexWithSafety:row];
    
    NSMutableArray * memberArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiTeamerWith:groupModel.groupID];
    
    MiTeamer * teamer = [memberArry objectAtIndexWithSafety:item];
    
    addTeamViewController * addteam  = [[addTeamViewController alloc]init];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"0" forKey:@"isNew"];
    [dict setObject:[NSString stringWithFormat:@"%@",groupModel.groupID] forKey:@"groupID"];
    
    [dict setObject:@"1" forKey:@"isChange"];
    [dict setObject:@"0" forKey:@"isAdd"];
    [dict setObject:[NSString stringWithFormat:@"%@",teamer.teamerId] forKey:@"teamerId"];
    
    NSLog(@"teamer.teamerName  %@",teamer.teamerName);
    
    
    addteam.PushDict = dict;
    
    
    [self.navigationController presentViewController:addteam animated:YES completion:^{
        
    }];
    
}
#pragma mark - 添加成员
- (void)addMember:(UIButton *)Button{
    
    NSLog(@"  %ld",Button.tag);
    NSInteger row = Button.tag/10;
//    NSInteger item = Button.tag%10;
    
    MiGroupModel * groupModel = [_groupArry objectAtIndexWithSafety:row];
    
//    MiTeamer * teamer = [_groupMemberArry objectAtIndexWithSafety:item];
    
    addTeamViewController * addteam  = [[addTeamViewController alloc]init];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"0" forKey:@"isNew"];
    [dict setObject:[NSString stringWithFormat:@"%@",groupModel.groupID] forKey:@"groupID"];
    
    [dict setObject:@"0" forKey:@"isChange"];
    [dict setObject:@"1" forKey:@"isAdd"];
    
    addteam.PushDict = dict;
    
    
    [self.navigationController presentViewController:addteam animated:YES completion:^{
        
    }];
    
}

//TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _groupArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 450;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiNiSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MiNiSetTableViewCell"];
    if (cell==nil) {
        cell = [[MiNiSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MiNiSetTableViewCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [self setlayercornerRadius:cell.backView Radius:5];
    [self setlayercornerRadius:cell.back1 Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    [self setlayercornerRadius:cell.back2 Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    [self setlayercornerRadius:cell.back3 Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    [self setlayercornerRadius:cell.back4 Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    [self setlayercornerRadius:cell.back5 Radius:0 Width:0.5 Color:[UIColor lightGrayColor]];
    
    
    [self setlayercornerRadius:cell.exchange1 Radius:5];
    [self setlayercornerRadius:cell.exchange2 Radius:5];
    [self setlayercornerRadius:cell.exchange3 Radius:5];
    [self setlayercornerRadius:cell.exchange4 Radius:5];
    [self setlayercornerRadius:cell.exchange5 Radius:5];
    
    cell.exchange1.tag = indexPath.row*10 +1;
    cell.exchange2.tag = indexPath.row*10 +2;
    cell.exchange3.tag = indexPath.row*10 +3;
    cell.exchange4.tag = indexPath.row*10 +4;
    cell.exchange5.tag = indexPath.row*10 +5;
    
    [self setlayercornerRadius:cell.selemore Radius:5];
    [self setlayercornerRadius:cell.deleteTeam Radius:5];
    
    MiGroupModel * groupData = [_groupArry objectAtIndex:indexPath.row];
    
    CGroupModel * groupModel = [CGroupModel createCGroupModelWithMiGroupModel:groupData];
    
    
    
    
    cell.teamName.text = groupModel.groupName;
    cell.sportMode.text = groupModel.sportMode;
    
    cell.deleteTeam.tag = 1000+indexPath.row;
    
    [cell.deleteTeam addTarget:self action:@selector(deleteGroup:) forControlEvents:UIControlEventTouchUpInside];
    
      cell.selemore.tag = 10000+indexPath.row;
    [cell.selemore addTarget:self action:@selector(dselemoreGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    NSMutableArray * memberArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiTeamerWith:groupModel.groupID];
    
//    NSLog(@"memberArry   %@",memberArry);
    cell.name1.text = @"暂无";
    cell.name2.text = @"暂无";
    cell.name3.text = @"暂无";
    cell.name4.text = @"暂无";
    cell.name5.text = @"暂无";
 
    [cell.exchange1 setTitle:@"添加成员" forState:UIControlStateNormal];
    [cell.exchange2 setTitle:@"添加成员" forState:UIControlStateNormal];
    [cell.exchange3 setTitle:@"添加成员" forState:UIControlStateNormal];
    [cell.exchange4 setTitle:@"添加成员" forState:UIControlStateNormal];
    [cell.exchange5 setTitle:@"添加成员" forState:UIControlStateNormal];
    
    NSUInteger ArryCount = memberArry.count;
    
    if (ArryCount>5) {
        ArryCount=5;
    }
    
    switch (ArryCount) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            MiTeamer * teamer = [memberArry objectAtIndexWithSafety:0];
            
            cell.name1.text = teamer.teamerName;
           
            [cell.exchange1 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange1 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
            [cell.exchange2 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange3 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange4 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange5 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 2:
        {
            MiTeamer * teamer = [memberArry objectAtIndexWithSafety:0];
            
            cell.name1.text = teamer.teamerName;
            
            [cell.exchange1 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange1 setTitle:@"修改信息" forState:UIControlStateNormal];
            cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
            
            MiTeamer * teamer2 = [memberArry objectAtIndexWithSafety:1];
            
            cell.name2.text = teamer2.teamerName;
            
            [cell.exchange2 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange2 setTitle:@"修改信息" forState:UIControlStateNormal];
            
//            [cell.exchange1 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.exchange2 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange3 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange4 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange5 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            cell.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer2.teamerNo]];
        }
            break;
        case 3:
        {
            MiTeamer * teamer = [memberArry objectAtIndexWithSafety:0];
            
            cell.name1.text = teamer.teamerName;
            
            cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
            
            [cell.exchange1 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange1 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            MiTeamer * teamer2 = [memberArry objectAtIndexWithSafety:1];
            
            cell.name2.text = teamer2.teamerName;
            
             cell.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer2.teamerNo]];
            [cell.exchange2 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange2 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            MiTeamer * teamer3 = [memberArry objectAtIndexWithSafety:2];
            
            cell.name3.text = teamer3.teamerName;
            
            [cell.exchange3 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange3 setTitle:@"修改信息" forState:UIControlStateNormal];
            cell.image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer3.teamerNo]];
            
            [cell.exchange4 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange5 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {
            MiTeamer * teamer = [memberArry objectAtIndexWithSafety:0];
            
            cell.name1.text = teamer.teamerName;
            
            [cell.exchange1 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange1 setTitle:@"修改信息" forState:UIControlStateNormal];
            cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
            
            MiTeamer * teamer2 = [memberArry objectAtIndexWithSafety:1];
            
            cell.name2.text = teamer2.teamerName;
            
            [cell.exchange2 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange2 setTitle:@"修改信息" forState:UIControlStateNormal];
            cell.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer2.teamerNo]];
            
            MiTeamer * teamer3 = [memberArry objectAtIndexWithSafety:2];
            
            cell.name3.text = teamer3.teamerName;
            
            [cell.exchange3 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange3 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer3.teamerNo]];
            
            MiTeamer * teamer4 = [memberArry objectAtIndexWithSafety:3];
            
            cell.name4.text = teamer4.teamerName;
            
            [cell.exchange4 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange4 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer4.teamerNo]];
            
//            [cell.exchange1 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.exchange2 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.exchange3 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.exchange4 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.exchange5 addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 5:
        {
            MiTeamer * teamer = [memberArry objectAtIndexWithSafety:0];
            
            cell.name1.text = teamer.teamerName;
            
            [cell.exchange1 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange1 setTitle:@"修改信息" forState:UIControlStateNormal];
            cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer.teamerNo]];
            
            MiTeamer * teamer2 = [memberArry objectAtIndexWithSafety:1];
            
            cell.name2.text = teamer2.teamerName;
            
            [cell.exchange2 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange2 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer2.teamerNo]];
            
            MiTeamer * teamer3 = [memberArry objectAtIndexWithSafety:2];
            
            cell.name3.text = teamer3.teamerName;
            
            [cell.exchange3 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange3 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer3.teamerNo]];
            
            MiTeamer * teamer4 = [memberArry objectAtIndexWithSafety:3];
            
            cell.name4.text = teamer4.teamerName;
            
            [cell.exchange4 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange4 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer4.teamerNo]];
            
            MiTeamer * teamer5 = [memberArry objectAtIndexWithSafety:4];
            
            cell.name5.text = teamer5.teamerName;
            
            [cell.exchange5 addTarget:self action:@selector(exchangeMember:) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchange5 setTitle:@"修改信息" forState:UIControlStateNormal];
            
            cell.image5.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.%@",teamer5.teamerNo]];
            
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        NSLog(@"确认");
        
        NSInteger integer = alertView.tag / 10 - 1000;
        
        MiGroupModel * groupModel = [_groupArry objectAtIndexWithSafety:integer];
        
        if ([[LifeBitCoreDataManager shareInstance]efDeleteMiGroupModel:groupModel]) {
            [self showSuccessAlertWithTitleStr:@"删除成功"];
            [self observerAdd:nil];
        } else{
            [self showErroAlertWithTitleStr:@"删除失败"];
        }
        
    }else if(buttonIndex==1){
         NSLog(@"取消");
        
    }
    
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
