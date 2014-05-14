//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// Log Files will be seperated by Day.

#define kLogRootName @"PABasicLogs"
#define kLogNormalName @"NormalLogs"
#define kLogCustomName @"CustomLogs"
#define kLogCollectedName @"CollectedFile"
#define kLogUserEventName @"UserEventLogs"
#define kLogUserStatusName @"UserStatusLogs"

#define kLogFileMaxNumber   (2) // 2 files

// Log Floder Structure: 
// /kLogRootName
// /kLogRootName/kLogNormalName
// /kLogRootName/kLogCustomName
// /kLogRootName/kLogCollectedName

@interface PALogFileManager : NSObject 
{
@private
	NSUInteger  maximumNumberOfLogFiles_;
}

@property (readwrite, assign) NSUInteger maximumNumberOfLogFiles;


- (NSArray *) sortedLogFileInfos;
- (NSArray *) sortedUserEventFileInfos;
- (NSArray *) sortedUserStatusFileInfos;

+ (NSString *) applicationUserEventFolder;
+ (NSString *) applicationUserStatusFolder;
+ (NSString *) applicationLogFloder;
// any file in applicationCustomLogFloder floder will be treated as custom log by LogFileCollector.
+ (NSString *) applicationCustomLogFloder;
+ (NSString *) applicationCollectedLogFloder; 

- (NSString *) createNewLogFile;
- (NSString *) createNewUserEventFile;
- (NSString *) createNewUserStatusFile;

+ (void) clearAllNormalLogs;
+ (void) clearAllUserEventLogs;
+ (void) clearAllUserStatusLogs;
+ (void) clearAllCustomLogs;
+ (void) clearAllLogs;
@end