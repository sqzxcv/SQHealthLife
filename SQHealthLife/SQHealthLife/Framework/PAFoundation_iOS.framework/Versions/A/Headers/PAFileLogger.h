//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAAbstractLogger.h"

@class PALogFileManager, PALogFileInfo;

#define kMaxNormalLogFileSize (5*1024*1024) // 5MB
//#define kMaxNormalLogFileSize (8*1024) // 8KB. for debugging.

#define kLogFileSizeCheckTime (24*60*60) // one day
//#define kLogFileSizeCheckTime (2) // 2s. for debugging.

@interface PAFileLogger : PAAbstractLogger <PALoggerProtocol>
{
@private
    PALogFileManager    *logFileManager_;
    PALogFileInfo       *currentLogFileInfo_;
    NSFileHandle        *currentLogFileHandle_;
    
    NSTimer             *rollingTimer_;
    
    unsigned long long  maximumFileSize_;
    NSTimeInterval      rollingFrequency_;
}

@property (readwrite, assign) unsigned long long maximumFileSize;
@property (readwrite, assign) NSTimeInterval rollingFrequency;

- (void) rollLogFile;

@end
