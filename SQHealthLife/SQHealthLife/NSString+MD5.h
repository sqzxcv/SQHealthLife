//
//  NSString+MD5.h
//  IntsigBackup
//
//  Created by yoyokko on 11/19/10.
//  Copyright 2010 intsig. All rights reserved.
//

@interface NSString (MD5Hash)

+ (NSString *) md5HashValueWithData: (NSData *) mdData;
+ (NSString *) md5HashValueWithDictionary: (NSDictionary *) mdDictionary;
+ (NSString *) md5HashValueWithString:(NSString *) mdString;
+ (NSString *) md5HashValueWithFile: (NSString *) filePath;

@end


@interface NSString (DeviceSerialNumber)

// return the device's serial number
// for iphone/ipad, reuturn device uniqueIdentifier
// for mac, return cpu serial number
+ (NSString *) deviceSerialNumber;

@end