//
//  HMMainViewController.m
//  PAHealthManager
//
//  Created by ShengQiang on 14-4-8.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "HMMainViewController.h"
#import "SQHomeViewController.h"
#import "AppDelegate.h"

@interface HMMainViewController () <UITabBarControllerDelegate>

@end

@implementation HMMainViewController

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
//    self.tabBar = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.s
    self.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self disappearViewAtIndex:self.selectedIndex];
}

#pragma mark - UI -

#pragma mark - Private methods
- (void)disappearViewAtIndex:(NSUInteger)index
{
    if (self.selectedIndex == index)
    {
        return;
    }
    UIViewController *oldSelectedVC = self.viewControllers[index];
    [oldSelectedVC viewWillDisappear:YES];
    self.selectedIndex = index;
}

#pragma mark - tab delegate -

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}


@end
