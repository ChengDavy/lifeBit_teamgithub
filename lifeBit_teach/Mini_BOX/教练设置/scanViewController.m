//
//  scanViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/11.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "scanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface scanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, copy) NSString *license;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    _oldMac = [_PushDict objectForKeyNotNull:@"watchMAC"];
//    
//    _watchNo = [_PushDict objectForKeyNotNull:@"watchNo"];
    
//    self.captureSession = nil;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startScan {
    NSError *error;
    //初始化捕捉设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    //创建数据输出
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //创建会话
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //将输入添加到会话
    [self.captureSession addInput:input];
    
    //将输出添加到会话
    [self.captureSession addOutput:captureMetadataOutput];
    
    //设置输出数据类型
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    
    //设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    //设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置图层的frame
    [self.videoPreviewLayer setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    
    //将图层添加到预览view的图层上
    [self.view.layer addSublayer:self.videoPreviewLayer];
    
    //扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //开始扫描
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.license = [metadataObj stringValue];
            
            NSLog(@"self.licenseself.licenseself.license  %@",self.license);
            
            if ([self.license hasPrefix:@"8030"]) {
                 [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            }else{
                [self showErroAlertWithTitleStr:@"无效二维码"];
            }
            
        }
    }
}

//停止扫描
-(void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self license:self.license];
    [self.videoPreviewLayer removeFromSuperlayer];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)license:(NSString *)license {
 
    NSLog(@"licenselicense  %@",license);
    
//    WatchModel * watchmode = [[LifeBitCoreDataManager shareInstance]efGetWatchModelBYwatchNo:_watchNo];
//    
//    WatchModel * NewWatchmodel = [[LifeBitCoreDataManager shareInstance]efCraterWatchModel];
//    
//    NewWatchmodel.watchMAC = license;
//    NewWatchmodel.watchNo = [NSNumber numberWithInteger: _watchNo.integerValue];
//    NewWatchmodel.ipadIdentifying = watchmode.ipadIdentifying;
//    NewWatchmodel.teacherId = watchmode.teacherId;
//    NewWatchmodel.teachBoxId = watchmode.teachBoxId;
//    NewWatchmodel.teachBoxName = watchmode.teachBoxName;
//    
//    [[LifeBitCoreDataManager shareInstance] efAddWatchModel:NewWatchmodel];
//    
//    [[LifeBitCoreDataManager shareInstance] efDeleteWatchModel:watchmode];
    
    [self.delegate scanData:license];
    
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
