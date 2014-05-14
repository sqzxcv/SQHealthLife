//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

@class PALogFileUploader;


typedef enum {
	PABasicUploaderErrorNone = 0,											// not used.
																										// Common Error.
	PABasicUploaderErrorFileNotExist = 100,
																										// used by email uploader.
	PABasicUploaderErrorUserCanceled = 200,
	PABasicUploaderErrorSaved,
																										// used by web post.
	PABasicUploaderErrorNetworkDown = 300,
																										// not used.
	PABasicUploaderErrorUnknown = 400
} PABasicUploaderError;

//! There is no guarantee that any of the delegate method will be called.

@protocol PALogFileUploaderDelegate <NSObject>

@optional
- (void)logFileUploaderDidFinishUploading:(PALogFileUploader *)uploader;

// the error code can be find in PABasicUploaderError.
- (void)logFileUploader:(PALogFileUploader *)uploader didFailedUploadingWithError:(NSError *)error;
- (void)logFileUploader:(PALogFileUploader *)uploader uploadingProgress:(float)progress;

@end