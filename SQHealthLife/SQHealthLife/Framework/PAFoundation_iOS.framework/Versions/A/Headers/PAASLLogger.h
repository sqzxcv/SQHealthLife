//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAAbstractLogger.h"
#import <asl.h>

@interface PAASLLogger : PAAbstractLogger <PALoggerProtocol>
{
@private
    aslclient client_;
}

@end
