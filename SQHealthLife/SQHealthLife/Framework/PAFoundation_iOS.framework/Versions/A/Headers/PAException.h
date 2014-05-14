//
//  PAException.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAExceptionProtocol.h"

@interface PAException : NSException <PAExceptionProtocol>
{
@private
	ErrorCode	theErrorCode_;
	ErrorLevel	theErrorLevel_;
	NSString	*stackTrace_;
}

@property (nonatomic, readonly, getter = errorCode) ErrorCode errorCode;
@property (nonatomic, readonly, getter = errorLevel) ErrorLevel errorLevel;
@property (nonatomic, readonly, getter = stackTrace) NSString *stackTrace;

+ (PAException *) exceptionWithSystemException:(NSException *) exception 
                                     errorCode:(ErrorCode) errorCode 
                                    errorLevel:(ErrorLevel) errorLevel;

+ (PAException *) exceptionWithName:(NSString *) name
							  reason:(NSString *) reason
							userInfo:(NSDictionary *) userInfo
						   errorCode:(ErrorCode) errorCode
						  errorLevel:(ErrorLevel) errorLevel;

- (id) initWithName:(NSString *) aName
			 reason:(NSString *) aReason
		   userInfo:(NSDictionary *) aUserInfo
		  errorCode:(ErrorCode) errorCode
		 errorLevel:(ErrorLevel) errorLevel;

+ (void) raise:(NSString *) name
	 errorCode:(ErrorCode) errorCode
	errorLevel:(ErrorLevel) errorLevel
		format:(NSString *) format, ...;

@end
