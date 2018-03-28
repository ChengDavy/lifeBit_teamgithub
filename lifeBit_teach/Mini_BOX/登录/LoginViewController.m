//
//  LoginViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()<UITextFieldDelegate>{
    
    NSMutableDictionary * _userMessage;
    
}
@property (weak, nonatomic) IBOutlet UIView *phoneBack;
@property (weak, nonatomic) IBOutlet UIView *passBack;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *passTextF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBU;
@property (weak, nonatomic) IBOutlet UIButton *remBU;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self createView];
    [self createData];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)createData{
    _userMessage = [[NSMutableDictionary alloc]init];
    [_userMessage setObject:@"18000180000" forKey:@"pMoble"];
    [_userMessage setObject:@"18000180000@qq.com" forKey:@"pEmail"];
    [_userMessage setObject:@"乐比教育" forKey:@"pUserName"];
    [_userMessage setObject:@"pPic" forKey:@"pPic"];
  
}
- (void)createView{
    [self setlayercornerRadius:_phoneBack Radius:5 Width:1 Color:[UIColor blackColor]];
    [self setlayercornerRadius:_passBack Radius:5 Width:1 Color:[UIColor blackColor]];
    [self setlayercornerRadius:_loginBU Radius:5];
    
    if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
        self.phoneTextF.text = [[HJAppObject sharedInstance] getCode:@"account"];
        self.passTextF.text = [[HJAppObject sharedInstance] getCode:@"password"];
        [self.remBU setImage:[UIImage imageNamed:@"noselect_kuang1"] forState:UIControlStateNormal];
         [self.remBU setImage:[UIImage imageNamed:@"选中@2x"] forState:UIControlStateNormal];
    }else{
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"0"];
         [self.remBU setImage:[UIImage imageNamed:@"矩形-（未选中）@2x"] forState:UIControlStateNormal];
    }    
}
- (IBAction)remember:(id)sender {
    
    if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
        
        [[HJAppObject sharedInstance] storeCode:@"account" andValue:@" " ];
        [[HJAppObject sharedInstance] storeCode:@"password" andValue:@" "];
        
        [self.remBU setImage:[UIImage imageNamed:@"矩形-（未选中）@2x"] forState:UIControlStateNormal];
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"0"];
        
    }else{
        
         [[HJAppObject sharedInstance] storeCode:@"account" andValue:self.phoneTextF.text ];
         [[HJAppObject sharedInstance] storeCode:@"password" andValue:self.passTextF.text ];
        
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"1"];
        
        [self.remBU setImage:[UIImage imageNamed:@"选中@2x"] forState:UIControlStateNormal];
    }

    NSLog(@"记住");
    
}
- (IBAction)login:(id)sender {
    
    if (self.passTextF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入密码"];
        return;
    }
    if ( ![MyTool emailIsLegal:self.phoneTextF.text] ) {
        [self showErroAlertWithTitleStr:@"邮箱账号格式有误"];
        return;
    }
    
    NSString * passCode = [[HJAppObject sharedInstance] getCode:KPassWord];
    
    if (passCode.length<1) {
        passCode = @"1234";
        [[HJAppObject sharedInstance] storeCode:KPassWord andValue:@"1234"];
    }
    
    if ([_passTextF.text isEqualToString:passCode]) {
        
          [self showSuccessAlertWithTitleStr:@"登录成功"];
        
        if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
            [[HJAppObject sharedInstance] storeCode:@"account" andValue:self.phoneTextF.text];
            [[HJAppObject sharedInstance] storeCode:@"password" andValue:self.passTextF.text];
        }
        
        [_userMessage setObject:self.phoneTextF.text forKey:@"pId"];
        [_userMessage setObject:self.phoneTextF.text forKey:@"pAccount"];
        [_userMessage setObject:self.passTextF.text forKey:@"pPass"];
        [_userMessage setObject:self.phoneTextF.text forKey:@"pEmail"];
        
        
        CUserModel *userInfo = [[CUserModel alloc] init];
        
        [userInfo setAttributes:_userMessage];
        
        [HJUserManager shareInstance].user = userInfo;
        [[HJUserManager shareInstance] update_to_disk];
        
        MiUserDataModel *userModel = [CUserModel coverUserDataWithUserMode:userInfo];
        
        [[LifeBitCoreDataManager shareInstance] efAddMiUserModel:userModel];
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [app setupViewControllers];
        NSLog(@"登录");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        NSDate *selected = [NSDate date];
        // 创建一个日期格式器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        
        if ( _passTextF.text.length==8 && [MyTool strIsNumber:_passTextF.text]) {
            
            BOOL isPass = YES;
            
            for (int i = 0; i < 8; i++) {
                NSString * P = [NSString stringWithFormat:@"%c", [destDateString characterAtIndex:i]];
                NSString * M = [NSString stringWithFormat:@"%c", [_passTextF.text characterAtIndex:i]];
                
                if (([P intValue]+[M intValue])%10 == 0) {
                    
                }else{
                    isPass = NO;
                }
  
            }
            if (isPass) {
                
              [[HJAppObject sharedInstance] storeCode:KPassWordAdmin andValue:self.passTextF.text];
                [self showSuccessAlertWithTitleStr:@"登录成功"];
                if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
                    [[HJAppObject sharedInstance] storeCode:@"account" andValue:self.phoneTextF.text];
                    [[HJAppObject sharedInstance] storeCode:@"password" andValue:self.passTextF.text];
                }
                
                [_userMessage setObject:self.phoneTextF.text forKey:@"pId"];
                [_userMessage setObject:self.phoneTextF.text forKey:@"pAccount"];
                [_userMessage setObject:self.passTextF.text forKey:@"pPass"];
                [_userMessage setObject:self.phoneTextF.text forKey:@"pEmail"];
                
                
                CUserModel *userInfo = [[CUserModel alloc] init];
                
                [userInfo setAttributes:_userMessage];
                
                [HJUserManager shareInstance].user = userInfo;
                [[HJUserManager shareInstance] update_to_disk];
                
                MiUserDataModel *userModel = [CUserModel coverUserDataWithUserMode:userInfo];
                
                [[LifeBitCoreDataManager shareInstance] efAddMiUserModel:userModel];
                
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                [app setupViewControllers];
                NSLog(@"登录");
                [self dismissViewControllerAnimated:YES completion:nil];

            }else{
                 [self showErroAlertWithTitleStr:@"密码错误请重试,或联系管理员"];
            }
            
            
        }else{
            
            [self showErroAlertWithTitleStr:@"密码错误请重试,或联系管理员"];
            
        }
   
    }
   
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"%@",textField.text);
    
    return YES;
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
