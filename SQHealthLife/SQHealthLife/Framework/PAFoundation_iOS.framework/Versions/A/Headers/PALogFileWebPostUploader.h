//
//  PALogFileWebPostUploader.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "PALogFileUploader.h"
@interface PALogFileWebPostUploader : PALogFileUploader {
	NSURL * targetURL_;
}

// the default target url will be load from info.plist.
@property (nonatomic, retain) NSURL * targetURL;

@end