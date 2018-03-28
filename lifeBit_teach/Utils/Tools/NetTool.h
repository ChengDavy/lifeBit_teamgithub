//
//  NetTool.h
//  活动指南
//
//  Created by shwally on 15/4/22.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTool : NSObject

+ (instancetype)shareInstance;

/** 判断当前网络链接 */
- (BOOL) isConnectionAvailable;

/** wifi */
- (BOOL)IsEnableWiFi;

/** 3g */
- (BOOL)IsEnable3G;

/** 网络连接类型 */
- (NSString *)getNetWorkStates;

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

- (void)postWithURL:(NSString *)url
//             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure;

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure;

- (void)getWithURL:(NSString *)url
//            params:(NSDictionary *)params
           success:(void (^)(id JSON))success
           failure:(void (^)(NSError *error))failure;
@end


/**
 *  封装文件数据的模型
 */
@interface FormData : NSObject
/** 文件数据 */
@property (nonatomic, strong) NSData *data;
/** 参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;


@end
