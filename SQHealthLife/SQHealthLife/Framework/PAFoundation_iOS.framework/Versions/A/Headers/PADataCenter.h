//
//  PADataCenter.h
//  PAFoundation
//
//  Created by sky on 14-3-25.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "PACache.h"

#define REQUEST_TIMEOUT_INTERVAL 20  //请求超时时间

typedef NS_ENUM(NSInteger, PACachePolicy) {
    PACachePolicyIgnoringLocalCacheData = 0,//忽略缓存，直接从网络获取
    PACachePolicyReturnCacheDataElseLoad,//优先获取缓存，缓存不存在则从网络获取
    PACachePolicyReturnCacheDataDontLoad,//只使用cache数据
};

typedef NS_ENUM(NSInteger, PADataErrCode) {
    PADataErrCodeNoNetwork = -1,
    PADataErrCodeRequestFailed = -2, //请求失败
    PADataErrCodeDataInvalid = -3,//请求数据不可用
};

@protocol PADataCenterDelegate<NSObject>
@optional
/**
 @result: 数据请求结果
 @info: 用户自定义信息
 */
-(void)onDataRequestFinished:(NSDictionary *)result userInfo:(NSDictionary*)info;
-(void)onDataRequestFailed:(NSDictionary *)result userInfo:(NSDictionary*)info;
@end


@interface PADataCenter : NSObject<ASIHTTPRequestDelegate>
@property (assign, nonatomic) id<PADataCenterDelegate> delegate;

- (void)requestWithUrl:(NSString *)url;

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params;

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params
              userInfo:(NSDictionary *)userInfo;

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params
              userInfo:(NSDictionary *)userInfo
           cachePolicy:(PACachePolicy)cachePolicy;

- (void)requestWithUrl:(NSString *)url              //协议地址
                params:(NSDictionary *)params       //参数
            httpMethod:(NSString *)httpMethod       //GET or POST, GET is default
              userInfo:(NSDictionary *)userInfo     //用户自定义信息
           cachePolicy:(PACachePolicy)cachePolicy;  //缓存策略
@end
