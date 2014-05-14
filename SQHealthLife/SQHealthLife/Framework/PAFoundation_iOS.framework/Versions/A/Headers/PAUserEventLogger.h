//
//  PAUserEventLogger.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAAbstractLogger.h"

@class PALogFileManager, PALogFileInfo;

#define kMaxUserEventLogFileSize (1*1024*1024) //1MB

@interface PAUserEventLogger : PAAbstractLogger
{
@private
    PALogFileManager *logFileManager_;
    PALogFileInfo    *currentLogFileInfo_;
    NSFileHandle     *currentLogFileHandle_;
    
    unsigned long long maximumFileSize_;
}

@property (readwrite, assign) unsigned long long maximumFileSize;

- (void) rollLogFile;

@end
