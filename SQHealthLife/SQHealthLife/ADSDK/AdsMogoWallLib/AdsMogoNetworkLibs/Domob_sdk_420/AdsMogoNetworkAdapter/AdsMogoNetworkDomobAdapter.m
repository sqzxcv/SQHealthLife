//
//  AdsMogoNetworkDomobAdapter.m
//  TestIntegralWall
//
//  Created by Daxiong on 13-2-25.
//  Copyright (c) 2013年 Mogo. All rights reserved.
//

#import "AdsMogoNetworkDomobAdapter.h"
#import "DMOfferWallManagerDelegate.h"
#import "DMOfferWallManager.h"

@implementation AdsMogoNetworkDomobAdapter
+(void)load{
    [[AdsMoGoAdWallNetworkRegistry sharedRegistry] registerClass:self];
}

+(AdsMogoNetworkType)getAdsMogoNetworkType{
    return AdsMogoNetworkDomob;
}
/**
 *初始化Adapter
 *请勿改动
 */
-(id)initAdsMogoNetworkAdapterByConfig:(NSDictionary *)config core:(AdsMogoCoreControl *)core pointDelegate:(id<AdsMogoPointDelegate>)aPointDelegate wallDelegate:(id<AdsMogoIntegralWallDelegate>)aWallDelegate{
    if (!self) {
        self = [super init];
    }
    if (self) {
        adsMogoCore = core;
        pointDelegate = aPointDelegate;
        wallDelegate = aWallDelegate;
        if (configAdapter) {
            [configAdapter release];
            configAdapter = nil;
        }
        configAdapter = [[NSDictionary alloc] initWithDictionary:config];
    }
    return self;
}

-(void)getAdWall{
    _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:[configAdapter objectForKey:@"key"]];
    _offerWallController.delegate = self;
    
    
    _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:[configAdapter objectForKey:@"key"] userId:nil];
    _offerWallManager.delegate = self;


}

-(void)showAdWall{
    [_offerWallController presentOfferWallWithViewController:(UIViewController *)[wallDelegate adsWallNeedController]];
}

-(void)getPoint{
    [_offerWallManager requestOnlinePointCheck];
}
-(void)dealloc{
    if (_offerWallController) {
        _offerWallController.delegate = nil;
        [_offerWallController release],_offerWallController = nil;
    }
    if (_offerWallManager) {
        [_offerWallManager release],_offerWallManager=nil;
    }

    [super dealloc];
}
#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed{
    NSLog(@"%d",totalPoint);
    [pointDelegate didGetPoint:totalPoint andNetworkAdapterType:AdsMogoNetworkDomob];
}
// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
-(void)offerWallDidFailCheckPointWithError:(NSError *)error{
     [pointDelegate didFaildGetPointNetworkAdapterType:AdsMogoNetworkDomob];
}
#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed{
    
}
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error{

}


#pragma mark CheckOfferWall Enable Callbacks
// 获取积分墙可用状态的回调。
// Called after get OfferWall enable state.
- (void)offerWallDidCheckEnableState:(BOOL)enable{

}

#pragma mark -
#pragma mark Domob delegate
// 积分墙开始加载数据。
// Offer wall starts to work.
- (void)offerWallDidStartLoad{
}
- (void)offerWallDidFinishLoad{
    [adsMogoCore didSuccessOpenWall:configAdapter];
}
// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。建议在此隐藏积分墙入口Button。
// Failed to load offer wall. You should set THE IBOutlet.hidden to YES in this callback.
- (void)offerWallDidFailLoadWithError:(NSError *)error{
    if (error) {
        NSLog(@"domob wall error-->%@",error);
    }
    [adsMogoCore didFailedGetWall:@"domob wall error"];
}
// 关闭积分墙页面。
// Offer wall closed.
- (void)offerWallDidClosed{
    NSLog(@"关闭多盟积分墙");
}

@end
