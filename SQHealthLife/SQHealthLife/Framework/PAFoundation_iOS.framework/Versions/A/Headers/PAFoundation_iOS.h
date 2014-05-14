//
//  PAFoundation_iOS.h
//  PAFoundation
//
//  Created by ShengQiang on 14-3-5.
//  Copyright (c) 2014年 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// Optional configuration keys in applicaiton's Info.plist file.
////////////////////////////////////////////////////////////////////////////////

/*!
 @name:     PALogMaxNormalLogFileSize
 @type:     NSNumber (unsigned long long)
 @default:  kMaxNormalLogFileSize (5MB)
 @abstract: Unit of B. If you want to use 10M, it should be 10*1024*1024
 */

/*!
 @name:     PALogFileSizeCheckTime
 @type:     NSNumber (double)
 @default:  kLogFileSizeCheckTime (24hour)
 @abstract: Unit of second. If you want to use 1 hour, it should be 60*60;
 */

/*!
 @name:     PALogFileMaxNumber
 @type:     NSNumber (int)
 @default:  kLogFileMaxNumber (2)
 @abstract: Unit of int. Default is 2 log files;
 */

/*!
 @name:     PAEmailUploaderReceivers
 @type:     NSArray (string value)
 @default:  report_error@intsig.com
 @abstract: You can set other receivers' email.;
 */

/*!
 @name:     PALoggerNames
 @type:     NSArray (string value)
 @default:  PATTYLogger & PAFileLogger.
 @abstract: There are three loggers in log module. PATTYLogger, PAFileLogger, PAASLLogger.
 Of cause you can write your custom logger in your application. Just inherit from PAAbstractLogger.
 And you can set your own custom log formatters.
 
 PATTYLogger means print logs into XCode console.
 PAFileLogger means print logs into files. You can find files with PALogFileManager.
 PAASLLogger means print logs into Apple System Log. That is you can find your logs in Console.app.
 If you set none of value above or the logger name in your application, you will got nothing.
 */

////////////////////////////////////////////////////////////////////////////////
// Required configuration keys in applicaiton's Info.plist file.
////////////////////////////////////////////////////////////////////////////////



/*!
 @name:     PAProductName
 @type:     NSString
 @default:  nil
 @abstract: You should set this value with following format. AppName_Platform_Type.
 Type is optional. Platform should be one of these values: IP-iPhone, BB-BlackBerry, AD-Android.
 Such as CamCard_AD_WE, CamCard_IP_ENFULL.
 */

#import <PAFoundation_iOS/ASIAuthenticationDialog.h>
#import <PAFoundation_iOS/ASICacheDelegate.h>
#import <PAFoundation_iOS/ASIDataCompressor.h>
#import <PAFoundation_iOS/ASIDataDecompressor.h>
#import <PAFoundation_iOS/ASIDownloadCache.h>
#import <PAFoundation_iOS/ASIFormDataRequest.h>
#import <PAFoundation_iOS/ASIHTTPRequest.h>
#import <PAFoundation_iOS/ASIHTTPRequestConfig.h>
#import <PAFoundation_iOS/ASIHTTPRequestDelegate.h>
#import <PAFoundation_iOS/ASIInputStream.h>
#import <PAFoundation_iOS/ASINetworkQueue.h>
#import <PAFoundation_iOS/ASIProgressDelegate.h>
#import <PAFoundation_iOS/PAAbstractLogger.h>
#import <PAFoundation_iOS/PAException.h>
#import <PAFoundation_iOS/PAExceptionHandler.h>
#import <PAFoundation_iOS/PAExceptionProtocol.h>
#import <PAFoundation_iOS/PAIDUtility.h>
#import <PAFoundation_iOS/PALog.h>
#import <PAFoundation_iOS/PALogFileCollector.h>
#import <PAFoundation_iOS/PALogFileEmailUploader.h>
#import <PAFoundation_iOS/PALogFileManager.h>
#import <PAFoundation_iOS/PALogFileUploader.h>
#import <PAFoundation_iOS/PALogFileUploaderDelegate.h>
#import <PAFoundation_iOS/PALogFileWebPostUploader.h>
#import <PAFoundation_iOS/PALogFormatterProtocol.h>
#import <PAFoundation_iOS/PALoggerProtocol.h>
#import <PAFoundation_iOS/PALowMemoryException.h>
#import <PAFoundation_iOS/PASystemSIGException.h>
#import <PAFoundation_iOS/PAUncaughtException.h>
#import <PAFoundation_iOS/PAUserInfoUpLoader.h>
#import <PAFoundation_iOS/PAWriteCustomLogException.h>
#import <PAFoundation_iOS/PAKeychainAccessor.h>
#import <PAFoundation_iOS/PAKeychainAccessor+QuickAccess.h>
#import <PAFoundation_iOS/PAKeychainAccessor+Array.h>
#import <PAFoundation_iOS/Reachability.h>
#import <PAFoundation_iOS/UIDevice+PPOSVersion.h>
#import <PAFoundation_iOS/ZKArchive.h>
#import <PAFoundation_iOS/ZKDataArchive.h>
#import <PAFoundation_iOS/ZKFileArchive.h>
#import <PAFoundation_iOS/PASystemVersion.h>
#import <PAFoundation_iOS/UIButton+WebCache.h>
#import <PAFoundation_iOS/UIImage+GIF.h>
#import <PAFoundation_iOS/UIImage+MultiFormat.h>
#import <PAFoundation_iOS/UIImage+WebP.h>
#import <PAFoundation_iOS/UIImageView+WebCache.h>
#import <PAFoundation_iOS/PACache.h>
#import <PAFoundation_iOS/NSData+EncodeData.h>
#import <PAFoundation_iOS/NSString+URLEncode.h>

UIKIT_EXTERN BOOL isLite();
