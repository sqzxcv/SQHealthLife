//
//  PAXMLElement.h
//  PAXMLWriter
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "PAXMLNode.h"
#import <libxml/xmlwriter.h>

@class PAXMLAttribute;

@interface PAXMLElement : PAXMLNode
{
@private
    NSString *prefix_;
    NSString *namespaceURI_;
}
// namespace support property.
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *namespaceURI;

- (void) addChild:(PAXMLNode *) child;
- (void) removeChild:(PAXMLNode *) child;

- (void) addAttribute:(PAXMLAttribute *) attribute;
- (void) removeAttribute:(PAXMLAttribute *) attribute;

+ (PAXMLElement *) xmlElementForName:(NSString *) name;
+ (PAXMLElement *) xmlElementWithClild:(PAXMLElement *) child forName:(NSString *) name;
+ (PAXMLElement *) xmlElementWithClildren:(NSArray *) children forName:(NSString *) name;
+ (PAXMLElement *) xmlElementWithValue:(NSString *) value forName:(NSString *) name;

- (BOOL) writeSelfWithWriter:(xmlTextWriterPtr) writer;

@end
