//
//  AdsMogoNetworkBaiDuAdapter.m
//  TestIntegralWall
//
//  Created by mogo_wenyand on 13-5-14.
//  Copyright (c) 2013年 孟令之. All rights reserved.
//

#import "AdsMogoNetworkBaiDuAdapter.h"

@implementation AdsMogoNetworkBaiDuAdapter
@synthesize baiduAdWall = _baiduWall;

+(void)load{
    [[AdsMoGoAdWallNetworkRegistry sharedRegistry] registerClass:self];
}

+(AdsMogoNetworkType)getAdsMogoNetworkType{
    return AdsMogoNetworkBaiDu;
}

-(void)getAdWall{
    _baiduWall = [[BaiduMobAdWall alloc] init];
    _baiduWall.delegate = self;
}

-(void)showAdWall{
    [_baiduWall showOffers];
    [adsMogoCore didSuccessOpenWall:configAdapter];
}


-(void)getPoint{
    [pointDelegate didGetPoint:[_baiduWall getPoints] andNetworkAdapterType:AdsMogoNetworkBaiDu];
}

-(void)spendPoint:(NSInteger)aPoint
{
    [_baiduWall spendPoints:aPoint];
}


#pragma mark BaiduMobAdWallDelegate
- (NSString *)publisherId
{
    return (NSString *) [[configAdapter objectForKey:@"key"] objectForKey:@"AppID"];
}


- (NSString*) appSpec
{
    return (NSString *) [[configAdapter objectForKey:@"key"] objectForKey:@"AppSEC"];
}

-(void) didGetPoints:(NSInteger)points
{
    NSLog(@"didGetPoints:%d",points);
}


@end
