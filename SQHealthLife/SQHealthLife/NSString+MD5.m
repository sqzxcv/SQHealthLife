//
//  NSString+MD5.m
//  IntsigBackup
//
//  Created by yoyokko on 11/19/10.
//  Copyright 2010 intsig. All rights reserved.
//

#import "NSString+MD5.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR	
#import <CommonCrypto/CommonDigest.h>
//#import "UIDevice+PPOSVersion.h"
#else
#import <openssl/md5.h>
#endif

@implementation NSString (MD5Hash)

+ (NSString *) md5HashValueWithData: (NSData *) mdData
{
	unsigned char digest[16];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR			
	CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
	CC_MD5_Update(&md5, [mdData bytes], [mdData length]);
	
    CC_MD5_Final(digest, &md5);
#else
	MD5_CTX context;
	MD5_Init(&context);	
	
	MD5_Update(&context, [mdData bytes], [mdData length]);	
	
	MD5_Final(digest, &context);
#endif
	NSString* astring = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						 digest[0], digest[1], 
						 digest[2], digest[3],
						 digest[4], digest[5],
						 digest[6], digest[7],
						 digest[8], digest[9],
						 digest[10], digest[11],
						 digest[12], digest[13],
						 digest[14], digest[15]];
    return astring;
}

+ (NSString *) md5HashValueWithDictionary: (NSDictionary *) mdDictionary
{
	NSString *error;
	
	NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:mdDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	if(xmlData)
	{
		return [self md5HashValueWithData:xmlData];
	}
	else
	{
		return @"";
	}
}

+ (NSString *) md5HashValueWithString:(NSString *) mdString
{
	NSData *stringData = [[[NSData alloc] initWithData:[mdString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
	if (stringData)
	{
		return [self md5HashValueWithData:stringData];
	}
	else
	{
		return @"";
	}
}

+ (NSString *) md5HashValueWithFile: (NSString *) filePath
{
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (handle == nil) 
	{
		// edited by mkevin:20101209 
		// return nil instead of magic string when error occurred.
		
		//return @"ERROR GETTING FILE MD5"; // file didnt exist
		return @"";
	}
	unsigned char digest[16];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR	
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSData* fileData = [handle readDataOfLength:32768];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
        
        [pool release];
    }
    CC_MD5_Final(digest, &md5);
    
#else
	MD5_CTX context;
	MD5_Init(&context);	
	BOOL done = NO;
    while(!done)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSData* fileData = [handle readDataOfLength:32768];
        MD5_Update(&context, [fileData bytes], [fileData length]);	
        if( [fileData length] == 0 ) done = YES;
        
        [pool release];
    }
	MD5_Final(digest, &context);
#endif
	NSString* aString = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						 digest[0], digest[1], 
						 digest[2], digest[3],
						 digest[4], digest[5],
						 digest[6], digest[7],
						 digest[8], digest[9],
						 digest[10], digest[11],
						 digest[12], digest[13],
						 digest[14], digest[15]];
    return aString;
}

@end

@implementation NSString (DeviceSerialNumber)

+ (NSString *) deviceSerialNumber
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    return [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
#else
    // get mac serial number with apple script
	NSDictionary *errorDict = nil;
	
	NSAppleScript *scriptObject = [[NSAppleScript alloc] initWithSource:@"\
								   set SerialNumber to word -1 of (do shell script \"ioreg -l | grep IOPlatformSerialNumber\") \n\
								   return SerialNumber"
								   ];
	NSString *value = [[scriptObject executeAndReturnError:&errorDict] stringValue];
	[scriptObject release];
	
	return value;
#endif
}

@end