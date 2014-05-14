//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PALogFormatterProtocol;
@protocol PALoggerProtocol;

#ifdef PA_DEBUG
#define PALogDebug(fmt, ...) do{NSLog((fmt), ##__VA_ARGS__);} while(0)
#else
#define PALogDebug(fmt, ...) do{}while(0)
#endif

#if TARGET_OS_IPHONE

// Compiling for iPod/iPhone/iPad

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000 // 4.0 supported

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000 // 4.0 supported and required

#define PA_GCD_AVAILABLE      YES
#define GCD_MAYBE_AVAILABLE   1
#define GCD_MAYBE_UNAVAILABLE 0

#else                                         // 4.0 supported but not required

#ifndef NSFoundationVersionNumber_iPhoneOS_4_0
#define NSFoundationVersionNumber_iPhoneOS_4_0 751.32
#endif

#define PA_GCD_AVAILABLE     (NSFoundationVersionNumber >= NSFoundationVersionNumber_iPhoneOS_4_0)
#define GCD_MAYBE_AVAILABLE   1
#define GCD_MAYBE_UNAVAILABLE 1

#endif

#else                                        // 4.0 not supported

#define PA_GCD_AVAILABLE      NO
#define GCD_MAYBE_AVAILABLE   0
#define GCD_MAYBE_UNAVAILABLE 1

#endif

#else

// Compiling for Mac OS X

#if MAC_OS_X_VERSION_MAX_ALLOWED >= 1060 // 10.6 supported

#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060 // 10.6 supported and required

#define PA_GCD_AVAILABLE      YES
#define GCD_MAYBE_AVAILABLE   1
#define GCD_MAYBE_UNAVAILABLE 0

#else                                     // 10.6 supported but not required

#ifndef NSFoundationVersionNumber10_6
#define NSFoundationVersionNumber10_6 751.00
#endif

#define PA_GCD_AVAILABLE     (NSFoundationVersionNumber >= NSFoundationVersionNumber10_6)
#define GCD_MAYBE_AVAILABLE   1
#define GCD_MAYBE_UNAVAILABLE 1

#endif

#else                                    // 10.6 not supported

#define PA_GCD_AVAILABLE      NO
#define GCD_MAYBE_AVAILABLE   0
#define GCD_MAYBE_UNAVAILABLE 1

#endif

#endif

/*
 // Uncomment for quick temporary test to see if it builds for older OS targets
 #undef PA_GCD_AVAILABLE
 #undef GCD_MAYBE_AVAILABLE
 #undef GCD_MAYBE_UNAVAILABLE
 
 #define PA_GCD_AVAILABLE      NO
 #define GCD_MAYBE_AVAILABLE   0
 #define GCD_MAYBE_UNAVAILABLE 1
 */

@class PALogMessage;

@protocol PALoggerProtocol;
@protocol PALogFormatter;

/**
 * Define our big multiline macros so all the other macros will be easy to read.
 **/

#define LOG_MACRO(isSynchronous, lvl, ctx, fnct, frmt, ...) \
[PALog log:isSynchronous                                     \
     level:lvl                                               \
   context:ctx                                               \
      file:__FILE__                                          \
  function:fnct                                              \
      line:__LINE__                                          \
    format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MACRO(sync, lvl, ctx, frmt, ...) \
LOG_MACRO(sync, lvl, ctx, sel_getName(_cmd), frmt, ##__VA_ARGS__)

#define LOG_C_MACRO(sync, lvl, ctx, frmt, ...) \
LOG_MACRO(sync, lvl, ctx, __FUNCTION__, frmt, ##__VA_ARGS__)

#define  SYNC_LOG_OBJC_MACRO(lvl, ctx, frmt, ...) \
LOG_OBJC_MACRO(YES, lvl, ctx, frmt, ##__VA_ARGS__)

#define ASYNC_LOG_OBJC_MACRO(lvl, ctx, frmt, ...) \
LOG_OBJC_MACRO( NO, lvl, ctx, frmt, ##__VA_ARGS__)

#define  SYNC_LOG_C_MACRO(lvl, ctx, frmt, ...) \
LOG_C_MACRO(YES, lvl, ctx, frmt, ##__VA_ARGS__)

#define ASYNC_LOG_C_MACRO(lvl, ctx, frmt, ...) \
LOG_C_MACRO( NO, lvl, ctx, frmt, ##__VA_ARGS__)


#define LOG_MAYBE(sync, lvl, ctx, fnct, frmt, ...) \
LOG_MACRO(sync, lvl, ctx, fnct, frmt, ##__VA_ARGS__)

#define LOG_OBJC_MAYBE(sync, lvl, ctx, frmt, ...) \
LOG_MAYBE(sync, lvl, ctx, sel_getName(_cmd), frmt, ##__VA_ARGS__)

#define LOG_C_MAYBE(sync, lvl, ctx, frmt, ...) \
LOG_MAYBE(sync, lvl, ctx, __FUNCTION__, frmt, ##__VA_ARGS__)

#define  SYNC_LOG_OBJC_MAYBE(lvl, ctx, frmt, ...) \
LOG_OBJC_MAYBE(YES, lvl, ctx, frmt, ##__VA_ARGS__)

#define ASYNC_LOG_OBJC_MAYBE(lvl, ctx, frmt, ...) \
LOG_OBJC_MAYBE( NO, lvl, ctx, frmt, ##__VA_ARGS__)

#define  SYNC_LOG_C_MAYBE(lvl, ctx, frmt, ...) \
LOG_C_MAYBE(YES, lvl, ctx, frmt, ##__VA_ARGS__)

#define ASYNC_LOG_C_MAYBE(lvl, ctx, frmt, ...) \
LOG_C_MAYBE( NO, lvl, ctx, frmt, ##__VA_ARGS__)

/**
 * Define our standard log levels.
 * 
 * We default to only 4 levels because it makes it easier for beginners
 * to make the transition to a logging framework.
 * 
 * More advanced users may choose to completely customize the levels (and level names) to suite their needs.
 * For more information on this see the "Custom Log Levels" page:
 * http://code.google.com/p/cocoalumberjack/wiki/CustomLogLevels
 * 
 * Advanced users may also notice that we're using a bitmask.
 * This is to allow for custom fine grained logging:
 * http://code.google.com/p/cocoalumberjack/wiki/FineGrainedLogging
 **/

#define LOG_FLAG_DEBUG    (1 << 0)  // 0...00001
#define LOG_FLAG_INFO     (1 << 1)  // 0...00010
#define LOG_FLAG_AUDIT    (1 << 2)  // 0...00100
#define LOG_FLAG_WARN     (1 << 3)  // 0...01000
#define LOG_FLAG_ERROR    (1 << 4)  // 0...10000

#define LOG_FLAG_STATUS   (1 << 5)  // 0..100000
#define LOG_FLAG_EVENT    (1 << 6)  // 0.1000000


enum {
	LOG_LEVEL_OFF  = 0,
	LOG_LEVEL_DEBUG = (LOG_FLAG_DEBUG | LOG_FLAG_INFO | LOG_FLAG_AUDIT | LOG_FLAG_WARN | LOG_FLAG_ERROR),   // 0...11111 --> 31
	LOG_LEVEL_INFO = (LOG_FLAG_INFO | LOG_FLAG_AUDIT | LOG_FLAG_WARN | LOG_FLAG_ERROR),                     // 0...11110 --> 30
	LOG_LEVEL_AUDIT = (LOG_FLAG_AUDIT | LOG_FLAG_WARN | LOG_FLAG_ERROR),                                    // 0...11100 --> 28
	LOG_LEVEL_WARN = (LOG_FLAG_WARN | LOG_FLAG_ERROR),                                                      // 0...11000 --> 24
	LOG_LEVEL_ERROR = (LOG_FLAG_ERROR),                                                                     // 0...10000 --> 16
    LOG_LEVEL_USER_DATA = (LOG_FLAG_STATUS | LOG_FLAG_EVENT)                                                // 0.1100000 --> 192
};
typedef NSUInteger PALogLevel;

#define PALogInfo(flag, format,...)     ASYNC_LOG_OBJC_MAYBE(flag,            0, format, ##__VA_ARGS__)
#define PADebug(format,...)             ASYNC_LOG_OBJC_MAYBE(LOG_FLAG_DEBUG,  0, format, ##__VA_ARGS__)
#define PAInfo(format,...)              ASYNC_LOG_OBJC_MAYBE(LOG_FLAG_INFO,   0, format, ##__VA_ARGS__)
#define PAAudit(format,...)             ASYNC_LOG_OBJC_MAYBE(LOG_FLAG_AUDIT,  0, format, ##__VA_ARGS__)
#define PAWarning(format,...)           ASYNC_LOG_OBJC_MAYBE(LOG_FLAG_WARN,   0, format, ##__VA_ARGS__)
#define PAError(format,...)             SYNC_LOG_OBJC_MAYBE(LOG_FLAG_ERROR,   0, format, ##__VA_ARGS__)
#define PAEvent(ID)                     ASYNC_LOG_OBJC_MAYBE(LOG_FLAG_EVENT,  0, ([NSString stringWithFormat:@"%d-%d", (ID), ((int)[[NSDate date] timeIntervalSince1970])]))
#define PAStatus(ID, DATA)              SYNC_LOG_OBJC_MAYBE(LOG_FLAG_STATUS,  0, ([NSString stringWithFormat:@"%d-%d", (ID), (DATA)]))

#define PACLogInfo(flag, format,...)    ASYNC_LOG_C_MAYBE(flag,               0, format, ##__VA_ARGS__)
#define PACDebug(format,...)            ASYNC_LOG_C_MAYBE(LOG_FLAG_DEBUG,     0, format, ##__VA_ARGS__)
#define PACInfo(format,...)             ASYNC_LOG_C_MAYBE(LOG_FLAG_INFO,      0, format, ##__VA_ARGS__)
#define PACAudit(format,...)            ASYNC_LOG_C_MAYBE(LOG_FLAG_AUDIT,     0, format, ##__VA_ARGS__)
#define PACWarning(format,...)          ASYNC_LOG_C_MAYBE(LOG_FLAG_WARN,      0, format, ##__VA_ARGS__)
#define PACError(format,...)            SYNC_LOG_C_MAYBE(LOG_FLAG_ERROR,      0, format, ##__VA_ARGS__)
#define PACEvent(ID)                    ASYNC_LOG_C_MAYBE(LOG_FLAG_EVENT,     0, ([NSString stringWithFormat:@"%d-%d", (ID), ((int)[[NSDate date] timeIntervalSince1970])]))
#define PACStatus(ID, DATA)             SYNC_LOG_OBJC_MAYBE(LOG_FLAG_STATUS,  0, ([NSString stringWithFormat:@"%d-%d", (ID), (DATA)]))


////////////////////////////////////////////////////////////////////////////////
#pragma mark --
#pragma mark -- PALog Definition --
////////////////////////////////////////////////////////////////////////////////

@interface PALog : NSObject 
{

}

// use this method to replace the Info.plist key @PALogLevel
// default is LOG_LEVEL_OFF
+ (int) currentLogLevel;
+ (void) addFilterLogLevelMask:(int) levelMask;
+ (void) removeFilterLogLevelMask:(int) levelMask;
+ (void) filterTheLogWithLevelMask:(int) levelMask;
+ (void) setDescription:(NSString *) description forLevel:(int) level;

#if GCD_MAYBE_AVAILABLE

/**
 * Provides access to the underlying logging queue.
 * This may be helpful to Logger classes for things like thread synchronization.
 **/

+ (dispatch_queue_t) loggingQueue;

#endif

#if GCD_MAYBE_UNAVAILABLE

/**
 * Provides access to the underlying logging thread.
 * This may be helpful to Logger classes for things like thread synchronization.
 **/

+ (NSThread *) loggingThread;

#endif

/**
 * Logging Primitive.
 * 
 * This method is used by the macros above.
 * It is suggested you stick with the macros as they're easier to use.
 **/

+ (void) log:(BOOL) synchronous
       level:(int) level
     context:(int) context
        file:(const char *) file
    function:(const char *) function
        line:(int) line
      format:(NSString *) format, ...;

/**
 * Since logging can be asynchronous, there may be times when you want to flush the logs.
 * The framework invokes this automatically when the application quits.
 **/

+ (void) flushLog;

/** 
 * Loggers
 * 
 * If you want your log statements to go somewhere,
 * you should create and add a logger.
 **/

+ (void) addLogger:(id <PALoggerProtocol>) logger;
+ (void) removeLogger:(id <PALoggerProtocol>) logger;

+ (void) removeAllLoggers;

@end














