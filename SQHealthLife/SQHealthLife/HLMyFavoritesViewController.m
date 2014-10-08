//
//  HLMyFavoritesViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/29/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "HLMyFavoritesViewController.h"
#import "HLDocumentReaderViewController.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "HLImageBrowserViewController.h"
#import "KTPhotoBrowser/KTPhotoScrollViewController.h"

@interface HLMyFavoritesViewController ()
<UITableViewDataSource,
UITableViewDelegate,
AdMoGoDelegate,
AdMoGoWebBrowserControllerUserDelegate>


@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) AdMoGoView *adView;
@property (nonatomic, retain) NSArray *allResources;

@end


@implementation HLMyFavoritesViewController

- (void) dealloc
{
    [_allResources release];
    [_tableView release];
    [_adView release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Favorite", @"Favorite");
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 416) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.adView = [[[AdMoGoView alloc] initWithAppKey:@"307db46331814841b77b0f5f822c5025"
                                               adType:AdViewTypeNormalBanner
                                   adMoGoViewDelegate:self] autorelease];
    self.adView.adWebBrowswerDelegate = self;
    [self.view addSubview:self.adView];
    // 广告的位置设置
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIView *selfview = self.view;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView, _adView,selfview);
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:viewsDict];
    arr = [arr arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_tableView]-0-[_adView(44)]-0-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:viewsDict]];
    arr = [arr arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:viewsDict]];
    
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:arr];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *allFavorite = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    self.allResources = [self sortResourceByTimeAboutAllFavorites:allFavorite];
    self.navigationController.toolbarHidden = YES;
}

- (void) viewDidAppear:(BOOL) animated
{
    self.tableView.contentOffset = CGPointZero;
    [super viewDidAppear:animated];

}

- (NSArray *) sortResourceByTimeAboutAllFavorites:(NSDictionary *) allFavorites
{
//    NSMutableArray *
    NSArray *allKeys = [allFavorites allKeys];
    allKeys = [allKeys sortedArrayUsingFunction:doubleSort context:NULL];
    NSMutableArray *allResources = [NSMutableArray arrayWithCapacity:[allKeys count]];
    for (int i = 0; i < [allKeys count]; i ++)
    {
        [allResources addObject:allFavorites[allKeys[i]]];
    }
    return allResources;
}

NSInteger doubleSort(id num1, id num2, void *context)
{
    double v1 = [num1 intValue];
    double v2 = [num2 intValue];
    if (v1 < v2)
    {
        return NSOrderedDescending;
    }
    else if (v1 > v2)
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allResources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier] autorelease];
    }
    NSDictionary *resource = self.allResources[indexPath.row];
    cell.textLabel.text = resource[kResourceTitle];
    cell.detailTextLabel.text = NSLocalizedString(resource[kResourceSubType], resource[kResourceType]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *resource = self.allResources[indexPath.row];
    NSString *type = resource[kResourceType];
    if (YES == [type isEqualToString:kResourceArticleType] ||
        YES == [type isEqualToString:kResourceNovelType] ||
        YES == [type isEqualToString:kResourceJokeType])
    {
        HLDocumentReaderViewController *readerViewController = [[[HLDocumentReaderViewController alloc] init] autorelease];
        readerViewController.document =  resource;
        readerViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:readerViewController animated:YES];
        
    }
    else if (YES == [type isEqualToString:kResourcePhotoType] ||
             YES == [type isEqualToString:kResourceSeedType])
    {
//        HLImageBrowserViewController *imageBrowser = [[[HLImageBrowserViewController alloc] init] autorelease];
//        imageBrowser.item = resource;
//        imageBrowser.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:imageBrowser animated:YES];
        KTPhotoScrollViewController *viewController = [[[KTPhotoScrollViewController alloc] initWithDataSource:nil andStartWithPhotoAtIndex:0] autorelease];
        viewController.resourceItem = resource;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - ad delegate

/*
 返回广告rootViewController old code
 */
- (UIViewController *)viewControllerForPresentingModalView
{
    return self.navigationController;
}

/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"广告开始请求回调");
}

/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"广告接收成功回调");
}

/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error
{
    NSLog(@"广告接收失败回调");
}

/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"点击广告回调");
}



@end
