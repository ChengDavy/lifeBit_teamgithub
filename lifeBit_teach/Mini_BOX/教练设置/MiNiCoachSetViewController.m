//
//  MiNiCoachSetViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiCoachSetViewController.h"
#import "ChangePaViewController.h"
#import "WatchManagerViewController.h"
#import "BoxManViewController.h"


@interface MiNiCoachSetViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    MiUserDataModel * _userModel;
}

@end

@implementation MiNiCoachSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    [self createView];
    [self createData];
//     Do any additional setup after loading the view from its nib.
}
- (void)createData{

    
    NSString * pId = [HJUserManager shareInstance].user.pId;
    
    NSString * pPass = [HJUserManager shareInstance].user.pPass;

    
    _userModel =  [[LifeBitCoreDataManager shareInstance] efGetMiUserModelMobile:pId andPassword:pPass];
    //        判断数据库中存在此用户
    if (_userModel.pId.length <= 0 || _userModel.pPass.length <= 0) {
        
        [self showErroAlertWithTitleStr:@"用户不存在或者本地未缓存该用户的信息，请在网络环境下登陆"];
        return;
    }
    
    CUserModel *userInfo = [CUserModel createCUserModelCoverUserData:_userModel];
    
    NSString *ipadStr = [[APPIdentificationManage shareInstance] readUDID];

    _nameT.text = userInfo.pUserName ;
    _phoneT.text = userInfo.pMoble;
    _emailT.text = userInfo.pEmail;
    _ipadId.text = ipadStr;
}
- (void)createView{
    
    [self setlayercornerRadius:_headBack Radius:10];
    [self setlayercornerRadius:_backView2 Radius:10];
    [self setlayercornerRadius:_backView3 Radius:10];
    [self setlayercornerRadius:_backView Radius:10];
    [self setlayercornerRadius:_phoneIm Radius:11.5];
    [self setlayercornerRadius:_emailIm Radius:11.5];
    [self setlayercornerRadius:_ipadIm Radius:11.5];
    [self setlayercornerRadius:_passIm Radius:11.5];
    [self setlayercornerRadius:_headImage Radius:67];
    
    if ([MyTool LocalHaveImage:KHeadImage]) {
        _headImage.image = [MyTool GetImageFromLocal:KHeadImage ];
    }
    
}
- (IBAction)PassWordChange:(id)sender {
    ChangePaViewController *  change = [[ChangePaViewController alloc]init];
    
    [self.navigationController  presentViewController:change animated:YES completion:nil];
    
    NSLog(@"PassWordChange");
}
- (IBAction)watchManager:(id)sender {
    
    WatchManagerViewController *  WatchManager = [[WatchManagerViewController alloc]init];
    
    [self.navigationController  presentViewController:WatchManager animated:YES completion:nil];

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _nameT) {
        NSLog(@"%@",_nameT.text);
        if (_nameT.text.length>0 ) {
            
            if ([_userModel.pUserName isEqualToString:_nameT.text]) {
                
                [self showSuccessAlertWithTitleStr:@"更新昵称成功"];
            }else{
                
                _userModel.pUserName= _nameT.text;
                
                [[LifeBitCoreDataManager shareInstance] efUpdateMiUserModel: _userModel];
                
                [self showSuccessAlertWithTitleStr:@"更新昵称成功"];
            }
            
            
        }else{
            [self showErroAlertWithTitleStr:@"昵称不能为空"];
        }
        
    }
    
}
- (IBAction)changePic:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"当前无法调用摄像头,请设置!"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [self.navigationController  presentViewController:picker
                                             animated:YES
                                           completion:nil];

    
   /* UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [self.navigationController  presentViewController:picker
                                             animated:YES
                                           completion:nil];
    NSLog(@"相册");

    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    action.tag=11111;
    [action showInView:self.view];

    */
    
}
- (IBAction)changePh:(id)sender {
    
    if ([MyTool phoneNumberIsLegal:_phoneT.text] ) {
        
        if ([_userModel.pMoble isEqualToString:_phoneT.text]) {
            
            [self showSuccessAlertWithTitleStr:@"更新手机号码成功"];
        }else{
            
            _userModel.pMoble= _phoneT.text;
            
            [[LifeBitCoreDataManager shareInstance] efUpdateMiUserModel: _userModel];
            
            [self showSuccessAlertWithTitleStr:@"更新手机号码成功"];
        }
 
        
    }else{
        [self showErroAlertWithTitleStr:@"手机号码格式错误"];
    }
   
}
- (IBAction)changeMail:(id)sender {
    
    if ([MyTool emailIsLegal:_emailT.text] ) {
        
        if ([_userModel.pEmail isEqualToString:_emailT.text]) {
            
            [self showSuccessAlertWithTitleStr:@"更新邮箱成功"];
        }else{
            
            _userModel.pEmail= _emailT.text;
            
            [[LifeBitCoreDataManager shareInstance] efUpdateMiUserModel: _userModel];
            
            [self showSuccessAlertWithTitleStr:@"更新邮箱成功"];
        }
        
        
    }else{
        [self showErroAlertWithTitleStr:@"邮箱格式错误"];
    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 11111) {
    
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"当前无法调用摄像头,请设置!"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self.navigationController  presentViewController:picker
                           animated:YES
                         completion:nil];
        NSLog(@"拍照");

        
    }else if(buttonIndex == 1){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        }
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self.navigationController  presentViewController:picker
                           animated:YES
                         completion:nil];
        NSLog(@"相册");

    }else{
        
    }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    

    [MyTool SaveImageToLocal:image Keys:KHeadImage];
    
 
    
    _headImage.image = [MyTool GetImageFromLocal:KHeadImage];

   //
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
