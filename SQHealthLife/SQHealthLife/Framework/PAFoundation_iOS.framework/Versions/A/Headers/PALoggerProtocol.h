//
//  PALoggerProtocol.h
//  PALog
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "PALogFormatterProtocol.h"
#import "PALog.h"

@class PALogMessage;

@protocol PALoggerProtocol <NSObject>

@required

- (void) logMessage:(PALogMessage *) logMessage;
- (id<PALogFormatterProtocol>) logFormatter;
- (void) setLogFormatter:(id<PALogFormatterProtocol>) formatter;

@optional

/**
 * Since logging is asynchronous, adding and removing loggers is also asynchronous.
 * In other words, the loggers are added and removed at appropriate times with regards to log messages.
 * 
 * - Loggers will not receive log messages that were executed prior to when they were added.
 * - Loggers will not receive log messages that were executed after they were removed.
 * 
 * These methods are executed in the logging thread/queue.
 * This is the same thread/queue that will execute every logMessage: invocation.
 * Loggers may use these methods for thread synchronization or other setup/teardown tasks.
 **/
- (void) didAddLogger;
- (void) willRemoveLogger;

#if GCD_MAYBE_AVAILABLE

/**
 * When Grand Central Dispatch is available
 * each logger is executed concurrently with respect to the other loggers.
 * Thus, a dedicated dispatch queue is used for each logger.
 * Logger implementations may optionally choose to provide their own dispatch queue.
 **/
- (dispatch_queue_t) loggerQueue;

/**
 * If the logger implementation does not choose to provide its own queue,
 * one will automatically be created for it.
 * The created queue will receive its name from this method.
 * This may be helpful for debugging or profiling reasons.
 **/
- (NSString *) loggerName;

#endif

@end