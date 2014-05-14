//
//  PAXMLAttribute.h
//  PAXMLWriter
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlwriter.h>

@interface PAXMLAttribute : NSObject
{
@private
    NSString *name_;
    NSString *value_;
    NSString *prefix_;
    NSString *namespaceURI_;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

// namespace support property.
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *namespaceURI;

+ (PAXMLAttribute *) attributeWithValue:(NSString *) value forName:(NSString *) name;

- (BOOL) writeSelfWithWriter:(xmlTextWriterPtr) writer;

@end
