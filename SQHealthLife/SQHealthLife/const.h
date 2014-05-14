//
//  const.h
//  PAHealthManager
//
//  Created by Steven on 14-4-2.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#ifndef PAHealthManager_const_h
#define PAHealthManager_const_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define APP_ROOTVC [(HMAppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController
#define kTabBarHeight 48.0f
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define COLUMN_RED @"jkb_home_head_statistics_zhuzi_red@2x"
#define COLUMN_GREEN @"jkb_home_head_statistics_zhuzi_green@2x"
#define COLUMN_YELLOW @"jkb_home_head_statistics_zhuzi_yellow@2x"
#define COLUMN_HIGHLIGHT @"jkb_home_head_statistics_zhuzi_black@2x"
#define COLUMN_TOP_RED @"jkb_home_head_statistics_zhuzi_red1"
#define COLUMN_TOP_GREEN @"jkb_home_head_statistics_zhuzi_green1"
#define COLUMN_TOP_YELLOW @"jkb_home_head_statistics_zhuzi_yellow1"
#define COLUMN_TOP_HIGHLIGHT @"jkb_home_head_statistics_zhuzi_black1"
#define COLUMN_RED_COLOR [UIColor colorWithRed:248/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]
#define COLUMN_GREEN_COLOR [UIColor colorWithRed:81/255.0 green:192/255.0 blue:14/255.0 alpha:1.0]
#define COLUMN_YELLOW_COLOR [UIColor colorWithRed:254/255.0 green:216/255.0 blue:126/255.0 alpha:1.0]
#define COLUMN_HIGHLIGHT_COLOR [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1.0]

#define ReturnNOIfHostNotReachable if(![[AFNetworkReachabilityManager sharedManager] isReachable]){PAInfo(@"Host is not reachable");return NO;}
#define ReturnIfHostNotReachable if(![[AFNetworkReachabilityManager sharedManager] isReachable]){PAInfo(@"Host is not reachable");return;}
#define ReturnNilIfHostNotReachable if(![[AFNetworkReachabilityManager sharedManager] isReachable]){PAInfo(@"Host is not reachable");return nil;}

#define kProjName @"HealthManager"
#endif
