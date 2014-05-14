//
//  PALogMessage.h
//  PALog
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALog.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark --
#pragma mark -- PALogMessage  Definition --
////////////////////////////////////////////////////////////////////////////////

// Note: The last time I benchmarked the performance of direct access vs atomic property access,
// direct access was over twice as fast on the desktop and over 6 times as fast on the iPhone.

@interface PALogMessage: NSObject
{
@public
    int logLevel;
    NSString *logLevelDesc;
    
    int logContext;
    int lineNumber;
    mach_port_t machThreadID;
    
    const char  *fileName;
    const char  *functionName;
    
    NSString    *logMessage;
    NSDate      *timestamp;
}

- (id) initWithLogMsg:(NSString *) logMsg
                level:(int) lv
            levelDesc:(NSString *) lvDesc
              context:(int) lc
                 file:(const char *) file
             function:(const char *) function
                 line:(int) line;

- (NSString *) threadID;

@end
