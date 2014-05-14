//
//  UIDevice+PPOSVersion.h
//  PABasic
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
	DeviceModelUnknown,
    DeviceModeliPhone3G,
	DeviceModeliPhone3GS,
	DeviceModeliPhone4,
    DeviceModeliPhone4s,
    DeviceModeliPhone5,
	DeviceModeliPod,
    DeviceModeliPod5,
    DeviceModeliPad,
    DeviceModeliPad2,
    DeviceModeliPadMini,
    DeviceModelNewiPad,
    DeviceModeliPad4,
}DeviceModel;

@interface UIDevice (PPOSVersion)

- (BOOL) isiPod;
- (BOOL) isiPad;
- (BOOL) isiPadStyle;
- (BOOL) isios4;
- (BOOL) is3_1;
- (BOOL) is3_2;
- (BOOL) is4_0;
- (BOOL) is4_1;
- (BOOL) is4_2;
- (BOOL) isios4OrLater;
- (BOOL) is4_2OrLater;
- (BOOL) is5_0OrLater;

- (DeviceModel) deviceModel;

@end


@interface UIDevice (Memory)

/*
 * Available device memory in MB 
 */
@property(readonly) double availableMemory;
@property(readonly) double usedMemory;			// this one is not trusted.

@end

@interface UIDevice (JailBreak)

- (BOOL) hasAPT;
- (BOOL) successToCallSystem;

@end


@interface UIDevice (HardWare)

- (NSString *) platform;
- (NSString *) hwmodel;

- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;		// user memory, not used memory.

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) isUniqueDeviceIdentifier;

- (NSString *) uniqueDeviceIdentifier;
- (NSString *) uniqueGlobalDeviceIdentifier;



@end

