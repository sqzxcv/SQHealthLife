//
//  PAExceptionProtocol.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

typedef enum
{
	Ignore = 0,
	WriteLog = 1,
	ShowWarningDlg = 2,
	CustomException = 3,
	SendEmail = 4,
	Crash = 5,
	PostDataWeb = 6,
	CrashLog = 7,
}ErrorLevel;

typedef NSString* ErrorCode;

@protocol PAExceptionProtocol

/*!
    @function
    @abstract   The Exectue method is written for CustomExceptions. CustomExcepitons inherit from KAException and override the Exctue method.
    @discussion The Exectue method is written for CustomExceptions. CustomExcepitons inherit from KAException and override the Exctue method.
    @param      
    @result     
*/
@required
	- (void) excute;
@end

