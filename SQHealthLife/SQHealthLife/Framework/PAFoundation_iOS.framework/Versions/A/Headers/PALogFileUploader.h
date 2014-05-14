//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALogFileUploaderDelegate.h"

@interface PALogFileUploader : NSObject {
	NSObject<PALogFileUploaderDelegate> * delegate_;
	
	//NSString * fileToUpload_;
	NSMutableArray * filesToUpload_;
	
	BOOL deleteFileAfterCompleted_;
	BOOL deleteFileAfterFailed_;
	
	BOOL uploadCompleted_;
}

+ (id)uploaderWithExistingCollectedFile;

- (id)initWithFilePath:(NSString *)filePath delegate:(NSObject<PALogFileUploaderDelegate> *)theDelegate;
- (id)initWithFilePaths:(NSArray *)filePaths delegate:(NSObject<PALogFileUploaderDelegate> *)theDelegate;
//@property (nonatomic, copy) NSString * fileToUpload;
@property (nonatomic, retain) NSMutableArray * filesToUpload;
@property (nonatomic, assign) NSObject<PALogFileUploaderDelegate> * delegate; 

- (void) addFilePathToUpload:(NSString *)filePath;

//! Delete files
//! when dealloc the object, it may delete the file |fileToUpload| according to the settings below.

// Default Value: YES.
// By default, The file |fileToUpload| will be deleted if it is uploaded.
- (void) setDeleteFileAfterUploadingCompleted:(BOOL)flag;

// Default Value: NO.
// By default, The collected file will be kept when the uploading failed.
// Keep the file so you may call uploaderWithExistingCollectedFile later to try again.
- (void) setDeleteFileAfterUploadingFailed:(BOOL)flag;

- (void) startToUpload;

- (void) deleteFiles;

@end
