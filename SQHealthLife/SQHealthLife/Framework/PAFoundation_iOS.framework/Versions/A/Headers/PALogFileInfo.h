//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PALogFileInfo : NSObject 
{
@private
    NSString    *filePath_;
    NSString    *fileName_;
    
    NSDictionary    *fileAttributes_;
    
    NSDate      *creationDate_;
    NSDate      *modificationDate_;
    
    unsigned long long fileSize_;
}

@property (nonatomic, readonly, getter=filePath) NSString *filePath;
@property (nonatomic, readonly, getter=fileName) NSString *fileName;
@property (nonatomic, readonly, getter=fileAttributes) NSDictionary *fileAttributes;
@property (nonatomic, readonly, getter=creationDate) NSDate *creationDate;
@property (nonatomic, readonly, getter=modificationDate) NSDate *modificationDate;
@property (nonatomic, readonly, getter=fileSize) unsigned long long fileSize;
@property (nonatomic, readonly, getter=age) NSTimeInterval age;
@property (nonatomic, readwrite) BOOL isArchived;
@property (nonatomic, readwrite) BOOL isCollected;


+ (id) logFileWithPath:(NSString *) filePath;
- (id) initWithFilePath:(NSString *) filePath;

- (void) renameFile:(NSString *) newFileName;
- (void) reset;

#if TARGET_IPHONE_SIMULATOR

// So here's the situation.
// Extended attributes are perfect for what we're trying to do here (marking files as archived).
// This is exactly what extended attributes were designed for.
// 
// But Apple screws us over on the simulator.
// Everytime you build-and-go, they copy the application into a new folder on the hard drive,
// and as part of the process they strip extended attributes from our log files.
// Normally, a copy of a file preserves extended attributes.
// So obviously Apple has gone to great lengths to piss us off.
// 
// Thus we use a slightly different tactic for marking log files as archived in the simulator.
// That way it "just works" and there's no confusion when testing.
// 
// The difference in method names is indicative of the difference in functionality.
// On the simulator we add an attribute by appending a filename extension.
// 
// For example:
// log-ABC123.txt -> log-ABC123.archived.txt

- (BOOL) hasExtensionAttributeWithName:(NSString *) attrName;

- (void) addExtensionAttributeWithName:(NSString *) attrName;
- (void) removeExtensionAttributeWithName:(NSString *) attrName;

#else

// Normal use of extended attributes used everywhere else,
// such as on Macs and on iPhone devices.

- (BOOL) hasExtendedAttributeWithName:(NSString *) attrName;

- (void) addExtendedAttributeWithName:(NSString *) attrName;
- (void) removeExtendedAttributeWithName:(NSString *) attrName;

#endif

- (NSComparisonResult) reverseCompareByCreationDate:(PALogFileInfo *) another;
- (NSComparisonResult) reverseCompareByModificationDate:(PALogFileInfo *) another;

@end
