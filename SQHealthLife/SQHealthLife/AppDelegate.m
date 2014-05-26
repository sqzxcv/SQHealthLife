//
//  HMAppDelegate.m
//  PAHealthManager
//
//  Created by ShengQiang on 14-3-25.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SQHomeViewController.h"
#import "SQGameViewController.h"
#import "SQMineViewController.h"
#import "HMMainViewController.h"
#import "SQDataCenter.h"

@implementation AppDelegate

-(void)dealloc
{
    [super dealloc];
    [_window release];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //自定义导航栏
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"jkb_home_titlebar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:RGBCOLOR(255, 255, 255),UITextAttributeFont:[UIFont systemFontOfSize:20]}];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//        UIImage *backImage = [[UIImage imageNamed:@"jkb_test_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [[UINavigationBar appearance] setBackIndicatorImage:backImage];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
//    }
//    else
//    {
//        UIImage *backImage = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34, 0, 0)];
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [self recievePushNotifyWithApplication:application WithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    [PAExceptionHandler installCrashMonitorWithParentViewController:self.window.rootViewController];
    PADebug(@"application did finish launching.");
    
    [self initTab];
    [self.window makeKeyAndVisible];
    
    [[SQDataCenter shareDataCenter] checkUpdateList];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}
#pragma mark - notity -

- (void)recievePushNotifyWithApplication:(UIApplication *)application  WithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    //    NSDate *now = [NSDate date];
    //    [self.notifyTools localNotify:@"aaa" byDate:[now dateByAddingTimeInterval:5]];
    NSDictionary *lauch = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (lauch != nil)
    {
        application.applicationIconBadgeNumber = 0;
        NSDictionary *dic=[lauch objectForKey:@"aps"];
        PAInfo(@"dic:%@",dic);
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceToken1 = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *device = [self getDevicetoken:deviceToken1];
}
- (void)uploadDeviceTokenFinish
{
    PAInfo(@"uploadDeviceTokenFinish");
}

- (void)uploadDeviceTokenFail
{
    PAInfo(@"uploadDeviceTokenFail");
}
- (NSString *) getDevicetoken:(NSString *)deviceToken
{
    /**去掉'<>' ' '*/
    NSString *string;
    string = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    return string;
}

#pragma mark - tabbar -

- (void) initTab
{
    SQHomeViewController  *homeViewController =  [[SQHomeViewController alloc] init];
    SQMineViewController  *mineViewController =  [[SQMineViewController alloc] init];
    SQGameViewController *gameViewController = [[SQGameViewController alloc] init];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController *partyNav = [[UINavigationController alloc] initWithRootViewController:gameViewController];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    
    [homeViewController release];
    [gameViewController release];
    [mineViewController release];
    
    HMMainViewController *mainViewController = [[[HMMainViewController alloc] init] autorelease];
    mainViewController.viewControllers = @[homeNav,partyNav,mineNav];
    
    [homeNav release];
    [partyNav release];
    [mineNav release];
    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"vc_home", nil)];
    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"vc_party", nil)];
    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"mine", nil)];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor colorWithRed:68/255.0 green:118/255.0 blue:25/255.0 alpha:1], UITextAttributeTextColor, nil]
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor colorWithRed:88/255.0 green:204/255.0 blue:0/255.0 alpha:1], UITextAttributeTextColor, nil]
//                                             forState:UIControlStateSelected];
//    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"jkb_home_home"] withFinishedUnselectedImage:[UIImage imageNamed:@"jkb_home_home_hl"]];
//    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"jkb_home_discovery"] withFinishedUnselectedImage:[UIImage imageNamed:@"jkb_home_discovery_hl"]];
//    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"jkb_home_mine"] withFinishedUnselectedImage:[UIImage imageNamed:@"jkb_home_mine_hl"]];
    //    [(UITabBarItem *)[mainViewController.tabBar.items objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
//    [mainViewController.tabBar setBackgroundImage:[UIImage imageNamed:@"jkb_home_above_titlebg"]];

//    mainViewController.tabBar.frame = CGRectMake(0, SCREEN_SIZE.height-54, 320, 54);
//    UIView * transitionView = [[mainViewController.view subviews] objectAtIndex:0];
//    CGRect rect = transitionView.frame;
//    rect.size.height = SCREEN_SIZE.height-54;
//    transitionView.frame = rect;
    
    //    [mainViewController.tabBar setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.2]];
    //    [mainViewController.tabBar setAlpha:0.2];
    self.window.rootViewController = mainViewController;
}

@end
