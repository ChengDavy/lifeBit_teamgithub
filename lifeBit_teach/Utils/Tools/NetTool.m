//
//  NetTool.m
//  活动指南
//
//  Created by shwally on 15/4/22.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import "NetTool.h"
#import "AFNetworking.h"
#import "Reachability.h"

@implementation NetTool

+ (instancetype)shareInstance
{
    static NetTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetTool alloc] init];
    });
    return instance;
}

#pragma mark - 判断当前网络链接
- (BOOL) isConnectionAvailable
{
    BOOL isExistenceNetworking = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            // 没有网络连接
            isExistenceNetworking = NO;
        }
            break;
        case ReachableViaWiFi:{
            // 使用WiFi网络
            isExistenceNetworking = YES;
        }
            break;
        case ReachableViaWWAN:{
            // 使用3G网络
            isExistenceNetworking = YES;
        }
            break;
        default:
            isExistenceNetworking = YES;
            break;
    }
    
    return isExistenceNetworking;
}

#pragma mark - wifi
- (BOOL)IsEnableWiFi
{
    return [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] !=NotReachable;
}

#pragma mark - 3G
- (BOOL)IsEnable3G
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}


+ (BOOL)isConnect
{
    BOOL isConnected = NO;
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:nil];
    if (response == nil) {
        NSLog(@"没有网络");
        isConnected = NO;
    } else {
        NSLog(@"网络是通的");
        isConnected = YES;
    }
    
    return isConnected;
}

#pragma mark - 网络连接类型
- (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager POST:url
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
    for (FormData *formData in formDataArray) {
        [totalFormData appendPartWithFileData:formData.data
                                         name:formData.name
                                     fileName:formData.filename
                                     mimeType:formData.mimeType];
    };
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  
                  
                  
                  success(responseObject);
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}

- (void)postWithURL:(NSString *)url
//             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager POST:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  
                  
                  
                  success(responseObject);
                  
              }
              //              success(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  
                  
                  
                  success(responseObject);
              }
              success(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}


- (void)getWithURL:(NSString *)url
//            params:(NSDictionary *)params
           success:(void (^)(id JSON))success
           failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 
                 success(responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"%@",error);
             
             if (failure) {
                 failure(error);
             };
         }];
}



@end
