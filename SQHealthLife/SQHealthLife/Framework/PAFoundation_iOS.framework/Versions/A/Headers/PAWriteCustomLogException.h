//
//  PAWriteCustomLogException.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "PAException.h"


@interface PAWriteCustomLogException : PAException {
	NSMutableString * logDetailString;
}	

- (void) writeLogToFile;

- (NSString *)customNameString;
@end
