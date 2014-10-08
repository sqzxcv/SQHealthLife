//
//  AppDelegate.m
//  HealthLifeDataGenerate
//
//  Created by ShengQiang on 5/27/14.
//  Copyright (c) 2014 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) IBOutlet BaseViewController *baseViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.baseViewController = [[BaseViewController alloc] init];
    [self.window.contentView addSubview:self.baseViewController.view];
    self.baseViewController.view.frame = ((NSView *) self.window.contentView).bounds;
}

@end
