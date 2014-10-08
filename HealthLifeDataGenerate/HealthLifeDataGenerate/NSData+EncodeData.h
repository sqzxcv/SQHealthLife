#import <Foundation/Foundation.h>

@interface NSData (DDData)

- (NSData *) md5Digest;
- (NSString *) md5String;

- (NSData *) sha1Digest;

- (NSString *) hexStringValue;

- (NSString *) base64Encoded;
- (NSData *) base64Decoded;

@end
