//
//  LKViewController.m
//  lottery
//
//  Created by upin on 13-3-6.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "LKViewController.h"

@interface LKViewController ()

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lotteryView setDialPanel:[UIImage imageNamed:@"dial_panel"] pointer:[UIImage imageNamed:@"dialplate"]];
    self.lotteryView.endEvent = ^(float angle){
        self.lb_angle.text = [NSString stringWithFormat:@"停止的角度: %f",(angle/M_PI) *180];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lotteryView release];
    [_lb_angle release];
    [super dealloc];
}
- (IBAction)bt_start:(id)sender {
    [self.lotteryView start];
}
@end
