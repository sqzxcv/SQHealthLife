//
//  PAExceptionHanlder.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PALastRunCrashed;

@class PAException;
@class GTMSignalHandler;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
@interface PAExceptionHandler : NSObject <UIAlertViewDelegate>
#else
@interface PAExceptionHandler : NSObject
#endif
{
@private
	PAException *exception_;
	NSString	*logString_;
	
	GTMSignalHandler *sigsegv_;
	GTMSignalHandler *sigbus_;

}
@property (readonly, nonatomic) PAException *exception;
@property (nonatomic, retain) NSString	*logString;

+ (PAExceptionHandler *) sharedHandler;

+ (void) onBCRException:(NSException *) ex reThrow:(BOOL) bthrow output:(const char *) fileName lineNumber:(int) lineNumber;
+ (void) installSIGSEGV;
+ (void) installSIGBUS;
+ (void) installUncatghtException;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

#define PABasicDiskMonitorDiskWarningBytes (500*1024)			// 500 * 1024 KB. 

// These methods may be called in applicationDidFinishLaunching
+ (void) installDiskMonitor;
+ (void) resetDiskMonitorNeverRemindMeWarning;
+ (BOOL) checkDiskFreeSpace:(double)minSpace;	// in KB
+ (void) installCrashMonitorWithParentViewController:(UIViewController *)controller;
+ (void) setNeedSendCrashReportInNextLaunch;
+ (void) installMemoryWarningException;

#endif

@end


#define OnPAException(exception) [PAExceptionHandler onBCRException:(exception) reThrow:NO output:__FILE__ lineNumber:__LINE__]

#define OnPAExceptionRethrow(exception) [PAExceptionHandler onBCRException:(exception) reThrow:YES output:__FILE__ lineNumber:__LINE__]