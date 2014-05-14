//
//  PATTYLogger.h
//  PALog
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAAbstractLogger.h"

@interface PATTYLogger : PAAbstractLogger <PALoggerProtocol>
{
@private
    BOOL isaTTY_;
	
	NSDateFormatter *dateFormatter_;
	
	char *app_; // Not null terminated
	char *pid_; // Not null terminated
	
	size_t appLen_;
	size_t pidLen_;
}

@end
