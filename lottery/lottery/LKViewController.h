//
//  LKViewController.h
//  lottery
//
//  Created by upin on 13-3-6.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLotteryView.h"
@interface LKViewController : UIViewController
@property (retain, nonatomic) IBOutlet LKLotteryView *lotteryView;
- (IBAction)bt_start:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lb_angle;

@end
