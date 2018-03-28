//
//  WebViewViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/11/30.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWebView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadWebView{
    
    _tittleLabel.text = _headTittle;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_UrlStr]];
    
    [_myWebView loadRequest:request];

}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString:%@", requestString);
    
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
