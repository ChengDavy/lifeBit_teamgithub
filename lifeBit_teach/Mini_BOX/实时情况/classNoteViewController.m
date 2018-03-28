//
//  classNoteViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/9/1.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "classNoteViewController.h"

@interface classNoteViewController ()<UITextViewDelegate>{
    NSString * _testID;
    MiHistoryTestModel * _histoytestDemo;
    MiTestModel * _testModel;
    BOOL _isDemo;
}

@end

@implementation classNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)getData{
    _testID = [_pushDict objectForKeyNotNull:@"testID"];
    if ([[_pushDict objectForKeyNotNull:@"isDemo"] integerValue]) {
        
        _isDemo = YES;
        _histoytestDemo = [[LifeBitCoreDataManager shareInstance]efGetMiHistoryTestModelHistoryTestModelId:_testID];
        _textView.text = _histoytestDemo.testMiddleText;
        if (_textView.text.length>0) {
             _place.text=@"";
        }
        
    }else{
        _isDemo = NO;
        _testModel = [[LifeBitCoreDataManager shareInstance]efGetMiTestModelTestModelId:_testID];
        _textView.text = _testModel.testMiddleText;
        if (_textView.text.length>0) {
            _place.text=@"";
        }
    }
    
}
- (void)createView{
    [self setlayercornerRadius:_backView Radius:5];
    [self setlayercornerRadius:_updown Radius:5];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>140) {

    }
    
    if (textView.text.length==0) {
        _place.text=@"请输入...";
    }else{
        _place.text=@"";
    }
    
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)upDown:(id)sender {
    
    if (_isDemo) {
        _histoytestDemo .testMiddleText = _textView.text;
        
        [[LifeBitCoreDataManager shareInstance]efAddMiHistoryTestModel:_histoytestDemo];
    }else{
        
        _testModel.testMiddleText = _textView.text;
        [[LifeBitCoreDataManager shareInstance]efAddMiTestModel:_testModel];
    }

    [self showSuccessAlertWithTitleStr:@"课中备注成功"];
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
