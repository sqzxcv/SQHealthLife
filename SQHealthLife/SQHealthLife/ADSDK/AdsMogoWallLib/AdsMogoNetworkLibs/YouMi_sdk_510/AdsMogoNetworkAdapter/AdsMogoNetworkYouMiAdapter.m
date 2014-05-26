//
//  AdsMogoNetworkYouMiAdapter.m
//  TestIntegralWall
//
//  Created by Daxiong on 13-2-21.
//  Copyright (c) 2013年 Mogo. All rights reserved.
//

#import "AdsMogoNetworkYouMiAdapter.h"

@implementation AdsMogoNetworkYouMiAdapter
+(void)load{
    [[AdsMoGoAdWallNetworkRegistry sharedRegistry] registerClass:self];
}

+(AdsMogoNetworkType)getAdsMogoNetworkType{
    return AdsMogoNetworkYouMi;
}

-(void)getAdWall{
    [YouMiConfig setUseInAppStore:YES];
    [YouMiConfig launchWithAppID:[[configAdapter objectForKey:@"key"] objectForKey:@"AppKey"] appSecret:[[configAdapter objectForKey:@"key"] objectForKey:@"SecretKey"]];
    [YouMiWall enable];
    [YouMiPointsManager enable];
    [YouMiPointsManager enableManually];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
}

-(void)showAdWall{ 
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米积分墙已显示");
        [adsMogoCore didSuccessOpenWall:configAdapter];
    } didDismissBlock:^{
        NSLog(@"有米积分墙已退出");
        [adsMogoCore didFailedGetWall:@"请求有米积分墙失败"];
    }];}


-(void)getPoint{
    NSInteger *point = [YouMiPointsManager pointsRemained];    
    [pointDelegate didGetPoint:point andNetworkAdapterType:AdsMogoNetworkYouMi];
}


-(void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *freshPoints = [dict objectForKey:kYouMiPointsManagerFreshPointsKey];    
    // 这里的积分不应该拿来使用, 只是用于告知一下用户, 可以通过 [YouMiPointsManager spendPoints:]来使用积分
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:[NSString stringWithFormat:@"获得%@积分", freshPoints] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
