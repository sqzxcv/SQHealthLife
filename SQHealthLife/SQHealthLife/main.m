//
//  main.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/3/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool
    {
        [PAExceptionHandler installSIGBUS];
        [PAExceptionHandler installSIGSEGV];
        [PAExceptionHandler installUncatghtException];
        [PALog filterTheLogWithLevelMask:31];
        PACInfo(@"<--------------Application Started---------------->");
        BOOL flag = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        PACInfo(@"<--------------Applicatioin End------------------->");
        return flag;

    }
}
