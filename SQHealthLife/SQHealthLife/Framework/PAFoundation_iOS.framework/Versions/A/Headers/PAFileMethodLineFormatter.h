//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALogFormatterProtocol.h"

@interface PAFileMethodLineFormatter : NSObject <PALogFormatterProtocol>
{
@private
    NSDateFormatter *dateFormatter_;
}
@property (retain) NSDateFormatter *dateFormatter;
@end
