//
//  PALogFormatterProtocol.h
//  PALog
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "PALog.h"

@class PALogMessage;

@protocol PALogFormatterProtocol <NSObject>

@required

- (NSString *) formatLogMessage:(PALogMessage *) logMessage;

@end
