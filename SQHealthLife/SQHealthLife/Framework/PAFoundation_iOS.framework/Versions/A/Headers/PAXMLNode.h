//
//  PAXMLNode.h
//  PAXMLWriter
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlwriter.h>

@interface PAXMLNode : NSObject
{
@protected
    NSString *comment_;
    NSString *name_;
    NSString *value_;
    NSMutableArray *attributes_;
    NSMutableArray *children_;
}

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, retain) NSMutableArray *attributes;
@property (nonatomic, retain) NSMutableArray *children;

@end
