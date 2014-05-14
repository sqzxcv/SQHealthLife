//
//  PAIDUtility.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

typedef NSString * PAIDOperationType;

extern PAIDOperationType const INIT_ID_ACTION;
extern PAIDOperationType const LAUNCH_APP_ACTION;
extern PAIDOperationType const TAP_AD_ACTION;
extern PAIDOperationType const QUERY_UPDATE_ACTION;
extern PAIDOperationType const UPDATE_ACTION;

@interface PAIDUtility : NSObject 
{
@private
	NSDictionary *countryMapping_;
}

- (NSString *) threeCountryCodeOfTwoCountryCode:(NSString *) code;

@end

@interface PABugReporter : NSObject
@end


#define PAThirdPartyVenderKey @"PA3PVender"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

UIKIT_EXTERN void PAIDGenerateWithArgument(NSData *deviceToken, NSDictionary *argument);

UIKIT_EXTERN void PAQueryUpdateWithTypeAndArgument(PAIDOperationType type, NSData *deviceToken, NSDictionary *argument);

UIKIT_EXTERN void PAAppSwitchFromBackgroudToForeground(NSData *deviceToken, NSDictionary *argument);

UIKIT_EXTERN NSString * PAAppIDParameterString();

UIKIT_EXTERN NSString * PAIDParameterString();

UIKIT_EXTERN void PABugReport(NSString *bugDescription);

UIKIT_EXTERN NSString * const PAAPPIDExtraUserDefaultsKey; // if client need to add other extra value to appid parameter, just set the string value to this key in user default

#else

APPKIT_EXTERN void PAIDGenerateWithArgument(NSData *deviceToken, NSDictionary *argument);

APPKIT_EXTERN void PAQueryUpdateWithTypeAndArgument(PAIDOperationType type, NSData *deviceToken, NSDictionary *argument);

APPKIT_EXTERN void PAAppSwitchFromBackgroudToForeground(NSData *deviceToken, NSDictionary *argument);

APPKIT_EXTERN NSString * PAAppIDParameterString();

APPKIT_EXTERN NSString * PAIDParameterString();

APPKIT_EXTERN void PABugReport(NSString *bugDescription);

APPKIT_EXTERN NSString * const PAAPPIDExtraUserDefaultsKey; // if client need to add other extra value to appid parameter, just set the string value to this key in user default

#endif

