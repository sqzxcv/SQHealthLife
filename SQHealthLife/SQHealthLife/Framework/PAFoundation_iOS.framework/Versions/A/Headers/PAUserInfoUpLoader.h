//
//  PAUserInfoUpLoader.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAUserInfoUpLoader : NSObject
{
@private
    NSString *zipFilePath_;
}

- (void) startToUpLoad;

@end

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//timeInterval is the interval between two uploadings in seconds.
UIKIT_EXTERN void PARunStatisticsCollection(); // default value is one week
UIKIT_EXTERN void PARunStatisticsCollectionWithTimeInterval(NSTimeInterval timeInterval);

#else

APPKIT_EXTERN void PARunStatisticsCollection(); // default value is one week
APPKIT_EXTERN void PARunStatisticsCollectionWithTimeInterval(NSTimeInterval timeInterval);

#endif

extern NSString * PAUserInfoWillCollectNotification; // client need to write their custom infos in this notification.
extern NSString * PAUserInfoDidCollectNotification;
extern NSString * PAUserInfoWillUploadNotification;
extern NSString * PAUserInfoDidUploadNotification;
extern NSString * PAUserInfoDidUploadFailedNotification;