//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#ifdef TARGET_OS_IPHONE

#import "PALogFileUploader.h"
#import <MessageUI/MessageUI.h>

// ---Application Optional Configure Key---
// PAEmailUploaderReceivers			:	NSArray			: default	: report_error@intsig.com

// ---Delete Files:
// edited by Kevin_Cao, 2011/8/4
// EmailUploader: the default value of |deleteFileAfterFailed_| is YES; 

//! To use this class, you may need to localize these strings.
/*
 "Error" = "Error";
 "Please configure your mail account." = "Please configure your mail account.";
 "OK" = "OK";
 */


@interface PALogFileEmailUploader : PALogFileUploader <MFMailComposeViewControllerDelegate>
{
	NSArray     *receivers_;
	NSString    *subject_;
    NSString    *messageBody_;
    BOOL        isHTML_;
	
	NSString    *fileMIMEType_;
	
	UIViewController * parentViewController_;
    UIColor     *tintColor_;
}

// the default receivers will be loaded from info.plist.
@property (nonatomic, retain) NSArray   *receivers;

@property (nonatomic, copy) NSString    *subject;
@property (nonatomic, copy) NSString    *messageBody;
@property (nonatomic, assign) BOOL      isHTML;
@property (nonatomic, retain) UIColor   *tintColor;


// the MIME type for the |fileToUpload|, as specified by the IANA
// ( http://www.iana.org/assignments/media-types/ ). Must not be nil.
// by default, it is setted to zip file. (applciation/zip).
@property (nonatomic, copy) NSString    *fileMIMEType;

@property (nonatomic, retain) UIViewController * parentViewController;

@end

#endif