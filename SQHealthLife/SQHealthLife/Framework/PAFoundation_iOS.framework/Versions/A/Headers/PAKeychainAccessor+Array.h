//
//  PAKeychainAccessor+Array.h
//  PAFoundation
//
//  Created by S Q on 13-4-3.
//
//

#import <PAFoundation_iOS/PAKeychainAccessor.h>

@interface PAKeychainAccessor (Array)

+ (BOOL) addToKeychainUsingName:(NSString *) name andArray:(NSArray *) array andServiceName:(NSString *) serviceName error:(NSError **) error;

+ (NSArray *) arrayForName:(NSString *) name andServiceName:(NSString *) serviceName error:(NSError **) error;

@end
