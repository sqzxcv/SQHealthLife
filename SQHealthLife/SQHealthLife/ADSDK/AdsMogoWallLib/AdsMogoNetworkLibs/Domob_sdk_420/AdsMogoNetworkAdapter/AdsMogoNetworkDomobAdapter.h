//
//  AdsMogoNetworkDomobAdapter.h
//  TestIntegralWall
//
//  Created by Daxiong on 13-2-25.
//  Copyright (c) 2013年 Mogo. All rights reserved.
//

#import "AdsMogoNetworkAdapter.h"
#import "DMOfferWallViewController.h"
#import "DMOfferWallManager.h"

@interface AdsMogoNetworkDomobAdapter : AdsMogoNetworkAdapter<DMOfferWallDelegate,DMOfferWallManagerDelegate>{
    DMOfferWallViewController *_offerWallController;
    DMOfferWallManager *_offerWallManager;
}

@end
