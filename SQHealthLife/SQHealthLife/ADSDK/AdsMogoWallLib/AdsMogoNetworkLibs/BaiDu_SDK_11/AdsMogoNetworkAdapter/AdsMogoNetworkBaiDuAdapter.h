//
//  AdsMogoNetworkBaiDuAdapter.h
//  TestIntegralWall
//
//  Created by mogo_wenyand on 13-5-14.
//  Copyright (c) 2013年 孟令之. All rights reserved.
//

#import "AdsMogoNetworkAdapter.h"
#import "BaiduMobAdWall.h"
#import "BaiduMobAdWallDelegateProtocol.h"

@interface AdsMogoNetworkBaiDuAdapter : AdsMogoNetworkAdapter<BaiduMobAdWallDelegate>
{
    BaiduMobAdWall *_baiduWall;
}
@property (nonatomic,assign) BaiduMobAdWall *baiduAdWall;
@end
