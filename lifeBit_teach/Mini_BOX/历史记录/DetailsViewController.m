//
//  DetailsViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/28.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailTableViewCell.h"
#import "MiTeamerViewController.h"
#import <MessageUI/MessageUI.h>
#import "LibXL/libxl.h"
#import "classNoteViewController.h"
#import "chartView.h"

@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    CHistoryTestModel * _cTestModel;
    NSMutableArray * _testArry;
    __weak IBOutlet UIButton *delebuton;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self createData];
    // Do any additional setup after loading the view from its nib.
}
- (void)createData{
    
    NSLog(@"_PushDict  %@",_PushDict);
    
    _testArry = [[NSMutableArray alloc]init];
    _testId = [_PushDict objectForKeyNotNull:@"testID"];
    
    MiHistoryTestModel * miTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:_testId];
    
    _cTestModel = [CHistoryTestModel createCHistoryTestModelWithMiHistoryTestModel:miTestModel];
    
    [self loadData];
    
    _testArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiUserTestModelWithTestId:_testId];
    
    _bottomlay.constant = 785 - _testArry.count * 60;
    
    [_myTableView reloadData];
    
    [[MiRunWatchManager shareInstance]dealHeartWithTestID:_testId];
    
}
- (IBAction)delete:(id)sender {
    
    UIActionSheet * myAction = [[UIActionSheet alloc]initWithTitle:@"项目管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除项目",@"上传项目",@"查看备注", nil];
    
    myAction.tag = 8888;
    [myAction showInView:self.view];
    
}
- (void)loadData{
    
    _teamName.text = [NSString stringWithFormat:@"%@-%@",_cTestModel.groupName,_cTestModel.testTittle];
    _dateLa.text = _cTestModel.testBeginTime;
    _sportMode.text = _cTestModel.sportMode;
    _timeLa.text = _cTestModel.testTimeLong;
    
    _timeLa.text = [NSString getTimeFromSecondStr: _cTestModel.testTimeLong];
    _heartAv.text = _cTestModel.avsHeart;
    _heartMax.text = _cTestModel.maxHeart;
    _stepLa.text = _cTestModel.avsStep;
    _sportMd.text = [NSString stringWithFormat:@"%@%%",_cTestModel.sportMD];
    _sportQd.text = [NSString stringWithFormat:@"%@%%",_cTestModel.sportQD];
    _caloLa.text = _cTestModel.avscalorie;
    if ([_testId isEqualToString:kMiDemoModelID]) {
        delebuton.hidden=YES;
    }
    
}

- (void)createView{
    
    [self setlayercornerRadius:_myTableView Radius:10];
    [self setlayercornerRadius:_headBackVie Radius:10];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
}
//TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _testArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    if (cell==nil) {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailTableViewCell"];
    }
    
    MiUserTestModel * testModel = [_testArry objectAtIndexWithSafety:indexPath.row];
    
    cell.teamName.text = testModel.teamerName;
    cell.heartAv.text = testModel.avsHeart;
    cell.heartMax.text = testModel.maxHeart;
    cell.step.text = testModel.step;
    cell.calor.text = testModel.calorie;
    cell.sportQD.text = [NSString stringWithFormat:@"%@%%",testModel.sportQD];
    
    cell.sportMD.text = [NSString stringWithFormat:@"%@%%",testModel.sportMD];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (void)sendEmailActionPic
{
    [self showNetWorkAlertAndCannotPopWithTitleStr:@"数据处理中"];
    
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:[NSString stringWithFormat:@"%@测试数据回传",_cTestModel.groupName]];
    
    
    NSString * pId = [HJUserManager shareInstance].user.pId;
    
    NSString * pPass = [HJUserManager shareInstance].user.pPass;
    
    
    MiUserDataModel * userModel =  [[LifeBitCoreDataManager shareInstance] efGetMiUserModelMobile:pId andPassword:pPass];
    
    // 设置收件人
    [mailCompose setToRecipients:@[userModel.pEmail]];
    // 设置抄送人
    // [mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    //   [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = [NSString stringWithFormat:@"%@%@%@测试数据回传",_cTestModel.groupName,_cTestModel.testTittle,_cTestModel.testBeginTime];
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    //  项目总统计
    NSData * TestModelData = [NSData dataWithContentsOfFile:[self creatTestModelXLSX]];
    
    [mailCompose addAttachmentData:TestModelData mimeType:@"" fileName:[NSString stringWithFormat:@"%@项目报表.xls",_cTestModel.testTittle]];
    
    //  项目心率统计图
    
    
    NSInteger time = _cTestModel.testTimeLong.integerValue/60;
    
    for (int i = 0; i < _testArry.count; i++) {
        
        
        MiUserTestModel * userTestModel = [_testArry objectAtIndexWithSafety:i];
        
        NSMutableArray * heartArry = [[[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelWithTestId:_testId withTeamerId:userTestModel.teamerId] mutableCopy] ;
        
        chartView * chart = [[chartView alloc]initWithFrame:CGRectMake(0, 0, (time + 2) * 60 + 80 , 320)];
        
        [chart creatViewWithTime:time];
        
        [chart loadData:heartArry Animated:YES timeLong:time];
        
        [chart creatTittle:[NSString stringWithFormat:@"%@号%@的心率图",userTestModel.teamerNo,userTestModel.teamerName]];
        
        UIImage *image = [self convertViewToImage:chart];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        [mailCompose addAttachmentData:imageData mimeType:@"png" fileName:[NSString stringWithFormat:@"%@号%@的心率图.png",userTestModel.teamerNo,userTestModel.teamerName]];
        
    }
    

    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
    
}
- (void)sendEmailAction
{
    
    [self showNetWorkAlertAndCannotPopWithTitleStr:@"数据处理中"];
    
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:[NSString stringWithFormat:@"%@测试数据回传",_cTestModel.groupName]];
    
    NSString * pId = [HJUserManager shareInstance].user.pId;
    
    NSString * pPass = [HJUserManager shareInstance].user.pPass;
    
    
    MiUserDataModel * userModel =  [[LifeBitCoreDataManager shareInstance] efGetMiUserModelMobile:pId andPassword:pPass];
    
    // 设置收件人
    [mailCompose setToRecipients:@[userModel.pEmail]];
    // 设置抄送人

    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = [NSString stringWithFormat:@"%@%@%@测试数据回传",_cTestModel.groupName,_cTestModel.testTittle,_cTestModel.testBeginTime];
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    //  项目总统计
    NSData * TestModelData = [NSData dataWithContentsOfFile:[self creatTestModelXLSX]];
    
    [mailCompose addAttachmentData:TestModelData mimeType:@"" fileName:[NSString stringWithFormat:@"%@项目报表.xls",_cTestModel.testTittle]];
    
    //  项目个人数据
    
    
    //  项目心率统计数据
    
    for (int i = 0; i < _testArry.count; i++) {
        MiUserTestModel * userTestModel = [_testArry objectAtIndexWithSafety:i];
        
        NSArray * heartArry = [[LifeBitCoreDataManager shareInstance]efGetSchoolAllMiHeartModelWithTestId:_testId withTeamerId:userTestModel.teamerId];
        
        NSData * USerHeartModelData = [NSData dataWithContentsOfFile:[self creatUserHeartTestModelXLSX:heartArry userTestModel:userTestModel ]];
        
        [mailCompose addAttachmentData:USerHeartModelData mimeType:@""fileName:[NSString stringWithFormat:@"%@心率报表.xls",userTestModel.teamerName]];
        
    }
    
    // 弹出邮件发送视图
    
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            [self showSuccessAlertWithTitleStr:@"邮件已取消"];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            [self showSuccessAlertWithTitleStr:@"邮件已保存"];
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            [self showSuccessAlertWithTitleStr:@"邮件已发送成功"];
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            [self showSuccessAlertWithTitleStr:@"邮件发送失败"];
            
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    [self endNetWorkAlertWithNoMessage];
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 8888) {
        
        if (buttonIndex ==0) {
            NSLog(@"0");
            UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除该项目,项目删除后将不能找回" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
            myAlert.tag = 1111;
            [myAlert show];
            
        }else if (buttonIndex ==1) {
            NSLog(@"1");
            
            UIActionSheet * myAction = [[UIActionSheet alloc]initWithTitle:@"选择上传模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"数据报表模式",@"数据详情模式", nil];
            myAction.tag = 9999;
            [myAction showInView:self.view];
            
        }else if (buttonIndex ==2) {
            
            classNoteViewController * realDe = [[classNoteViewController alloc]init];
            
            NSMutableDictionary * pushDict = [[NSMutableDictionary alloc]init];
            
            [pushDict setObject:_testId forKey:@"testID"];
            
            [pushDict setObject:@"1" forKey:@"isDemo"];
            
            realDe.pushDict = pushDict;
            
            [self presentViewController:realDe animated:YES completion:nil];
            
            NSLog(@"课中备注");
            
            NSLog(@"2");
        }
    }
    if (actionSheet.tag == 9999) {
        if (buttonIndex ==0) {
            NSLog(@"0");
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailActionPic]; // 调用发送邮件的代码
            }else{
                
                UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未设置邮件发件账户,跳转进行设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
                myAlert.tag = 2222;
                [myAlert show];
            }
            
        }else if (buttonIndex ==1) {
            NSLog(@"1");
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailAction]; // 调用发送邮件的代码
            }else{
                
                UIAlertView * myAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未设置邮件发件账户,跳转进行设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
                myAlert.tag = 2222;
                [myAlert show];
            }
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1111) {
        if (buttonIndex==0) {
            NSLog(@"取消");
        }else if (buttonIndex==1){
            NSLog(@"删除");
            MiHistoryTestModel * miTestModel = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:_testId];
            
            [[LifeBitCoreDataManager shareInstance]efDeleteMiHistoryTestModel: miTestModel];
            
            [[LifeBitCoreDataManager shareInstance]efDeleteMiUserTestModelByTestID:_testId];
            
            [[LifeBitCoreDataManager shareInstance]efDeleteMiHeartModelByTestID:_testId];
            
            [self showSuccessAlertWithTitleStr:@"删除成功"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KDeleteTestSuccess object:nil];
            
        }
    }
    if (alertView.tag == 2222) {
        if (buttonIndex==0) {
            NSLog(@"取消");
        }else if (buttonIndex==1){
            [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"MESSAGE://"]];
        }
    }
}


//项目数据
- (NSString *)creatTestModelXLSX{
    
    
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    
    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    
    //设置表格字体，颜色等
    FontHandle font = xlBookAddFont(book, 0);
    xlFontSetColor(font, COLOR_RED);
    xlFontSetBold(font, true);
    FormatHandle boldFormat = xlBookAddFormat(book, 0);
    xlFormatSetFont(boldFormat, font);
    
    xlSheetSetCol(sheet, 0, 4, 10, 0, 0);
    
    xlSheetSetRow(sheet, 1, 20, 0, 0);
    
    xlSheetWriteStr(sheet, 1, 0, "团队", 0);
    xlSheetWriteStr(sheet, 1, 1, "项目", 0);
    xlSheetWriteStr(sheet, 1, 2, "运动模式", 0);
    xlSheetWriteStr(sheet, 1, 3, "开始时间", 0);
    xlSheetWriteStr(sheet, 1, 4, "运动时长(分钟)", 0);
    xlSheetWriteStr(sheet, 1, 5, "平均心率", 0);
    xlSheetWriteStr(sheet, 1, 6, "最大心率", 0);
    xlSheetWriteStr(sheet, 1, 7, "平均步数", 0);
    xlSheetWriteStr(sheet, 1, 8, "平均运动距离(米)", 0);
    xlSheetWriteStr(sheet, 1, 9, "运动强度(%)", 0);
    xlSheetWriteStr(sheet, 1, 10, "运动密度(%)", 0);
    
    for (int i = 0; i < _testArry.count+3; i ++) {
        
        if (i==0) {
            xlSheetWriteStr(sheet, 2 + i, 0, [_cTestModel.groupName UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 1, [_cTestModel.testTittle UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 2, [_cTestModel.sportMode UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 3, [_cTestModel.testBeginTime UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 4, [[NSString stringWithFormat:@"%ld",_cTestModel.testTimeLong.integerValue /60] UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 5, [_cTestModel.avsHeart UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 6, [_cTestModel.maxHeart UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 7, [_cTestModel.avsStep UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 8, [_cTestModel.avscalorie UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 9, [_cTestModel.sportQD UTF8String], 0);
            xlSheetWriteStr(sheet, 2 + i, 10, [_cTestModel.sportMD UTF8String], 0);
            //            xlSheetWriteStr(sheet, 2 + i, 11, [_cTestModel.testMiddleText UTF8String], 0);
            
        }
        
        else if (i==1) {
            xlSheetWriteStr(sheet, 4, 0, "姓名", 0);
            xlSheetWriteStr(sheet, 4, 1, "编号", 0);
            xlSheetWriteStr(sheet, 4, 2, "年龄", 0);
            xlSheetWriteStr(sheet, 4, 3, "性别", 0);
            xlSheetWriteStr(sheet, 4, 4, "身高(CM)", 0);
            xlSheetWriteStr(sheet, 4, 5, "体重(KG)", 0);
            xlSheetWriteStr(sheet, 4, 6, "平均心率", 0);
            xlSheetWriteStr(sheet, 4, 7, "最大心率", 0);
            xlSheetWriteStr(sheet, 4, 8, "平均步数", 0);
            xlSheetWriteStr(sheet, 4, 9, "平均运动距离(米)", 0);
            xlSheetWriteStr(sheet, 4, 10, "运动强度(%)", 0);
            xlSheetWriteStr(sheet, 4, 11, "运动密度(%)", 0);
            
        }
        else if (i==_testArry.count+2) {
            xlSheetWriteStr(sheet, 4+i, 0, "课程备注", 0);
            xlSheetWriteStr(sheet, 4+i, 1, [_cTestModel.testMiddleText UTF8String], 0);
            
        }
        
        else{
            MiUserTestModel * userTestModel = [_testArry objectAtIndexWithSafety:i-2];
            
            NSLog(@"userTestModel.teamerName   %@",userTestModel.teamerName);
            
            xlSheetWriteStr(sheet, 3 + i, 0, [userTestModel.teamerName UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 1, [userTestModel.teamerNo UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 2, [userTestModel.teamerAge UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 3, [userTestModel.teamerSex UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 4, [userTestModel.teamerheight UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 5, [userTestModel.teamerWeight UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 6, [userTestModel.avsHeart UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 7, [userTestModel.maxHeart UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 8, [userTestModel.step UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 9, [userTestModel.calorie UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 10, [userTestModel.sportQD UTF8String], 0);
            xlSheetWriteStr(sheet, 3 + i, 11, [userTestModel.sportMD UTF8String], 0);
            
        }
        
    }
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *achievementDirectory = [documentPath stringByAppendingPathComponent:@"achievement"];
    BOOL isCreateDirectorySuccess = [fileManager createDirectoryAtPath:achievementDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (!isCreateDirectorySuccess) {
        return nil;
    }
    
    NSString *filePath = [achievementDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xls",_cTestModel.testTittle]];
    
    xlBookSave(book, [filePath UTF8String]);
    xlBookRelease(book);
    
    //导出xls文件
    return filePath;
    
}

// 心率

- (NSString *)creatUserHeartTestModelXLSX:(NSArray *)heartArry userTestModel:(MiUserTestModel*)userTestModel {
    
    
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    
    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    
    //设置表格字体，颜色等
    FontHandle font = xlBookAddFont(book, 0);
    xlFontSetColor(font, COLOR_RED);
    xlFontSetBold(font, true);
    FormatHandle boldFormat = xlBookAddFormat(book, 0);
    xlFormatSetFont(boldFormat, font);
    
    xlSheetSetCol(sheet, 0, 4, 10, 0, 0);
    
    xlSheetSetRow(sheet, 1, 20, 0, 0);
    
    xlSheetWriteStr(sheet, 1, 0, "姓名", 0);
    xlSheetWriteStr(sheet, 1, 1, "团队", 0);
    xlSheetWriteStr(sheet, 1, 2, "编号", 0);
    xlSheetWriteStr(sheet, 1, 3, "年龄", 0);
    xlSheetWriteStr(sheet, 1, 4, "性别", 0);
    xlSheetWriteStr(sheet, 1, 5, "身高(CM)", 0);
    xlSheetWriteStr(sheet, 1, 6, "体重(KG)", 0);
    xlSheetWriteStr(sheet, 1, 7, "项目", 0);
    xlSheetWriteStr(sheet, 1, 8, "运动模式", 0);
    xlSheetWriteStr(sheet, 1, 9, "开始时间", 0);
    xlSheetWriteStr(sheet, 1, 10, "运动时长(min)", 0);
    xlSheetWriteStr(sheet, 1, 11, "时间点", 0);
    xlSheetWriteStr(sheet, 1, 12, "心率", 0);
    xlSheetWriteStr(sheet, 1, 13, "平均心率", 0);
    xlSheetWriteStr(sheet, 1, 14, "最大心率", 0);
    xlSheetWriteStr(sheet, 1, 15, "步数", 0);
    xlSheetWriteStr(sheet, 1, 16, "运动距离(米)", 0);
    xlSheetWriteStr(sheet, 1, 17, "运动强度(%)", 0);
    xlSheetWriteStr(sheet, 1, 18, "运动密度(%)", 0);
    
    
    for (int i = 0; i < heartArry.count; i ++) {
        
        MiHeartModel * heartModel = [heartArry objectAtIndexWithSafety:i];
        
        xlSheetWriteStr(sheet, 2 + i, 0, [userTestModel.teamerName UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 1, [_cTestModel.groupName UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 2, [userTestModel.teamerNo UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 3, [userTestModel.teamerAge UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 4, [userTestModel.teamerSex UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 5, [userTestModel.teamerheight UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 6, [userTestModel.teamerWeight UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 7, [_cTestModel.testTittle UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 8, [_cTestModel.sportMode UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 9, [_cTestModel.testBeginTime UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 10, [[NSString stringWithFormat:@"%ld",_cTestModel.testTimeLong.integerValue /60] UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 11, [[NSString stringWithFormat:@"%@",heartModel.timePoint ] UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 12, [heartModel.heartNumber UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 13, [userTestModel.avsHeart UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 14, [userTestModel.maxHeart UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 15, [userTestModel.step UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 16, [userTestModel.calorie UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 17, [userTestModel.sportQD UTF8String], 0);
        xlSheetWriteStr(sheet, 2 + i, 18, [userTestModel.sportMD UTF8String], 0);
   
    }
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *achievementDirectory = [documentPath stringByAppendingPathComponent:@"achievement"];
    BOOL isCreateDirectorySuccess = [fileManager createDirectoryAtPath:achievementDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (!isCreateDirectorySuccess) {
        return nil;
    }
    
    NSString *filePath = [achievementDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xls",_cTestModel.testTittle]];
    
    xlBookSave(book, [filePath UTF8String]);
    xlBookRelease(book);
    
    //导出xls文件
    return filePath;
    
    NSString * fileName = [NSString stringWithFormat:@"%@心跳数据.csv",userTestModel.teamerName];
    
    NSString* sourcePaht = [self createFile:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sourcePaht];
    //将节点调到文件末尾
    [fileHandle seekToEndOfFile];
    
    for(int i=0;i<heartArry.count+1;i++){
        
        NSString *str =@"";
        if (i==0) {
            str = [NSString stringWithFormat:@"姓名,团队,编号,年龄,性别,身高,体重,项目,运动模式,开始时间,运动时长,时间点,心率,平均心率,最大心率,平均步数,运动距离(米),运动强度,运动密度\n"];
            
        }else {
            
            MiHeartModel * heartModel = [heartArry objectAtIndexWithSafety:i-1];
            
            str =[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                  userTestModel.teamerName,
                  _cTestModel.groupName,
                  userTestModel.teamerNo,
                  userTestModel.teamerAge,
                  userTestModel.teamerSex,
                  
                  userTestModel.teamerheight,
                  userTestModel.teamerWeight,
                  _cTestModel.testTittle,
                  _cTestModel.sportMode,
                  _cTestModel.testBeginTime,
                  
                  _cTestModel.testTimeLong,
                  heartModel.timePoint,
                  heartModel.heartNumber,
                  userTestModel.avsHeart,
                  userTestModel.maxHeart,
                  
                  userTestModel.step,
                  userTestModel.calorie,
                  userTestModel.sportQD,
                  userTestModel.sportMD];
        }
        
        str = [NSString stringWithFormat:@"%d%@",i,str];
        NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
        //追加写入数据
        [fileHandle writeData:stringData];
    }
    
    
    [fileHandle closeFile];
    
    return sourcePaht;
    
}

-(NSString*)writeCSVData{
    
    NSString* sourcePaht = [self createFile:@"ni"];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sourcePaht];
    //将节点调到文件末尾
    [fileHandle seekToEndOfFile];
    
    
    for(int i=0;i<6000;i++){
        NSString *str = @"某人的姓名,一个电话,一个地址,2017.02.20 11:30\n";
        str = [NSString stringWithFormat:@"%@",str];
        NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
        //追加写入数据
        [fileHandle writeData:stringData];
    }
    
    [fileHandle closeFile];
    
    return sourcePaht;
}

-(NSString*)createFile:(NSString*)fileName{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray* searchResult =  [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    
    NSLog(@"%@",searchResult);
    
    NSURL* documentPath = [searchResult firstObject];
    NSString* newPath = [documentPath.path stringByAppendingPathComponent:@"Demo"];
    if ([fileManager fileExistsAtPath:newPath] == false) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* filePath = [newPath stringByAppendingPathComponent:fileName];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    return filePath;
}

-(UIImage*)convertViewToImage:(UIView*)v{
    
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
