//
//  ChangePaViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/5.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "ChangePaViewController.h"

@interface ChangePaViewController ()

@end

@implementation ChangePaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    // Do any additional setup after loading the view from its nib.
}
- (void)createView{
    
    [self setlayercornerRadius:_back1 Radius:10];
    [self setlayercornerRadius:_back2 Radius:10];
    [self setlayercornerRadius:_back3 Radius:10];
    [self setlayercornerRadius:_doneBu Radius:10];
    
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)done:(id)sender {
    if (_oldP.text.length<1 || _pass.text.length<1 ||  _pass.text.length<1 ) {
        [self showErroAlertWithTitleStr:@"密码不能为空"];
        return;
    }
    if (![_pass.text isEqualToString:_pass2.text]) {
        [self showErroAlertWithTitleStr:@"两次新密码输入不一致,请重试"];
        return;
    }
    
    NSString * passCode = [[HJAppObject sharedInstance] getCode:KPassWord];
    
    if (passCode.length<1) {
        passCode = @"1234";
        [[HJAppObject sharedInstance] storeCode:KPassWord andValue:@"1234"];
    }
    
    if ([_oldP.text isEqualToString:passCode]) {
        
        [self showSuccessAlertWithTitleStr:@"密码设置成功"];
        
        [[HJAppObject sharedInstance]storeCode:KPassWord andValue:_pass.text];
      //  [[HJAppObject sharedInstance]storeCode:KPassWord andValue:_pass.text];
        
    }else {
        NSDate *selected = [NSDate date];
        // 创建一个日期格式器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        
        if ( _oldP.text.length==8 && [MyTool strIsNumber:_oldP.text]) {
            
            BOOL isPass = YES;
            
            for (int i = 0; i < 8; i++) {
                NSString * P = [NSString stringWithFormat:@"%c", [destDateString characterAtIndex:i]];
                NSString * M = [NSString stringWithFormat:@"%c", [_oldP.text characterAtIndex:i]];
                
                if (([P intValue]+[M intValue])%10 == 0) {
                    
                }else{
                    isPass = NO;
                }
                
            }
            if (isPass) {
                
                [self showSuccessAlertWithTitleStr:@"密码设置成功"];
                
                [[HJAppObject sharedInstance]storeCode:KPassWord andValue:_pass.text];
                
            }else{
                [self showErroAlertWithTitleStr:@"密码错误请重试,或联系管理员"];
            }
   
        }else{
            
            [self showErroAlertWithTitleStr:@"密码错误请重试,或联系管理员"];
            
        }
        
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
