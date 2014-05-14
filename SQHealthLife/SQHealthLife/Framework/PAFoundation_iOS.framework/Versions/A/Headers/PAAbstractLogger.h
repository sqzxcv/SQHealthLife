//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALoggerProtocol.h"
#import "PALogFormatterProtocol.h"

@interface PAAbstractLogger : NSObject <PALoggerProtocol>
{
@protected
    id <PALogFormatterProtocol> formatter_;
    
#if GCD_MAYBE_AVAILABLE
	dispatch_queue_t loggerQueue_;
#endif
}

- (id <PALogFormatterProtocol>) logFormatter;
- (void) setLogFormatter:(id <PALogFormatterProtocol>) formatter;

@end
