//
//  PAXMLDocument.h
//  PAXMLWriter
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlwriter.h>
#import "PAXMLElement.h"
#import "PAXMLAttribute.h"

enum {
    PAXMLMemoryWriter = 1, // XMLWriter will store nodes tree in memory and flush to disk at once
    PAXMLFileWriter = 2,  // XMLWriter will flush to disk immediately
};
typedef NSUInteger PAXMlWriterType;

@interface PAXMLDocument : NSObject
{
@private
    xmlTextWriterPtr writer_;
    PAXMlWriterType writerType_;
    NSString *filePath_;
    PAXMLElement *rootElement_;
    BOOL indent_;
}

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) BOOL indent; // Default is YES.

- (id) initWithType:(PAXMlWriterType) type;

#pragma mark -- Memory Writer API --

@property (nonatomic, retain) PAXMLElement *rootElement;
- (BOOL) flush;
- (BOOL) flushToFilePath:(NSString *) filePath;
- (NSString *) xmlString;
- (NSData *) xmlData;

#pragma mark -- File Writer API --

- (BOOL) startDocument; // Default version = 1.0, encoding = UTF-8
- (BOOL) startDocumentWithVersion:(NSString *) version encoding:(NSString *) encoding;
- (BOOL) startDocumentWithVersion:(NSString *) version encoding:(NSString *) encoding filePath:(NSString *) filePath;
- (BOOL) endDocument;

- (BOOL) startElementWithName:(NSString *) elementName;
- (BOOL) endElement;
- (BOOL) writeElement:(PAXMLElement *) aelement;
- (BOOL) writeElementWithValue:(NSString *) value forName:(NSString *) name;

- (BOOL) writeComment:(NSString *) comment;
- (BOOL) writeAttribute:(PAXMLAttribute *) attribute;
- (BOOL) writeAttributeWithValue:(NSString *) value forName:(NSString *) name;

@end
