//
//  SQHomeViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQDataCenter.h"
#import "HLDocumentReaderViewController.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"


@interface SQHomeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
AdMoGoDelegate,
AdMoGoWebBrowserControllerUserDelegate>

@property  (nonatomic, retain)  AdMoGoView *adView;

@property (nonatomic, retain) NSArray * articles;

@end

@implementation SQHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = NSLocalizedString(@"Articles", @"Articles");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.articles = [NSArray arrayWithContentsOfFile:[[SQDataCenter shareDataCenter] articlesFullPath]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.adView = [[[AdMoGoView alloc] initWithAppKey:@"307db46331814841b77b0f5f822c5025"
                                               adType:AdViewTypeNormalBanner
                                   adMoGoViewDelegate:self] autorelease];
    self.adView.adWebBrowswerDelegate = self;
    [self.view addSubview:self.adView];
    // 广告的位置设置
    
    UIView *selfview = self.view;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView, _adView,selfview);
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:viewsDict];
    arr = [arr arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]-0-[_adView(44)]-0-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:viewsDict]];
    arr = [arr arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:viewsDict]];
    
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:arr];
    [self.view setNeedsUpdateConstraints];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_articles release];
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier] autorelease];
    }
    NSDictionary *article = self.articles[indexPath.row];
    cell.textLabel.text = article[kResourceTitle];
    cell.detailTextLabel.text = article[kResourceType];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLDocumentReaderViewController *readerViewController = [[[HLDocumentReaderViewController alloc] init] autorelease];
    readerViewController.document =  [self.articles objectAtIndex:indexPath.row];
    readerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readerViewController animated:YES];
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

//- (CGSize)adMoGoCustomSize
//{
//    
//}

@end
